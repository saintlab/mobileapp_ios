//
//  OMNSplashVC.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchBeaconVC.h"
#import "OMNRestaurant.h"

typedef void(^OMNSearchRestaurantBlock)(OMNRestaurant *restaurant);

@interface OMNSearchRestaurantVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UIImageView *logoIconsIV;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIView *fgView;

- (instancetype)initWithBlock:(OMNSearchRestaurantBlock)block;

@end
