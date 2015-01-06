//
//  OMNRestaurantInfoVC.h
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNInteractiveTransitioningProtocol.h"
#import "OMNRestaurant.h"

@protocol OMNRestaurantInfoVCDelegate;
@class OMNFeedItem;

@interface OMNRestaurantInfoVC : UITableViewController
<OMNInteractiveTransitioningProtocol>

@property (nonatomic, weak) id<OMNRestaurantInfoVCDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

- (UITableViewCell *)cellForFeedItem:(OMNFeedItem *)feedItem;

@end

@protocol OMNRestaurantInfoVCDelegate <NSObject>

- (void)restaurantInfoVCDidFinish:(OMNRestaurantInfoVC *)restaurantInfoVC;

@end