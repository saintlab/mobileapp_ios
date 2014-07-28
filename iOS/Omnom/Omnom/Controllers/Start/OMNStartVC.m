//
//  OMNStartVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStartVC.h"
#import "UIImage+omn_helper.h"

#import "OMNNavigationControllerDelegate.h"
#import "OMNAuthorisation.h"
#import "OMNAuthorizationVC.h"
#import "OMNRestaurantMenuVC.h"
#import "OMNSearchRestaurantVC.h"
#import "OMNR1VC.h"

@interface OMNStartVC ()
<OMNRestaurantMenuVCDelegate,
OMNAuthorizationVCDelegate>

@end

@implementation OMNStartVC {
  UIImageView *_bgView;
  OMNNavigationControllerDelegate *_navigationControllerDelegate;
  UINavigationController *_navVC;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _navigationControllerDelegate = [[OMNNavigationControllerDelegate alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.delegate = _navigationControllerDelegate;
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  _bgView = [[UIImageView alloc] initWithImage:[UIImage omn_imageNamed:@"LaunchImage-700"]];
  [self.view addSubview:_bgView];
  
  __weak typeof(self)weakSelf = self;
  [[OMNAuthorisation authorisation] checkTokenWithBlock:^(BOOL tokenIsValid) {
    
    if (tokenIsValid) {
      [weakSelf startSearchingBeacons];
    }
    else {
      [weakSelf showWizzard];
    }
    
  }];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)startSearchingBeacons {

  __weak typeof(self)weakSelf = self;
  OMNSearchRestaurantVC *searchRestaurantVC = [[OMNSearchRestaurantVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    [weakSelf didFindBeacon:decodeBeacon];
    
  }];
  
  _navVC = [[UINavigationController alloc] initWithRootViewController:searchRestaurantVC];
  _navVC.delegate = _navigationControllerDelegate;
  [self presentViewController:_navVC animated:NO completion:nil];

}

- (void)showWizzard {
  OMNAuthorizationVC *searchBeaconVC = [[OMNAuthorizationVC alloc] init];
  searchBeaconVC.delegate = self;
  [self.navigationController pushViewController:searchBeaconVC animated:YES];
}

#pragma mark - OMNStartVC1Delegate

- (void)startVCDidReceiveToken:(OMNAuthorizationVC *)startVC {
  
  [self.navigationController popToViewController:self animated:NO];
  [self startSearchingBeacons];
  
}

- (void)didFindBeacon:(OMNDecodeBeacon *)decodeBeacon {

  //TODO: get actual restaurant
  NSDictionary *data = @{@"id" : decodeBeacon.restaurantId};
  OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithData:data];
  
  OMNR1VC *restaurantMenuVC = [[OMNR1VC alloc] initWithRestaurant:restaurant];
  restaurantMenuVC.circleIcon = [UIImage imageNamed:@"ginza_logo"];
#warning [UIImage imageNamed:@"black_circle"]
  restaurantMenuVC.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:[UIColor blackColor]];
  [self.navigationController pushViewController:restaurantMenuVC animated:NO];
  [_navVC pushViewController:restaurantMenuVC animated:YES];
  
  return;
  [self dismissViewControllerAnimated:NO completion:^{
    
    OMNR1VC *restaurantMenuVC = [[OMNR1VC alloc] init];
    [self.navigationController pushViewController:restaurantMenuVC animated:NO];
#warning OMNRestaurantMenuVC
//    OMNRestaurantMenuVC *restaurantMenuVC = [[OMNRestaurantMenuVC alloc] initWithRestaurant:restaurant table:nil];
//    restaurantMenuVC.delegate = self;
//    [self.navigationController pushViewController:restaurantMenuVC animated:YES];
    
  }];
  
  [restaurant newGuestForTableID:decodeBeacon.tableId complition:^{
    
    NSLog(@"newGuestForTableID>done");
    
  } failure:^(NSError *error) {
    
    NSLog(@"newGuestForTableID>%@", error);
    
  }];
  
}
#pragma mark - OMNRestaurantMenuVCDelegate

- (void)restaurantMenuVCDidFinish:(OMNRestaurantMenuVC *)restaurantMenuVC {
  [self.navigationController popToViewController:self animated:YES];
}

- (void)searchBeaconVCDidCancel:(OMNSearchBeaconVC *)searchBeaconVC {

  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)didReceiveMemoryWarning {
  _bgView.image = nil;
  [super didReceiveMemoryWarning];
}

@end
