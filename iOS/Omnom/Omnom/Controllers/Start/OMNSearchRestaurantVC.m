//
//  OMNSplashVC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchRestaurantVC.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNLaunchHandler.h"

@interface OMNSearchRestaurantVC ()

@property (nonatomic, strong) OMNSearchRestaurantMediator *searchRestaurantMediator;

@end

@implementation OMNSearchRestaurantVC

- (instancetype)init {
  self = [super initWithNibName:@"OMNSearchRestaurantVC" bundle:nil];
  if (self) {
    
    _searchRestaurantMediator = [[OMNSearchRestaurantMediator alloc] initWithRootVC:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.bgIV.image = [[UIImage imageNamed:@"wood_bg"] omn_blendWithColor:colorWithHexString(@"CE1200")];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  _logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross-small-new"]];
  
  CGFloat iconsCenter = (IS_IPHONE_4_OR_LESS) ? (240.0f) : (284.0f);
  self.logoIconsIV.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, iconsCenter);
  
  _logoIV.center = CGPointMake(165.0f, self.logoIconsIV.center.y);
  [self.view addSubview:_logoIV];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  @weakify(self)
  dispatch_async(dispatch_get_main_queue(), ^{
  
    @strongify(self)
    [self.searchRestaurantMediator searchRestarants];

  });
  
}

@end
