//
//  OMNDemoRestaurantVC.m
//  omnom
//
//  Created by tea on 18.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDemoRestaurantVC.h"
#import "OMNVisitorManager.h"
#import "OMNR1VC.h"

@interface OMNDemoRestaurantVC ()
<OMNR1VCDelegate>

@end

@implementation OMNDemoRestaurantVC {
  BOOL _decodeBeaconsStarted;
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    
    self.circleIcon = [UIImage imageNamed:@"logo_icon"];
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
  
  [[OMNVisitorManager manager] decodeBeacon:[OMNBeacon aCafeBeacon] success:^(OMNVisitor *visitor) {
    
    if (visitor) {
      [weakSelf didFindVisitor:visitor];
    }
    else {
      [weakSelf didFailOmnom];
    }
    
  } failure:^(NSError *error) {
    
    [weakSelf didFailOmnom];
    
  }];
  
}

- (void)didFailOmnom {
  
  [self.delegate demoRestaurantVCDidFail:self];
  
}

- (void)didFindVisitor:(OMNVisitor *)visitor {
  _visitor = visitor;
  
  __weak typeof(self)weakSelf = self;
  [_visitor.restaurant loadLogo:^(UIImage *image) {
    //TODO: handle error loading image
    [weakSelf didLoadLogo];
    
  }];
  
}

- (void)didLoadLogo {
  
  OMNRestaurant *restaurant = _visitor.restaurant;
  UIImage *logo = restaurant.logo;
  UIColor *restaurantBackgroundColor = restaurant.background_color;
  __weak typeof(self)weakSelf = self;
  [self setLogo:logo withColor:restaurantBackgroundColor completion:^{
    
    [restaurant loadBackgroundBlurred:YES completion:^(UIImage *image) {
      
      [weakSelf finishLoading:^{
        
        [weakSelf didLoadBackground];
        
      }];
      
    }];
    
  }];
  
}

- (void)didLoadBackground {
  
  OMNR1VC *restaurantVC = [[OMNR1VC alloc] initWithVisitor:_visitor];
  restaurantVC.delegate = self;
  [self.navigationController pushViewController:restaurantVC animated:YES];
  
}

#pragma mark - OMNR1VCDelegate

- (void)r1VCDidFinish:(OMNR1VC *)r1VC {
  
  [self.delegate demoRestaurantVCDidFinish:self];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
