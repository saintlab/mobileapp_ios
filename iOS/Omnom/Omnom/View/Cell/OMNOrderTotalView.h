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

@interface OMNOrderTotalView : UIView

@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, weak) id<OMNOrderTotalViewDelegate> delegate;

@end

@protocol OMNOrderTotalViewDelegate <NSObject>

- (void)orderTotalViewDidSplit:(OMNOrderTotalView *)orderTotalView;
- (void)orderTotalViewDidCancel:(OMNOrderTotalView *)orderTotalView;

@end
