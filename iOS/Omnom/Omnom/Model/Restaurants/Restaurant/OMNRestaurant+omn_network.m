//
//  OMNRestaurant+omn_network.m
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant+omn_network.h"
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"
#import "OMNOrder+network.h"
#import "OMNTable+omn_network.h"

@implementation OMNRestaurant (omn_network)

- (void)handleEnterEventWithCompletion:(dispatch_block_t)completionBlock {
  
  [[OMNAnalitics analitics] logEnterRestaurant:self mode:kRestaurantEnterModeBackground];
  if (completionBlock) {
    completionBlock();
  }
  
}

- (NSString *)path {
  
  NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  return [documentsDirectory stringByAppendingPathComponent:@"restaurant_push_data.dat"];
  
}

- (void)handleAtTheTableEvent1WithCompletion:(dispatch_block_t)completionBlock {
  
  if (!self.id ||
      [OMNConstants disableOnEntrancePush]) {
    
    if (completionBlock) {
      
      completionBlock();
      
    }
    return;
  }
  
  NSString *path = [self path];
  NSMutableDictionary *restaurant_push_data = [NSMutableDictionary dictionaryWithContentsOfFile:path];
  if (!restaurant_push_data) {
    
    restaurant_push_data = [NSMutableDictionary dictionary];
    
  }
  NSDate *date = restaurant_push_data[self.id];
  if (nil == date ||
      [[NSDate date] timeIntervalSinceDate:date] > 4*60*60) {

    OMNPushText *at_entrance = self.mobile_texts.at_entrance;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = at_entrance.greeting;
    localNotification.alertAction = at_entrance.open_action;
    localNotification.soundName = kPushSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];

    restaurant_push_data[self.id] = [NSDate date];
    [restaurant_push_data writeToFile:path atomically:YES];
    
  }
  
  completionBlock();
  
}

- (void)handleAtTheTableEventWithCompletion:(dispatch_block_t)completionBlock {
  
  [[OMNAnalitics analitics] logEnterRestaurant:self mode:kRestaurantEnterModeBackgroundTable];
  [self showGreetingPush];
  
  if (1 == self.tables.count) {
    
    OMNTable *table = [self.tables firstObject];
    [table newGuestWithCompletion:completionBlock];
    
  }
  else {
    
    completionBlock();
    
  }
  
}

- (BOOL)readyForPush {
  
  if (UIApplicationStateActive == [UIApplication sharedApplication].applicationState) {
    return NO;
  }
//  BOOL readyForPush = ([[NSDate date] timeIntervalSinceDate:self.foundDate] > 4*60*60);
  BOOL readyForPush = YES;
  return readyForPush;
  
}

- (void)showGreetingPush {
  
  if (!self.readyForPush) {
    return;
  }
  
  OMNPushText *at_entrance = self.mobile_texts.at_entrance;
  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  
  localNotification.alertBody = at_entrance.greeting;
  localNotification.alertAction = at_entrance.open_action;
  localNotification.soundName = kPushSoundName;
  [[OMNAnalitics analitics] logDebugEvent:@"push_sent" parametrs:@{@"text" : (at_entrance.greeting ? (at_entrance.greeting) : (@""))}];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  //    if ([localNotification respondsToSelector:@selector(category)]) {
  //      [localNotification performSelector:@selector(setCategory:) withObject:@"incomingCall"];
  //    }
#pragma clang diagnostic pop
  
  localNotification.userInfo =
  @{
    OMNRestaurantNotificationLaunchKey : [NSKeyedArchiver archivedDataWithRootObject:self],
    };
  [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
  
}

+ (void)getRestaurantsForLocation:(CLLocationCoordinate2D)coordinate withCompletion:(OMNRestaurantsBlock)restaurantsBlock failure:(void(^)(OMNError *error))failureBlock {
  
  NSDictionary *parameters = nil;
  
  if (CLLocationCoordinate2DIsValid(coordinate) &&
      fabs(coordinate.latitude) > 0.0001 &&
      fabs(coordinate.longitude) > 0.0001) {
    
    parameters =
    @{
      @"latitude" : @(coordinate.latitude),
      @"longitude" : @(coordinate.longitude),
      };
    
  }
  
  [[OMNOperationManager sharedManager] GET:@"restaurants" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject omn_decodeWithRestaurantsBlock:restaurantsBlock failureBlock:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)createOrderForTableID:(NSString *)tableID products:(NSArray *)products block:(OMNOrderBlock)block failureBlock:(void(^)(NSError *error))failureBlock {
  
  if (0 == tableID.length) {
    failureBlock(nil);
    return;
  }
  
  NSMutableArray *items = [NSMutableArray arrayWithCapacity:products.count];
  
  [products enumerateObjectsUsingBlock:^(OMNMenuProduct *menuItem, NSUInteger idx, BOOL *stop) {
    
    NSDictionary *item =
    @{
      @"internalId" : menuItem.internalId,
      @"" : @(menuItem.quantity),
      };
    [items addObject:item];
    
  }];
  
  __unused NSDictionary *info =
  @{
    @"restaurantId" : self.id,
    @"tableId" : tableID,
    @"items" : items,
    };
  
}

- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))errorBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/advertisement", self.id];
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if (response &&
        [response isKindOfClass:[NSDictionary class]] &&
        response[@"title"]) {
      
      OMNRestaurantInfo *restaurantInfo = [[OMNRestaurantInfo alloc] initWithJsonData:response];
      weakSelf.info = restaurantInfo;
      completionBlock(restaurantInfo);
      
    }
    else {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_RESTAURANT_ADVERTISMENT" jsonRequest:path responseOperation:operation];
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_RESTAURANT_ADVERTISMENT" jsonRequest:path responseOperation:operation];
    errorBlock(error);
    
  }];
}

- (void)nearby {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/nearby", self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"nearby>%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];
  
}

- (void)entrance {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/entrance", self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"entrance>%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];
  
}

- (void)leave {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/leave", self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"leave>%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];
  
}

@end


@implementation NSObject (omn_restaurants)

- (void)omn_decodeWithRestaurantsBlock:(OMNRestaurantsBlock)restaurantsBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  
  if (![self isKindOfClass:[NSDictionary class]]) {
    failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
    return;
  }
  
  NSDictionary *dictionary = (NSDictionary *)self;
  
  NSArray *restaurantsObjects = dictionary[@"items"];
  
  NSMutableArray *restaurants = [NSMutableArray arrayWithCapacity:restaurantsObjects.count];
  
  for (id restaurantsObject in restaurantsObjects) {
    
    OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithJsonData:restaurantsObject];
    [restaurants addObject:restaurant];
    
  }
  
  restaurantsBlock([restaurants copy]);
  
}

- (NSArray *)omn_restaurants {
  
  if (![self isKindOfClass:[NSArray class]]) {
    return @[];
  }
  
  NSArray *restaurantsData = (NSArray *)self;
  NSMutableArray *restaurants = [NSMutableArray arrayWithCapacity:restaurantsData.count];
  [restaurantsData enumerateObjectsUsingBlock:^(id restaurantData, NSUInteger idx, BOOL *stop) {
    
    OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithJsonData:restaurantData];
    [restaurants addObject:restaurant];
    
  }];
  
  return [restaurants copy];
  
}

@end
