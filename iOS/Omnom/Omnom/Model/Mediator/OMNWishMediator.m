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

@implementation OMNWishMediator

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator rootVC:(OMNMyOrderConfirmVC *)rootVC {
  self = [super init];
  if (self) {
    
    _rootVC = rootVC;
    _restaurantMediator = restaurantMediator;
    
  }
  return self;
}

- (void)dealloc
{
  
}

- (void)createWish:(NSArray *)wishItems completionBlock:(OMNVisitorWishBlock)completionBlock wrongIDsBlock:(OMNWrongIDsBlock)wrongIDsBlock failureBlock:(void(^)(OMNError *error))failureBlock {
  [self.restaurantMediator.visitor createWish:wishItems completionBlock:completionBlock wrongIDsBlock:wrongIDsBlock failureBlock:failureBlock];
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
  
  [self.restaurantMediator.menu removePreorderedItems];
  [self closeTap];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    [self.restaurantMediator.restaurantActionsVC showRestaurantAnimated:YES];
    
  });
  
}

- (NSString *)refreshOrdersTitle {
  return kOMN_MY_TABLE_ORDERS_LABEL_TEXT;
}

- (NSString *)wishHintText {
  return nil;
}

- (UIButton *)bottomButton {
  
  UIButton *bottomButton = nil;
  if (self.restaurantMediator.restaurant.settings.has_table_order) {
    
    bottomButton = [[OMNOrderToolbarButton alloc] initWithTotalAmount:self.restaurantMediator.totalOrdersAmount target:self action:@selector(showTableOrders)];
    
  }
  return bottomButton;
  
}

- (void)showTableOrders {
  
  [self.restaurantMediator showTableOrders];
  [self closeTap];
  
}

- (void)closeTap {
  
  if (self.rootVC.didFinishBlock) {
    self.rootVC.didFinishBlock();
  }
  
}

@end
