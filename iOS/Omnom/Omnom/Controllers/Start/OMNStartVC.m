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

@interface OMNStartVC ()

@end

@implementation OMNStartVC {
  OMNNavigationControllerDelegate *_navigationControllerDelegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
  
  UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage omn_imageNamed:@"LaunchImage-700"]];
  [self.view addSubview:bgView];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithImage:nil title:NSLocalizedString(@"Определение вашего столика", nil) buttons:@[]];
  [self.navigationController pushViewController:searchBeaconVC animated:YES];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
