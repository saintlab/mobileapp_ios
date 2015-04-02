//
//  OMNLunchPreorderMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchWishMediator.h"
#import "OMNPreorderDoneVC.h"

@implementation OMNLunchWishMediator

- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (void)processCreatedWish:(OMNWish *)wish {

  @weakify(self)
  OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] initTitle:kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_1 subTitle:kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_2 didCloseBlock:^{
    
    @strongify(self)
    [self didFinishWish];
    
  }];
  [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];
  
}

- (UIButton *)bottomButton {
  return nil;
}

@end
