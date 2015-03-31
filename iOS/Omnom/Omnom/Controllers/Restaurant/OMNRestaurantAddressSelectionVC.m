//
//  OMNRestaurantAddressSelectionVC.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantAddressSelectionVC.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNRestaurantAddressSelectionVC ()

@end

@implementation OMNRestaurantAddressSelectionVC {
  
  OMNRestaurant *_restaurant;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = kOMN_RESTAURANT_ADDRESS_SELECTION_TITLE;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];

}

- (void)closeTap {
  
  self.didCloseBlock();
  
}

@end
