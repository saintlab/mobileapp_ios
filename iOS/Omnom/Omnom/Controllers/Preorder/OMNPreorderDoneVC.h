//
//  OMNPreorderDoneVC.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import <TTTAttributedLabel.h>

@interface OMNPreorderDoneVC : OMNBackgroundVC

@property (nonatomic, strong, readonly) TTTAttributedLabel *textLabel;
@property (nonatomic, strong, readonly) TTTAttributedLabel *detailedTextLabel;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initTitle:(NSString *)title subTitle:(NSString *)subTitle didCloseBlock:(dispatch_block_t)didCloseBlock;

@end
