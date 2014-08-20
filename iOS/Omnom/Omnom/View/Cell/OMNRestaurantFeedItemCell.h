//
//  OMNRestaurantFeedItemCell.h
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OMNFeedItem;

@interface OMNRestaurantFeedItemCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;

- (void)setFeedItem:(OMNFeedItem *)feedItem;

@end
