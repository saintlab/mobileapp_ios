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
#import "GDefaultClient.h"

@interface NSData (omn_restaurants)

- (NSArray *)decodeRestaurantsWithError:(NSError **)error;

- (GMenu *)decodeMenuWithError:(NSError **)error;

@end

@interface NSArray (omn_restaurants)

- (NSArray *)decodeOrdersWithError:(NSError **)error;

@end

@implementation OMNRestaurant

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    self.ID = data[@"id"];
    self.title = data[@"title"];
    self.image = data[@"image"];
    self.Description = data[@"description"];
  }
  return self;
}

+ (void)getRestaurantList:(GRestaurantsBlock)restaurantsBlock error:(void(^)(NSError *error))errorBlock {
  
  if (kUseStubData) {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"restaurants.data" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    restaurantsBlock([self restaurantsFromJsonObject:responseObject]);
    return;
  }
  
  [[OMNOperationManager sharedManager] GET:@"restaurants" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    restaurantsBlock([self restaurantsFromJsonObject:responseObject]);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    errorBlock(error);
    
  }];
  
}

+ (NSArray *)restaurantsFromJsonObject:(id)object {
  
  NSArray *restaurantsObjects = object[@"items"];
  
  NSMutableArray *restaurants = [NSMutableArray arrayWithCapacity:restaurantsObjects.count];
  
  for (id restaurantsObject in restaurantsObjects) {
    
    OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithData:restaurantsObject];
    [restaurants addObject:restaurant];
    
  }
  
  return [restaurants copy];
  
}

- (void)getMenu:(GMenuBlock)menuBlock error:(void(^)(NSError *error))errorBlock {
  
  if (kUseStubData) {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"menu.data" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    GMenu *menu = [[GMenu alloc] initWithData:responseObject];
    menuBlock(menu);
    return;
  }
  
  NSString *path = [NSString stringWithFormat:@"restaurants/%@/menu", self.ID];
  [[GDefaultClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
    GMenu *menu = [[GMenu alloc] initWithData:responseObject];
    menuBlock(menu);
    
  } failure:^(NSURLSessionDataTask *task, NSError *error) {

    if (errorBlock) {
      errorBlock(error);
    }
    else {
      NSLog(@"%@", error);
    }
    
  }];
  
}

- (void)callWaiterForTableID:(NSString *)tableID success:(dispatch_block_t)success error:(void(^)(NSError *error))errorBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/waiter/call", self.ID, tableID];
  
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *ordersData) {
    
    if (success) {
      success();
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    if (errorBlock) {
      errorBlock(error);
    }
    else {
      NSLog(@"error>%@", error);
    }
    
  }];

}



- (void)getOrdersForTableID:(NSString *)tableID orders:(OMNOrdersBlock)ordersBlock error:(void(^)(NSError *error))errorBlock {
  
  if (kUseStubData) {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"orders.data" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *ordersData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    ordersBlock([ordersData decodeOrdersWithError:nil]);
    return;
  }

  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders", self.ID, tableID];
  
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *ordersData) {
    
    ordersBlock([ordersData decodeOrdersWithError:nil]);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    errorBlock(error);
    
  }];
  
}

- (void)createOrderForTableID:(NSString *)tableID products:(NSArray *)products block:(OMNOrderBlock)block error:(void(^)(NSError *error))errorBlock {

  if (0 == tableID.length) {
    errorBlock(nil);
    return;
  }
  
  NSMutableArray *items = [NSMutableArray arrayWithCapacity:products.count];
  
  [products enumerateObjectsUsingBlock:^(GMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
    
    NSDictionary *item =
    @{
      @"internalId" : menuItem.internalId,
      @"" : @(menuItem.quantity),
      };
    [items addObject:item];
    
  }];
  
  NSDictionary *info =
  @{
    @"restaurantId" : self.ID,
    @"tableId" : tableID,
    @"items" : items,
    };
  
  
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
  NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//TODO: create order
  return;
//  [[GDefaultClient sharedClient] POST:@"restaurateur/orders" parameters:nil body:jsonData success:^(NSURLSessionDataTask *task, id responseObject) {
//    
//    block(nil);
//    
//  } failure:^(NSURLSessionDataTask *task, NSError *error) {
//    
//    errorBlock(error);
//    
//  }];
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@, %@", _title, _ID];
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
      
      OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithData:restaurantsObject];
      [restaurants addObject:restaurant];
      
    }
    
    return [restaurants copy];
    
  }
  
}

- (GMenu *)decodeMenuWithError:(NSError **)error {
  
  id response = [NSJSONSerialization JSONObjectWithData:self options:0 error:error];
  
  if (*error) {
    return nil;
  }
  else {
    
    GMenu *menu = [[GMenu alloc] initWithData:response];
    return menu;
    
  }
  
}

@end


@implementation NSArray (omn_restaurants)

- (NSArray *)decodeOrdersWithError:(NSError **)error {
  
  NSMutableArray *orders = [NSMutableArray arrayWithCapacity:[self count]];
  for (id orderData in self) {
    
    OMNOrder *order = [[OMNOrder alloc] initWithData:orderData];
    [orders addObject:order];
    
  }
  
  return [orders copy];
  
}

@end
