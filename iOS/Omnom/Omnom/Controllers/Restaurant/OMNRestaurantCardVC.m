//
//  OMNRestaurantCardVC.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantCardVC.h"
#import "OMNRestaurantDetailsView.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNToolbarButton.h"
#import "OMNBorderedButton.h"
#import "OMNBottomTextButton.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNRestaurantActionsVC.h"

@implementation OMNRestaurantCardVC {
  
  OMNRestaurantDetailsView *_restaurantDetailsView;
  UIImageView *_imageView;
  OMNRestaurant *_restaurant;
  OMNBorderedButton *_phoneButton;
  
  OMNBottomTextButton *_reserveButton;
  OMNBottomTextButton *_insideButton;
  OMNBottomTextButton *_preorderButton;
  
}

- (void)dealloc {
  
  @try {
    [_restaurant.decoration removeObserver:self forKeyPath:NSStringFromSelector(@selector(background_image))];
  }
  @catch (NSException *exception) {}
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    _restaurant = restaurant;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
 
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setup];
  
  UIColor *titleColor = _restaurant.decoration.antagonist_color;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:titleColor target:self action:@selector(closeTap)];

  OMNToolbarButton *demoButton = [[OMNToolbarButton alloc] initWithFitImage:[UIImage imageNamed:@"demo_mode_icon_small"] title:NSLocalizedString(@"Демо-режим", nil) color:titleColor];
  [demoButton addTarget:self action:@selector(demoTap) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:demoButton];

  [_restaurant.decoration addObserver:self forKeyPath:NSStringFromSelector(@selector(background_image)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) context:NULL];
  [_restaurant.decoration loadBackground:^(UIImage *image) {
  }];
  _restaurantDetailsView.restaurant = _restaurant;

  [_phoneButton setTitle:_restaurant.phone forState:UIControlStateNormal];
  [_phoneButton addTarget:self action:@selector(callTap) forControlEvents:UIControlEventTouchUpInside];

  [_reserveButton setTitle:@"Бронировать\nстолик" image:[UIImage imageNamed:@"ic_reserve_table"] color:colorWithHexString(@"157EFB")];
  _reserveButton.enabled = _restaurant.settings.has_table_order;
  
  [_insideButton setTitle:@"Я внутри" image:[UIImage imageNamed:@"ic_im_inside"] color:colorWithHexString(@"157EFB")];
  [_insideButton addTarget:self action:@selector(insideRestaurantTap) forControlEvents:UIControlEventTouchUpInside];
  _insideButton.enabled = YES;

  [_preorderButton setTitle:@"Сделать\nпредзаказ" image:[UIImage imageNamed:@"ic_make_order"] color:colorWithHexString(@"157EFB")];
  _preorderButton.enabled = _restaurant.settings.has_pre_order;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setShadowImage:[UIImage new]];
  
}

- (void)callTap {
  
  NSString *cleanedString = [[_restaurant.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
  NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cleanedString];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
  
}

- (void)insideRestaurantTap {
  
  OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithRestaurant:_restaurant];
  [self.navigationController pushViewController:restaurantActionsVC animated:YES];
  
}

- (void)demoTap {
  
}

- (void)closeTap {
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([object isEqual:_restaurant.decoration] &&
      [keyPath isEqualToString:NSStringFromSelector(@selector(background_image))]) {
    
    _imageView.image = _restaurant.decoration.background_image;
    
  } else {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
  }
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleLightContent;
  
}

- (void)setup {
  
  _imageView = [UIImageView omn_autolayoutView];
  _imageView.clipsToBounds = YES;
  _imageView.opaque = YES;
  _imageView.backgroundColor = [UIColor whiteColor];
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  [self.view addSubview:_imageView];
  
  _phoneButton = [OMNBorderedButton omn_autolayoutView];
  _phoneButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [self.view addSubview:_phoneButton];
  
  _restaurantDetailsView = [OMNRestaurantDetailsView omn_autolayoutView];
  [self.view addSubview:_restaurantDetailsView];
  
  UIView *bottonsView = [UIView omn_autolayoutView];
  [self.view addSubview:bottonsView];
  
  _reserveButton = [OMNBottomTextButton omn_autolayoutView];
  _reserveButton.label.font = FuturaOSFOmnomRegular(16.0f);
  [bottonsView addSubview:_reserveButton];
  
  _insideButton = [OMNBottomTextButton omn_autolayoutView];
  _insideButton.label.font = FuturaOSFOmnomRegular(16.0f);
  [bottonsView addSubview:_insideButton];
  
  _preorderButton = [OMNBottomTextButton omn_autolayoutView];
  _preorderButton.label.font = FuturaOSFOmnomRegular(16.0f);
  [bottonsView addSubview:_preorderButton];
  
  UIView *fillView1 = [UIView omn_autolayoutView];
  fillView1.hidden = YES;
  [bottonsView addSubview:fillView1];
  
  UIView *fillView2 = [UIView omn_autolayoutView];
  fillView2.hidden = YES;
  [bottonsView addSubview:fillView2];
  
  UIView *fillView3 = [UIView omn_autolayoutView];
  fillView3.hidden = YES;
  [self.view addSubview:fillView3];
  
  UIView *fillView4 = [UIView omn_autolayoutView];
  fillView4.hidden = YES;
  [self.view addSubview:fillView4];
  
  NSDictionary *views =
  @{
    @"imageView" : _imageView,
    @"phoneButton" : _phoneButton,
    @"restaurantDetailsView" : _restaurantDetailsView,
    @"bottonsView" : bottonsView,
    @"reserveButton" : _reserveButton,
    @"insideButton" : _insideButton,
    @"preorderButton" : _preorderButton,
    @"fillView1" : fillView1,
    @"fillView2" : fillView2,
    @"fillView3" : fillView3,
    @"fillView4" : fillView4,
    };
  
  NSDictionary *metrics =
  @{
    @"imageHeight" : @(200),
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[reserveButton(>=0)][fillView1(>=0)][insideButton(==reserveButton)][fillView2(==fillView1)][preorderButton(==reserveButton)]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[reserveButton]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[insideButton]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[preorderButton]|" options:kNilOptions metrics:metrics views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[bottonsView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];

  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[restaurantDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(<=imageHeight)]-(20)-[restaurantDetailsView]-(10)-[phoneButton]-(10)-[fillView3(>=0)][bottonsView][fillView4(==fillView3)]-(10)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

@end
