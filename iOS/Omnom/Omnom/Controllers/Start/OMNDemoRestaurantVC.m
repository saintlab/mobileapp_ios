//
//  OMNDemoRestaurantVC.m
//  omnom
//
//  Created by tea on 18.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDemoRestaurantVC.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNRestaurantManager.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>

@interface OMNDemoRestaurantVC ()
<OMNRestaurantActionsVCDelegate>

@end

@implementation OMNDemoRestaurantVC {
  BOOL _decodeBeaconsStarted;
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    
    self.circleIcon = [UIImage imageNamed:@"logo_icon"];
    self.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"d0021b")];
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
    
  }
  return self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (_decodeBeaconsStarted) {
    return;
  }
  
  [self.loaderView startAnimating:10.0];
  _decodeBeaconsStarted = YES;
  __weak typeof(self)weakSelf = self;
  
  [OMNRestaurantManager demoRestaurantWithCompletion:^(NSArray *restaurants) {
    
    if (restaurants.count) {
      
      [weakSelf finishLoading:^{
        
        [weakSelf didFindRestaurant:restaurants[0]];
        
      }];

    }
    else {
    
      [weakSelf didFailOmnom:nil];
      
    }
    
  } failureBlock:^(OMNError *error) {
    
    [weakSelf didFailOmnom:error];
    
  }];
  
}

- (void)didFailOmnom:(OMNError *)error {
  
  [self.delegate demoRestaurantVCDidFail:self withError:error];
  
}

- (void)didFindRestaurant:(OMNRestaurant *)restaurant {

  OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithRestaurant:restaurant];
  restaurantActionsVC.delegate = self;
  [self.navigationController pushViewController:restaurantActionsVC animated:YES];
  
}

#pragma mark - OMNRestaurantActionsVCDelegate

- (void)restaurantActionsVCDidFinish:(OMNRestaurantActionsVC *)restaurantVC {
  
  [self.delegate demoRestaurantVCDidFinish:self];
  
}

@end
