//
//  OMNProductDetailsVC.h
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProduct.h"

@protocol OMNProductDetailsVCDelegate;

@interface OMNProductDetailsVC : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong, readonly) OMNProduct *product;;
@property (nonatomic, weak) id<OMNProductDetailsVCDelegate> delegate;

- (instancetype)initWithProduct:(OMNProduct *)product;

@end

@protocol OMNProductDetailsVCDelegate <NSObject>

- (void)productDetailsVCDidFinish:(OMNProductDetailsVC *)productDetailsVC;

@end
