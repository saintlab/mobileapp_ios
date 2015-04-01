//
//  OMNPreorderMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderMediator.h"
#import "OMNPreorderDoneVC.h"
#import "OMNOrderToolbarButton.h"

@implementation OMNPreorderMediator {
  
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

- (void)processCreatedWish:(OMNWish *)wish {
  
  @weakify(self)
  OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] initTitle:kOMN_PREORDER_DONE_LABEL_TEXT_1 subTitle:kOMN_PREORDER_DONE_LABEL_TEXT_2 didCloseBlock:^{
    
    @strongify(self)
    [self didFinishWish];
    
  }];
  [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];

}

- (void)createWish:(NSArray *)wishItems completionBlock:(OMNWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  
  OMNVisitor *visitor = _restaurantMediator.visitor;
  [visitor.restaurant createWishForTable:visitor.table products:wishItems completionBlock:completionBlock wrongIDsBlock:wrongIDsBlock failureBlock:failureBlock];
  
}

- (void)didFinishWish {
  
  [_restaurantMediator.restaurantActionsVC showRestaurantAnimated:NO];
  [_restaurantMediator.menu resetSelection];
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
