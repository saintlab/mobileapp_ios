//
//  OMNStartVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStartVC.h"
#import "UIImage+omn_helper.h"
#import "OMNAuthorization.h"
#import "OMNSearchRestaurantVC.h"
#import "OMNNavigationController.h"
#import "UINavigationController+omn_replace.h"
#import "OMNLaunchHandler.h"

@implementation OMNStartVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  self.backgroundView.image = [UIImage omn_imageNamed:@"LaunchImage-700"];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  @weakify(self)
  dispatch_async(dispatch_get_main_queue(), ^{
    
    @strongify(self)
    [self startSearchingRestaurant];
    
  });
  
}

- (void)reload {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startSearchingRestaurant {
  
  OMNSearchRestaurantVC *searchRestaurantVC = [[OMNSearchRestaurantVC alloc] init];
  UINavigationController *navigationController = [OMNNavigationController controllerWithRootVC:searchRestaurantVC];
  navigationController.navigationBar.barStyle = UIBarStyleDefault;
  [self presentViewController:navigationController animated:NO completion:nil];
  
}

@end
