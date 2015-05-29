//
//  OMNSplashVC.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <PromiseKit.h>
#import "OMNSearchRestaurantMediator.h"

@interface OMNLogoVC : UIViewController

@property (nonatomic, strong) UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UIImageView *logoIconsIV;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIView *fgView;
@property (nonatomic, strong, readonly) OMNSearchRestaurantMediator *searchRestaurantMediator;

- (PMKPromise *)present:(UIViewController *)rootVC;

@end

