//
//  OMNProductDetailsVC.h
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProduct.h"

@class OMNFeedItem;
@protocol OMNProductDetailsVCDelegate;

@interface OMNProductDetailsVC : UIViewController

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong, readonly) OMNProduct *product;
@property (nonatomic, strong, readonly) OMNFeedItem *feedItem;
@property (nonatomic, weak) id<OMNProductDetailsVCDelegate> delegate;

//- (instancetype)initWithProduct:(OMNProduct *)product;
- (instancetype)initFeedItem:(OMNFeedItem *)feedItem;

@end

@protocol OMNProductDetailsVCDelegate <NSObject>

- (void)productDetailsVCDidFinish:(OMNProductDetailsVC *)productDetailsVC;

@end
