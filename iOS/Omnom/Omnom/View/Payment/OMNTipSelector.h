//
//  GTipSelector.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@protocol OMNTipSelectorDelegate;

@interface OMNTipSelector : UIControl

@property (nonatomic, assign, readonly) NSInteger previousSelectedIndex;
@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, weak) id<OMNTipSelectorDelegate> delegate;

@end

@protocol OMNTipSelectorDelegate <NSObject>

- (void)tipSelectorStartCustomTipEditing:(OMNTipSelector *)tipSelector;

@end