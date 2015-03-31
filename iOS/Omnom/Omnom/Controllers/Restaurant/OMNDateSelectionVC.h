//
//  OMNDateSelectionVC.h
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OMNDateBlock)(NSString *date);

@interface OMNDateSelectionVC : UIViewController

@property (nonatomic, copy) OMNDateBlock didSelectDateBlock;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithDates:(NSArray *)dates;

@end
