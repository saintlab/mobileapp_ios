//
//  OMNGPBPayVC.h
//  restaurants
//
//  Created by tea on 28.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMNCardInfo;
@class OMNOrder;
@protocol OMNGPBPayVCDelegate;

@interface OMNGPBPayVC : UIViewController

@property (nonatomic, weak) id<OMNGPBPayVCDelegate>delegate;

- (instancetype)initWithCard:(OMNCardInfo *)card order:(OMNOrder *)order;

@end

@protocol OMNGPBPayVCDelegate <NSObject>

- (void)gpbVCDidPay:(OMNGPBPayVC *)gpbVC withOrder:(OMNOrder *)order;

- (void)gpbVCDidCancel:(OMNGPBPayVC *)gpbVC;

@end