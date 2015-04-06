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
#import "OMNDemoVisitor.h"

@implementation OMNDemoRestaurantVC {
  
  BOOL _decodeBeaconsStarted;
  
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    
    self.circleIcon = [UIImage imageNamed:@"logo_icon"];
    self.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:[OMNStyler redColor]];
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
  
  @weakify(self)
  [OMNRestaurantManager demoRestaurantWithCompletion:^(NSArray *restaurants) {
    
    @strongify(self)
    if (restaurants.count) {
      
      [self finishLoading:^{
        
        [self didFindDemoRestaurant:[restaurants firstObject]];
        
      }];

    }
    else {
    
      [self didFailOmnom:nil];
      
    }
    
  } failureBlock:^(OMNError *error) {
    
    @strongify(self)
    [self didFailOmnom:error];
    
  }];
  
}

- (void)didFailOmnom:(OMNError *)error {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (void)didFindDemoRestaurant:(OMNRestaurant *)demoRestaurant {

  OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithVisitor:[OMNDemoVisitor visitorWithRestaurant:demoRestaurant delivery:[OMNDelivery delivery]]];
  restaurantActionsVC.didCloseBlock = self.didCloseBlock;
  [self.navigationController pushViewController:restaurantActionsVC animated:YES];
  
}

@end
