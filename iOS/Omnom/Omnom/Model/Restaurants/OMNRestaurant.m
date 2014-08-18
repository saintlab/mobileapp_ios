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
#import "NSString+omn_color.h"
#import "OMNSocketManager.h"

@interface NSData (omn_restaurants)

- (NSArray *)decodeRestaurantsWithError:(NSError **)error;

- (OMNMenu *)decodeMenuWithError:(NSError **)error;

@end

@interface NSArray (omn_restaurants)

- (NSArray *)decodeOrdersWithError:(NSError **)error;

@end

@implementation OMNRestaurant {
  NSOperationQueue *_imageRequestsQueue;
  dispatch_block_t _waiterCallStopBlock;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self stopWaiterCall];
}

- (instancetype)initWithJsonData:(id)jsonData {
  
  if ([jsonData isKindOfClass:[NSNull class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    self.id = jsonData[@"id"];
    self.title = jsonData[@"title"];
    self.image = jsonData[@"image"];
    self.Description = jsonData[@"description"];
    
    id decoration = jsonData[@"decoration"];
    self.logoUrl = decoration[@"logo"];
    self.background_imageUrl = decoration[@"background_image"];
    
    if ([decoration[@"background_color"] isKindOfClass:[NSString class]]) {
      self.background_color = [decoration[@"background_color"] omn_colorFormHex];
    }
    else {
      self.background_color = [UIColor blackColor];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waiterCallDone:) name:OMNSocketIOWaiterCallDoneNotification object:nil];
    
    _imageRequestsQueue = [[NSOperationQueue alloc] init];
    _imageRequestsQueue.maxConcurrentOperationCount = 1;
  }
  return self;
}

- (void)waiterCallDone:(NSNotification *)n {
  [self stopWaiterCall];
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
    
    OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithJsonData:restaurantsObject];
    [restaurants addObject:restaurant];
    
  }
  
  return [restaurants copy];
  
}

- (void)getMenu:(GMenuBlock)menuBlock error:(void(^)(NSError *error))errorBlock {
  
  if (kUseStubData) {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"menu.data" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    OMNMenu *menu = [[OMNMenu alloc] initWithJsonData:responseObject];
    menuBlock(menu);
    return;
  }
  
  NSString *path = [NSString stringWithFormat:@"restaurants/%@/menu", self.id];
  [[OMNOperationManager manager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    OMNMenu *menu = [[OMNMenu alloc] initWithJsonData:responseObject];
    menuBlock(menu);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    errorBlock(error);
    
  }];
  
}

- (void)waiterCallForTableID:(NSString *)tableID completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock stop:(dispatch_block_t)stopBlock {
  
  _waiterCallTableID = tableID;
  _waiterCallStopBlock = stopBlock;
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/waiter/call", self.id, tableID];
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *ordersData) {
    
    [[OMNSocketManager manager] join:tableID];
    
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    failureBlock(error);
    
  }];

}

- (void)stopWaiterCall {
  
  if (_waiterCallTableID) {

    [[OMNSocketManager manager] leave:_waiterCallTableID];
    _waiterCallTableID = nil;

    if (_waiterCallStopBlock) {
      _waiterCallStopBlock();
      _waiterCallStopBlock = nil;
    }

  }
  
}

- (void)waiterCallStopCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  if (nil == _waiterCallTableID) {
    completionBlock();
    return;
  }
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/waiter/call/stop", self.id, _waiterCallTableID];
  __weak typeof(self)weakSelf = self;
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *ordersData) {
    
    [weakSelf stopWaiterCall];
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

- (void)newGuestForTableID:(NSString *)tableID completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/new/guest", self.id, tableID];
  
  [[OMNOperationManager sharedManager] POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *ordersData) {

    NSLog(@"newGuestForTableID>done");
    completionBlock();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"newGuestForTableID>%@", error);
    failureBlock(error);
    
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

  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/tables/%@/orders", self.id, tableID];
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
  
  [products enumerateObjectsUsingBlock:^(OMNMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
    
    NSDictionary *item =
    @{
      @"internalId" : menuItem.internalId,
      @"" : @(menuItem.quantity),
      };
    [items addObject:item];
    
  }];
  
  NSDictionary *info =
  @{
    @"restaurantId" : self.id,
    @"tableId" : tableID,
    @"items" : items,
    };
  
  
  
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
  NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//TODO: create order
  return;
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@, %@", _title, _id];
}

- (void)loadImageWithUrlString:(NSString *)urlString imageBlock:(OMNImageBlock)imageBlock {
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  
  AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
  
  [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    imageBlock(responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    imageBlock(nil);
    
  }];
  [_imageRequestsQueue addOperation:requestOperation];
  
}

- (void)loadLogo:(OMNImageBlock)imageBlock {
  
  __weak typeof(self)weakSelf = self;
  [self loadImageWithUrlString:self.logoUrl imageBlock:^(UIImage *image) {
    
    weakSelf.logo = image;
    imageBlock(image);
    
  }];
  
}

- (void)loadBackground:(OMNImageBlock)imageBlock {
  
  __weak typeof(self)weakSelf = self;
  [self loadImageWithUrlString:self.background_imageUrl imageBlock:^(UIImage *image) {
    
    weakSelf.background = image;
    imageBlock(image);
    
  }];
  
}

- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))errorBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/advertisement", self.id];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    OMNRestaurantInfo *restaurantInfo = [[OMNRestaurantInfo alloc] initWithJsonData:response];
    completionBlock(restaurantInfo);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
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


@implementation NSArray (omn_restaurants)

- (NSArray *)decodeOrdersWithError:(NSError **)error {
  
  NSMutableArray *orders = [NSMutableArray arrayWithCapacity:[self count]];
  for (id orderData in self) {
    
    OMNOrder *order = [[OMNOrder alloc] initWithJsonData:orderData];
    [orders addObject:order];
    
  }
  
  return [orders copy];
  
}

@end
