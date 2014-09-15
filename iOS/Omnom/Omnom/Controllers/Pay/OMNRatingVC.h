//
//  OMNRatingVC.h
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNVisitor.h"

@protocol OMNRatingVCDelegate;

@interface OMNRatingVC : OMNBackgroundVC

@property (nonatomic, weak) id<OMNRatingVCDelegate> delegate;
@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, strong) OMNVisitor *visitor;

@end

@protocol OMNRatingVCDelegate <NSObject>

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC;

@end