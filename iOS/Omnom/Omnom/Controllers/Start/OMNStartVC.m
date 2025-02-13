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
#import "OMNLogoVC.h"
#import "OMNNavigationController.h"
#import "UINavigationController+omn_replace.h"
#import "OMNLaunchHandler.h"

@implementation OMNStartVC {
  BOOL _readyForReload;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  self.backgroundView.image = [UIImage omn_imageNamed:@"LaunchImage-700"];
  
}

- (BOOL)readyForReload {
  return _readyForReload;
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
  
  _readyForReload = NO;
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)startSearchingRestaurant {
  
  OMNLogoVC *logoVC = [[OMNLogoVC alloc] init];
  [logoVC present:self].then(^{
    
    _readyForReload = YES;
    [logoVC.searchRestaurantMediator searchRestarants];
    
  });
  
}

@end
