//
//  OMNRatingVC.h
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNRatingVCDelegate;

@interface OMNRatingVC : UIViewController

@property (nonatomic, weak) id<OMNRatingVCDelegate> delegate;

@end

@protocol OMNRatingVCDelegate <NSObject>

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC;

@end