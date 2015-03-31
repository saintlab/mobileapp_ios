//
//  OMNDateSelectionVC.h
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNDateSelectionVC : UIViewController

@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithDates:(NSArray *)dates;

@end
