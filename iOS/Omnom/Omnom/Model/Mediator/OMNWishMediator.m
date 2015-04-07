//
//  OMNPreorderMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWishMediator.h"
#import "OMNPreorderDoneVC.h"
#import "OMNOrderToolbarButton.h"

@implementation OMNWishMediator {
  
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator rootVC:(OMNMyOrderConfirmVC *)rootVC {
  self = [super init];
  if (self) {
    
    _rootVC = rootVC;
    _restaurantMediator = restaurantMediator;
    
  }
  return self;
}


- (void)createWish:(NSArray *)wishItems completionBlock:(OMNVisitorWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  [_restaurantMediator.visitor createWish:wishItems completionBlock:completionBlock wrongIDsBlock:wrongIDsBlock failureBlock:failureBlock];
}

- (void)processCreatedWishForVisitor:(OMNVisitor *)visitor {
  
  @weakify(self)
  OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] initTitle:kOMN_PREORDER_DONE_LABEL_TEXT_1 subTitle:kOMN_PREORDER_DONE_LABEL_TEXT_2 didCloseBlock:^{
    
    @strongify(self)
    [self didFinishWish];
    
  }];
  [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];
  
}

- (void)didFinishWish {
  
  [_restaurantMediator.restaurantActionsVC showRestaurantAnimated:NO];
  [_restaurantMediator.menu removePreorderedItems];
  self.rootVC.didFinishBlock();
  
}

- (NSString *)refreshOrdersTitle {
  return kOMN_MY_TABLE_ORDERS_LABEL_TEXT;
}

- (UIButton *)bottomButton {
  
  UIButton *bottomButton = nil;
  if (_restaurantMediator.restaurant.settings.has_table_order) {
    
    bottomButton = [[OMNOrderToolbarButton alloc] initWithTotalAmount:_restaurantMediator.totalOrdersAmount target:self action:@selector(showTableOrders)];
    
  }
  return bottomButton;
  
}

- (void)showTableOrders {
  
  [_restaurantMediator showTableOrders];
  [self closeTap];
  
}

- (void)closeTap {
  
  if (_rootVC.didFinishBlock) {
    _rootVC.didFinishBlock();
  }
  
}

@end
