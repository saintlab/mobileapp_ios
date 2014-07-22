//
//  OMNStartVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStartVC.h"
#import "UIImage+omn_helper.h"
#import "OMNSearchBeaconVC.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNAuthorisation.h"
#import "OMNStartVC1.h"
#import "OMNRestaurantMenuVC.h"

@interface OMNStartVC ()
<OMNRestaurantMenuVCDelegate,
OMNStartVC1Delegate>

@end

@implementation OMNStartVC {
  UIImageView *_bgView;
  OMNNavigationControllerDelegate *_navigationControllerDelegate;
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
  if (nil == _bgView.image) {
    _bgView.image = [UIImage omn_imageNamed:@"LaunchImage-700"];
  }
}

- (void)startSearchingBeacons {
  
  __weak typeof(self)weakSelf = self;
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    [weakSelf didFindBeacon:decodeBeacon];
    
  } cancelBlock:nil];
  [self.navigationController pushViewController:searchBeaconVC animated:YES];

}

- (void)showWizzard {
  OMNStartVC1 *searchBeaconVC = [[OMNStartVC1 alloc] init];
  searchBeaconVC.delegate = self;
  [self.navigationController pushViewController:searchBeaconVC animated:YES];
}

#pragma mark - OMNStartVC1Delegate

- (void)startVCDidReceiveToken:(OMNStartVC1 *)startVC {
  
  [self startSearchingBeacons];
  
}

- (void)didFindBeacon:(OMNDecodeBeacon *)decodeBeacon {
  
  //TODO: get actual restaurant
  NSDictionary *data = @{@"id" : decodeBeacon.restaurantId};
  OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithData:data];
  OMNRestaurantMenuVC *restaurantMenuVC = [[OMNRestaurantMenuVC alloc] initWithRestaurant:restaurant table:nil];
  
  [restaurant newGuestForTableID:decodeBeacon.tableId complition:^{
    
    NSLog(@"newGuestForTableID>done");
    
  } failure:^(NSError *error) {
    
    NSLog(@"newGuestForTableID>%@", error);
    
  }];
  
  restaurantMenuVC.delegate = self;
  [self.navigationController pushViewController:restaurantMenuVC animated:YES];
  
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
