//
//  OMNRestaurantInfoVC.h
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OMNRestaurantInfoVCDelegate;
@class OMNFeedItem;
@class OMNDecodeBeacon;

@interface OMNRestaurantInfoVC : UITableViewController

@property (nonatomic, weak) id<OMNRestaurantInfoVCDelegate> delegate;

- (instancetype)initWithDecodeBeacon:(OMNDecodeBeacon *)decodeBeacon;

- (UITableViewCell *)cellForFeedItem:(OMNFeedItem *)feedItem;

@end

@protocol OMNRestaurantInfoVCDelegate <NSObject>

- (void)restaurantInfoVCDidFinish:(OMNRestaurantInfoVC *)restaurantInfoVC;
- (void)restaurantInfoVCShowUserInfo:(OMNRestaurantInfoVC *)restaurantInfoVC;

@end