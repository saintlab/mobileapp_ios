//
//  GRestaurant.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import <AFNetworking/AFNetworking.h>
#import "OMNOperationManager.h"
#import "OMNAnalitics.h"

@interface NSData (omn_restaurants)

- (NSArray *)decodeRestaurantsWithError:(NSError **)error;

- (OMNMenu *)decodeMenuWithError:(NSError **)error;

@end

@interface OMNRestaurant ()

//@property (nonatomic)

@end

@implementation OMNRestaurant

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {

    self.id = [jsonData[@"id"] description];
    self.is_demo = [jsonData[@"is_demo"] boolValue];
    self.title = jsonData[@"title"];
    self.Description = jsonData[@"description"];

    _decoration = [[OMNRestaurantDecoration alloc] initWithJsonData:jsonData[@"decoration"]];
    _mobile_texts = [[OMNPushTexts alloc] initWithJsonData:jsonData[@"mobile_texts"]];
    _settings = [[OMNRestaurantSettings alloc] initWithJsonData:jsonData[@"settings"]];
    _phone = jsonData[@"phone"];
    _address = [[OMNRestaurantAddress alloc] initWithJsonData:jsonData[@"address"]];
    _schedules = [[OMNRestaurantSchedules alloc] initWithJsonData:jsonData[@"schedules"]];
    
    _tables = [jsonData[@"tables"] omn_tables];
    _orders = [jsonData[@"orders"] omn_orders];;
    
  }
  return self;
}

+ (void)getRestaurants:(OMNRestaurantsBlock)restaurantsBlock failure:(void(^)(OMNError *error))failureBlock {
  
  [[OMNOperationManager sharedManager] GET:@"restaurants" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
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
  
  [products enumerateObjectsUsingBlock:^(OMNMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
    
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

- (NSString *)description {
  return [NSString stringWithFormat:@"%@, %@", _title, _id];
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

@end

@implementation NSData (omn_restaurants)

- (NSArray *)decodeRestaurantsWithError:(NSError **)error {
  
  id response = [NSJSONSerialization JSONObjectWithData:self options:0 error:error];
  
  if (*error) {
    return nil;
  }
  else {
    
    NSArray *restaurantsObjects = response[@"items"];
    
    NSMutableArray *restaurants = [NSMutableArray arrayWithCapacity:restaurantsObjects.count];
    
    for (id restaurantsObject in restaurantsObjects) {
      
      OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithJsonData:restaurantsObject];
      [restaurants addObject:restaurant];
      
    }
    
    return [restaurants copy];
    
  }
  
}

- (OMNMenu *)decodeMenuWithError:(NSError **)error {
  
  id response = [NSJSONSerialization JSONObjectWithData:self options:0 error:error];
  
  if (*error) {
    return nil;
  }
  else {
    
    OMNMenu *menu = [[OMNMenu alloc] initWithJsonData:response];
    return menu;
    
  }
  
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


