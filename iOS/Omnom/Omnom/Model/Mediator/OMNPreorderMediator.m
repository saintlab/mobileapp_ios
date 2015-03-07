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

- (void)processWish:(OMNWish *)wish {
  
  OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] initTitle:kOMN_PREORDER_DONE_LABEL_TEXT_1 subTitle:kOMN_PREORDER_DONE_LABEL_TEXT_2 didCloseBlock:self.rootVC.didFinishBlock];
  [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];

}

- (NSString *)refreshOrdersTitle {
  return kOMN_MY_TABLE_ORDERS_LABEL_TEXT;
}

- (UIButton *)bottomButton {
  
  UIButton *bottomButton = nil;
  if (_restaurantMediator.restaurant.settings.has_table_order) {
    
    bottomButton = [[OMNOrderToolbarButton alloc] initWithTotalAmount:_restaurantMediator.totalOrdersAmount target:self action:@selector(requestTableOrders)];
    
  }
  return bottomButton;
  
}

- (void)requestTableOrders {
  
  [_restaurantMediator requestTableOrders];
  [self closeTap];
  
}

- (void)closeTap {
  
  if (_rootVC.didFinishBlock) {
    _rootVC.didFinishBlock();
  }
  
}

@end
