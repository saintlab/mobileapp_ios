//
//  OMNRestaurantCardButtonsView.h
//  omnom
//
//  Created by tea on 14.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurant.h"
#import "OMNVisitor.h"
#import "OMNBottomTextButton.h"

@protocol OMNRestaurantCardButtonsViewDelegate;

@interface OMNRestaurantCardButtonsView : UIView

@property (nonatomic, strong, readonly) OMNRestaurant *restaurant;

@property (nonatomic, weak) id<OMNRestaurantCardButtonsViewDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end

@protocol OMNRestaurantCardButtonsViewDelegate <NSObject>

- (void)cardButtonsView:(OMNRestaurantCardButtonsView *)view didSelectVisitor:(OMNVisitor *)visitor;

@end