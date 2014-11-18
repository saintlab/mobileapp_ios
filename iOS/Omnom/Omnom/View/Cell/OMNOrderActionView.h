//
//  OMNOrderTotalView.h
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNOrder.h"

@protocol OMNOrderTotalViewDelegate;

@interface OMNOrderActionView : UIView

@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, weak) id<OMNOrderTotalViewDelegate> delegate;

@end

@protocol OMNOrderTotalViewDelegate <NSObject>

- (void)orderTotalViewDidSplit:(OMNOrderActionView *)orderTotalView;
- (void)orderTotalViewDidCancel:(OMNOrderActionView *)orderTotalView;

@end
