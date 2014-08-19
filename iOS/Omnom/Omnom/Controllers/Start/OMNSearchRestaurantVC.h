//
//  OMNSplashVC.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchBeaconVC.h"
#import "OMNRestaurant.h"

typedef void(^OMNDecodeBeaconBlock)(OMNDecodeBeacon *decodeBeacon);

@interface OMNSearchRestaurantVC : UIViewController

@property (nonatomic, strong) OMNDecodeBeacon *decodeBeacon;
@property (nonatomic, strong) UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UIImageView *logoIconsIV;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UIView *fgView;

- (instancetype)initWithBlock:(OMNDecodeBeaconBlock)block;

@end
