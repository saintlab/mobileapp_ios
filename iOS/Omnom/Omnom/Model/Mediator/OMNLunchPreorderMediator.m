//
//  OMNLunchPreorderMediator.m
//  omnom
//
//  Created by tea on 06.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchPreorderMediator.h"
#import "OMNPreorderDoneVC.h"

@implementation OMNLunchPreorderMediator

- (NSString *)refreshOrdersTitle {
  return kOMN_WISH_RECOMMENDATIONS_LABEL_TEXT;
}

- (void)processWish:(OMNWish *)wish {

  OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] initTitle:kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_1 subTitle:kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_2 didCloseBlock:self.rootVC.didFinishBlock];
  [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];
  
}

- (UIButton *)bottomButton {
  return nil;
}

@end
