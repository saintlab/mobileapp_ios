//
//  OMNPreorderMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderMediator.h"
#import "OMNModalWebVC.h"
#import "OMNPreorderDoneVC.h"

@interface OMNPreorderMediator ()

@property (nonatomic, weak) OMNMyOrderConfirmVC *rootVC;

@end

@implementation OMNPreorderMediator {
  
  OMNRestaurant *_restaurant;
  
}

- (instancetype)initWithRootVC:(OMNMyOrderConfirmVC *)myOrderConfirmVC restaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    self.rootVC = myOrderConfirmVC;
    _restaurant = restaurant;
    
  }
  return self;
}

- (void)completeOrdresCall {
  
  OMNModalWebVC *modalWebVC = [[OMNModalWebVC alloc] init];
  modalWebVC.url = _restaurant.complete_ordres_url;
  @weakify(self)
  modalWebVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self.rootVC presentViewController:[[UINavigationController alloc] initWithRootViewController:modalWebVC] animated:YES completion:nil];
  
}

- (void)processWish:(OMNWish *)wish {
  
#warning 123
  if (kRestaurantModeBar == _restaurant.entrance_mode) {
    
    self.didFinishBlock();
    
  }
  else if (kRestaurantModeLunch == _restaurant.entrance_mode) {
    
    OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] initTitle:kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_1 subTitle:kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_2 didCloseBlock:self.didFinishBlock];
    [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];
    
  }
  else {
    
    OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] initTitle:kOMN_PREORDER_DONE_LABEL_TEXT_1 subTitle:kOMN_PREORDER_DONE_LABEL_TEXT_2 didCloseBlock:self.didFinishBlock];
    [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];
    
  }

}

@end
