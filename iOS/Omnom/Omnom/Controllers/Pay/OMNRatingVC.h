//
//  OMNRatingVC.h
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNOrder.h"

@protocol OMNRatingVCDelegate;

@interface OMNRatingVC : OMNBackgroundVC

@property (nonatomic, weak) id<OMNRatingVCDelegate> delegate;

- (instancetype)initWithOrder:(OMNOrder *)order;

@end

@protocol OMNRatingVCDelegate <NSObject>

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC;

@end