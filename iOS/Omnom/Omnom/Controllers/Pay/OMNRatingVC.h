//
//  OMNRatingVC.h
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNRestaurantMediator.h"

@protocol OMNRatingVCDelegate;

@interface OMNRatingVC : OMNBackgroundVC

@property (nonatomic, weak) id<OMNRatingVCDelegate> delegate;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end

@protocol OMNRatingVCDelegate <NSObject>

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC;

@end