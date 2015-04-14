//
//  OMNRestaurantCardButtonsView.h
//  omnom
//
//  Created by tea on 14.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import "OMNBottomTextButton.h"

@interface OMNRestaurantCardButtonsView : UIView

@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;

@property (nonatomic, strong, readonly) OMNBottomTextButton *barButton;
@property (nonatomic, strong, readonly) OMNBottomTextButton *onTableButton;
@property (nonatomic, strong, readonly) OMNBottomTextButton *inRestaurantButton;
@property (nonatomic, strong, readonly) OMNBottomTextButton *lunchButton;
@property (nonatomic, strong, readonly) OMNBottomTextButton *preorderButton;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end
