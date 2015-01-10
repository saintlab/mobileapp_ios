//
//  OMNSplashVC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchRestaurantVC.h"
#import "UIImage+omn_helper.h"
#import <AFHTTPRequestOperation.h>
#import "UINavigationController+omn_replace.h"
#import <OMNStyler.h>
#import "OMNAnalitics.h"
#import "OMNSearchRestaurantMediator.h"

@interface OMNSearchRestaurantVC ()

@property (nonatomic, strong) OMNSearchRestaurantMediator *searchRestaurantMediator;

@end

@implementation OMNSearchRestaurantVC {
  
}

- (instancetype)init {
  self = [super initWithNibName:@"OMNSearchRestaurantVC" bundle:nil];
  if (self) {
    
    _searchRestaurantMediator = [[OMNSearchRestaurantMediator alloc] initWithRootVC:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _searchRestaurantMediator.qr = self.qr;
  _searchRestaurantMediator.hashString = self.hashString;
  
  __weak typeof(self)weakSelf = self;
  _searchRestaurantMediator.didFinishBlock = ^{
    
    [weakSelf didFinish];
    
  };
  
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
  
  __weak typeof(self)weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
  
    [weakSelf.searchRestaurantMediator searchRestarants];

  });
  
}

- (void)didFinish {
  
  [self.delegate searchRestaurantVCDidFinish:self];
  
}

@end
