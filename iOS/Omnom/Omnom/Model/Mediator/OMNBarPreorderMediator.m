//
//  OMNBarPreorderMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBarPreorderMediator.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNModalWebVC.h"

@implementation OMNBarPreorderMediator


- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (void)processWish:(OMNWish *)wish {
  
  self.rootVC.didFinishBlock();
  
}

- (UIButton *)bottomButton {
  
  UIButton *bottomButton = nil;
  
  if (self.restaurantMediator.restaurant.complete_ordres_url) {
    
    bottomButton = [UIButton omn_barButtonWithTitle:kOMN_BAR_BUTTON_COMPLETE_ORDERS_TEXT color:[UIColor blackColor] target:self action:@selector(completeOrdresCall)];;
    
  }
  return bottomButton;
  
}

- (void)completeOrdresCall {
  
  OMNModalWebVC *modalWebVC = [[OMNModalWebVC alloc] init];
  modalWebVC.url = self.restaurantMediator.restaurant.complete_ordres_url;
  @weakify(self)
  modalWebVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self.rootVC presentViewController:[[UINavigationController alloc] initWithRootViewController:modalWebVC] animated:YES completion:nil];
  
}

@end
