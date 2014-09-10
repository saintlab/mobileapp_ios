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
#import "UIImage+omn_helper.h"
#import "OMNAnalitics.h"
#import "OMNImageManager.h"

@interface NSData (omn_restaurants)

- (NSArray *)decodeRestaurantsWithError:(NSError **)error;

- (OMNMenu *)decodeMenuWithError:(NSError **)error;

@end



@implementation OMNRestaurant {
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
    self.is_demo = [jsonData[@"is_demo"] boolValue];
    self.title = jsonData[@"title"];
    self.image = jsonData[@"image"];
    self.Description = jsonData[@"description"];
    
    id decoration = jsonData[@"decoration"];
    self.logoUrl = decoration[@"logo"];
    self.mobile_texts = [[OMNPushTexts alloc] initWithJsonData:jsonData[@"mobile_texts"]];
    self.background_imageUrl = decoration[@"background_image"];
    if ([decoration[@"background_color"] isKindOfClass:[NSString class]]) {
      self.background_color = [decoration[@"background_color"] omn_colorFormHex];
    }
    else {
      self.background_color = [UIColor blackColor];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(waiterCallDone:) name:OMNSocketIOWaiterCallDoneNotification object:nil];
    
  }
  return self;
}

- (void)waiterCallDone:(NSNotification *)n {
  [self stopWaiterCall];
}

+ (void)getRestaurantList:(GRestaurantsBlock)restaurantsBlock error:(void(^)(NSError *error))errorBlock {
  
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

- (UIImage *)circleBackground {
  return [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:self.background_color];
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

- (void)loadLogo:(OMNImageBlock)imageBlock {
  
  __weak typeof(self)weakSelf = self;
  [[OMNImageManager manager] downloadImageWithURL:self.logoUrl completion:^(UIImage *image) {
    
    weakSelf.logo = image;
    imageBlock(image);
    
  }];

}

- (void)loadBackground:(OMNImageBlock)imageBlock {
  
  __weak typeof(self)weakSelf = self;
  [[OMNImageManager manager] downloadImageWithURL:self.background_imageUrl completion:^(UIImage *image) {
    
    weakSelf.background = image;
    imageBlock(image);
    
  }];
  
}

- (void)advertisement:(OMNRestaurantInfoBlock)completionBlock error:(void(^)(NSError *error))errorBlock {
  
  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/advertisement", self.id];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    if (response &&
        [response isKindOfClass:[NSDictionary class]] &&
        response[@"title"]) {
      
      OMNRestaurantInfo *restaurantInfo = [[OMNRestaurantInfo alloc] initWithJsonData:response];
      completionBlock(restaurantInfo);
      
    }
    else {
      
      [[OMNAnalitics analitics] logEvent:@"ERROR_RESTAURANT_ADVERTISMENT" jsonRequest:path jsonResponse:response];
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logEvent:@"ERROR_RESTAURANT_ADVERTISMENT" jsonRequest:path responseOperation:operation];
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



