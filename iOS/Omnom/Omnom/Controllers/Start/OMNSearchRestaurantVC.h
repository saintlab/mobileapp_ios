//
//  OMNSplashVC.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchRestaurantsVC.h"
#import "OMNLaunchOptions.h"

@protocol OMNSearchRestaurantVCDelegate;

@interface OMNSearchRestaurantVC : UIViewController

@property (nonatomic, strong) UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UIImageView *logoIconsIV;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIView *fgView;
@property (nonatomic, weak) id<OMNSearchRestaurantVCDelegate> delegate;

- (instancetype)initWithLaunchOptions:(OMNLaunchOptions *)launchOptions;

@end

@protocol OMNSearchRestaurantVCDelegate <NSObject>

- (void)searchRestaurantVCDidFinish:(OMNSearchRestaurantVC *)searchRestaurantVC;

@end
