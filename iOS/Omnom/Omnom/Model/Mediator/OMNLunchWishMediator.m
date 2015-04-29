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

- (PMKPromise *)processCreatedWishForVisitor:(OMNVisitor *)visitor {

  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    OMNPreorderDoneVC *preorderDoneVC = [[OMNPreorderDoneVC alloc] initTitle:kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_1 subTitle:kOMN_PREORDER_DONE_2GIS_LABEL_TEXT_2 didCloseBlock:^{
      
      fulfill(nil);
      
    }];
    [self.rootVC presentViewController:preorderDoneVC animated:YES completion:nil];

  }];
  
}

- (UIButton *)bottomButton {
  return nil;
}

@end
