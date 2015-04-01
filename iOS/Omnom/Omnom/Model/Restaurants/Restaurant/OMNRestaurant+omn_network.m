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
#import "OMNTable+omn_network.h"
#import <BlocksKit.h>

@implementation OMNRestaurant (omn_network)

- (void)handleEnterEventWithCompletion:(dispatch_block_t)completionBlock {
  
  if ([self readyForEnter]) {
  
    [self setLastEntarDate:[NSDate date]];
    [[OMNAnalitics analitics] logEnterRestaurant:self mode:kRestaurantEnterModeBackground];
    [self nearbyWithCompletion:completionBlock];
    
  }
  else {
    
    completionBlock();
    
  }
  
}

- (void)handleAtTheTableEventWithCompletion:(dispatch_block_t)completionBlock {
  
  if (self.hasTable) {
    
    [[OMNAnalitics analitics] logEnterRestaurant:self mode:kRestaurantEnterModeBackgroundTable];
    [self showGreetingPushIfPossible];
    OMNTable *table = [self.tables firstObject];
    [self entranceWithCompletion:^{
    
      [table newGuestWithCompletion:completionBlock];
      
    }];
  }
  else {
    
    completionBlock();
    
  }
  
}

- (void)getDeliveryAddressesWithCompletion:(OMNAddressesBlock)addressesBlock failure:(void(^)(OMNError *error))failureBlock {
  
  NSArray *a = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"suncity_addresses.json" ofType:nil]] options:kNilOptions error:nil];
  
  NSArray *addresses = [a bk_map:^id(id obj) {
    
    return [[OMNRestaurantAddress alloc] initWithJsonData:obj];
    
  }];
  addressesBlock(addresses);
  
}

- (NSDate *)lastEnterDate {
  
  NSMutableDictionary *lastEnterDates = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEnterDates"];
  return lastEnterDates[self.id];
  
}

- (void)setLastEntarDate:(NSDate *)date {
  
  NSMutableDictionary *lastEnterDates = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastEnterDates"] mutableCopy];
  if (!lastEnterDates) {
    lastEnterDates = [NSMutableDictionary dictionary];
  }
  lastEnterDates[self.id] = date;
  [[NSUserDefaults standardUserDefaults] setObject:lastEnterDates forKey:@"lastEnterDates"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
}

- (NSDate *)lastPushDate {
  
  NSMutableDictionary *lastPushDates = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPushDates"];
  return lastPushDates[self.id];
  
}

- (void)setLastPushDate:(NSDate *)date {
  
  NSMutableDictionary *lastPushDates = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastPushDates"] mutableCopy];
  if (!lastPushDates) {
    lastPushDates = [NSMutableDictionary dictionary];
  }
  lastPushDates[self.id] = date;
  [[NSUserDefaults standardUserDefaults] setObject:lastPushDates forKey:@"lastPushDates"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
}

- (BOOL)readyForPush {
  
#if DEBUG
  return YES;
#endif
  
  if (!self.id) {
    return NO;
  }
  
  if ([OMNConstants disableOnEntrancePush]) {
    return NO;
  }
  
  if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
    return NO;
  }

  BOOL readyForPush = YES;
  const NSTimeInterval timeIntervalForLocalPush = 4.0*60.0*60.0;
  NSDate *lastPushDate = [self lastPushDate];
  
  if (lastPushDate &&
      [lastPushDate timeIntervalSinceDate:[NSDate date]] < timeIntervalForLocalPush) {
    
    readyForPush = NO;
    
  }
  
  return readyForPush;
  
}

- (BOOL)readyForEnter {
  
#if DEBUG
  return YES;
#endif
  
  BOOL readyForEnter = YES;
  const NSTimeInterval timeIntervalForEnter = 20.0*60.0;
  NSDate *lastEnterDate = [self lastEnterDate];
  if (lastEnterDate &&
      [lastEnterDate timeIntervalSinceDate:[NSDate date]] < timeIntervalForEnter) {
    
    readyForEnter = NO;
    
  }
  
  return readyForEnter;
  
}

- (void)showGreetingPushIfPossible {
  
  if ([self readyForPush]) {
    
    [self setLastPushDate:[NSDate date]];
    
    OMNPushText *at_entrance = self.mobile_texts.at_entrance;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = at_entrance.greeting;
    localNotification.alertAction = at_entrance.open_action;
    localNotification.soundName = kPushSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];

  }

  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  //    if ([localNotification respondsToSelector:@selector(category)]) {
  //      [localNotification performSelector:@selector(setCategory:) withObject:@"incomingCall"];
  //    }
#pragma clang diagnostic pop
  
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
  
  [[OMNOperationManager sharedManager] GET:@"/restaurants/all" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject omn_decodeWithRestaurantsBlock:restaurantsBlock failureBlock:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (NSString *)wishType {
  return (kRestaurantModeLunch == self.entrance_mode) ? (@"lunch") : (@"pre_order");
}

- (void)createWishForTable:(OMNTable *)table products:(NSArray *)products completionBlock:(OMNWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  if (table.internal_id) {
    parameters[@"internal_table_id"] = table.internal_id;
  }
  if (table.id) {
    parameters[@"table_id"] = table.id;
  }
  if (products) {
    parameters[@"items"] = products;
  }
  parameters[@"type"] = [self wishType];
  if (self.delivery) {
    parameters[@"delivery_address"] = self.delivery.addressData;
  }
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/wishes", self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    OMNWish *wish = [[OMNWish alloc] initWithJsonData:responseObject];
    completionBlock(wish);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    //    Формат - статус код 409, массив skip_id:[]
    if (409 == error.code) {

      wrongIDsBlock(operation.responseObject[@"skip_id"]);
      
    }
    else {
    
      failureBlock([error omn_internetError]);
      
    }
    
  }];
  
}

- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))errorBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/advertisement", self.id];
  @weakify(self)
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if (response &&
        [response isKindOfClass:[NSDictionary class]] &&
        response[@"title"]) {
      
      @strongify(self)
      OMNRestaurantInfo *restaurantInfo = [[OMNRestaurantInfo alloc] initWithJsonData:response];
      self.info = restaurantInfo;
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

- (void)nearbyWithCompletion:(dispatch_block_t)completionBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/nearby", self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    DDLogDebug(@"nearby>%@", responseObject);
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    DDLogError(@"nearby>%@", error);
    completionBlock();
    
  }];
  
}

- (void)entranceWithCompletion:(dispatch_block_t)completionBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/entrance", self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    DDLogInfo(@"path>%@", responseObject);
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    completionBlock();
    
  }];
  
}

- (void)leaveWithCompletion:(dispatch_block_t)completionBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/leave", self.id];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    DDLogInfo(@"path>%@", responseObject);
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    completionBlock();
    
  }];
  
}

- (void)getMenuWithCompletion:(OMNMenuBlock)completion {

  if (NO) {
    id data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_stub1.json" ofType:nil]] options:kNilOptions error:nil];
    OMNMenu *menu = [[OMNMenu alloc] initWithJsonData:data[@"menu"]];
    completion(menu);
    return;
  }

  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/menu", self.id];
  @weakify(self)
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject omn_isSuccessResponse]) {

      OMNMenu *menu = [[OMNMenu alloc] initWithJsonData:responseObject[@"menu"]];
      completion(menu);
      
    }
    else {
    
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_MENU" jsonRequest:path responseOperation:operation];
      completion(nil);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_MENU" jsonRequest:path responseOperation:operation];
    @strongify(self)
    [self getMenuWithCompletion:completion];
    
  }];
  
}


- (void)getRecommendationItems:(OMNProductItemsBlock)productItemsBlock error:(void(^)(OMNError *error))errorBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/recommendations", self.id];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:[response count]];
    [response enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
      
      if (item[@"id"]) {
        [items addObject:item[@"id"]];
      }
      
    }];
    
    productItemsBlock(items);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_PRODUCT_ITEMS" jsonRequest:path responseOperation:operation];
    errorBlock([error omn_internetError]);
    
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
  NSArray *restaurants = [restaurantsData bk_map:^id(id restaurantData) {
    
    return [[OMNRestaurant alloc] initWithJsonData:restaurantData];
    
  }];
  
  return restaurants;
  
}

@end
