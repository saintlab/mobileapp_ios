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
#import "OMNConstants.h"
#import <OMNDevicePositionManager.h>

@implementation OMNRestaurant (omn_network)

- (PMKPromise *)foundInBackground {
  
  if (self.hasTable) {
    
    return [OMNDevicePositionManager onTable].then(^{
      
      return [self handleAtTheTableEvent];
      
    }).catch(^(OMNError *error) {
      
      return [self handleEnterEvent];
      
    });
    
  }
  else {
    
    return [self handleEnterEvent];
    
  }
  
}

- (PMKPromise *)handleEnterEvent {
  
  if ([self readyForEnter]) {
    
    [self setLastEntarDate:[NSDate date]];
    [[OMNAnalitics analitics] logEnterRestaurant:self mode:kRestaurantEnterModeBackground];
    return [self nearby];
    
  }
  else {
    
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
      fulfill(nil);
    }];
    
  }
  
}

- (PMKPromise *)handleAtTheTableEvent {
  
  if (self.hasTable) {
   
    [[OMNAnalitics analitics] logEnterRestaurant:self mode:kRestaurantEnterModeBackgroundTable];
    [self showGreetingPushIfPossible];
    OMNTable *table = [self.tables firstObject];
    return [PMKPromise all:@[[self entrance], [table newGuest]]];
    
  }
  else {
    return nil;
  }
  
}

- (void)getDeliveryAddressesWithCompletion:(OMNAddressesBlock)addressesBlock failure:(void(^)(OMNError *error))failureBlock {
  
  NSArray *a = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"suncity_addresses.json" ofType:nil]] options:kNilOptions error:nil];
  
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
#else
  
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
#endif
  
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
  
}

+ (PMKPromise *)restaurantWithID:(NSString *)restaurantID {
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@", restaurantID];

  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithJsonData:responseObject];
      fulfill(restaurant);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([operation omn_internetError]);
      
    }];

  }];
  
}

+ (PMKPromise *)restaurantsForLocation:(CLLocationCoordinate2D)coordinate {
  
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
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] GET:@"/restaurants/all" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      fulfill([responseObject omn_decodeRestaurants]);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([operation omn_internetError]);
      
    }];

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

- (PMKPromise *)nearby {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/nearby", self.id];
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      DDLogDebug(@"nearby>%@", responseObject);
      fulfill(nil);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      DDLogError(@"nearby>%@", error);
      fulfill(nil);
      
    }];

  }];
  
}

- (PMKPromise *)entrance {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/entrance", self.id];
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      fulfill(nil);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      fulfill(nil);
      
    }];

  }];
  
}

- (PMKPromise *)leave {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/leave", self.id];
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      fulfill(nil);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      fulfill(nil);
      
    }];

  }];
  
}

- (PMKPromise *)getRecommendationItems {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/recommendations", self.id];
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *response) {
      
      if (![response isKindOfClass:[NSArray class]]) {
        fulfill(@[]);
        return;
      }
      
      NSMutableArray *items = [NSMutableArray arrayWithCapacity:[response count]];
      [response enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        
        if (item[@"id"]) {
          [items addObject:item[@"id"]];
        }
        
      }];
      
      fulfill(items);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_GET_PRODUCT_ITEMS" jsonRequest:path responseOperation:operation];
      reject([operation omn_internetError]);
      
    }];
    
  }];
  
}

@end


@implementation NSObject (omn_restaurants)

- (NSArray *)omn_decodeRestaurants {
  
  if (![self isKindOfClass:[NSDictionary class]]) {
    return @[];
  }
  
  NSDictionary *dictionary = (NSDictionary *)self;
  
  NSArray *restaurantsObjects = dictionary[@"items"];
  
  NSMutableArray *restaurants = [NSMutableArray arrayWithCapacity:restaurantsObjects.count];
  
  for (id restaurantsObject in restaurantsObjects) {
    
    OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithJsonData:restaurantsObject];
    [restaurants addObject:restaurant];
    
  }
  
  return [restaurants copy];
  
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
