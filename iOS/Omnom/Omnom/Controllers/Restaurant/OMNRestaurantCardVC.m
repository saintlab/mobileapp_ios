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
#import "UIImage+omn_helper.h"
#import "UINavigationBar+omn_custom.h"

@interface OMNRestaurantCardVC ()

@end

@implementation OMNRestaurantCardVC {
  
  OMNRestaurantDetailsView *_restaurantDetailsView;
  UIButton *_logoIcon;
  OMNRestaurant *_restaurant;
  OMNBorderedButton *_phoneButton;
  
  OMNBottomTextButton *_reserveButton;
  OMNBottomTextButton *_insideButton;
  OMNBottomTextButton *_preorderButton;
  
  OMNSearchRestaurantMediator *_searchRestaurantMediator;
  
}

- (void)dealloc {
  
  @try {
    [_restaurant.decoration removeObserver:self forKeyPath:NSStringFromSelector(@selector(logo))];
  }
  @catch (NSException *exception) {}
  
}

- (instancetype)initWithMediator:(OMNSearchRestaurantMediator *)searchRestaurantMediator restaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _searchRestaurantMediator = searchRestaurantMediator;
    _restaurant = restaurant;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
 
  self.view.backgroundColor = [UIColor whiteColor];
  [self.navigationItem setHidesBackButton:YES animated:NO];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  
  [self setup];
  
  self.navigationItem.titleView = [UIBarButtonItem omn_buttonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  [_restaurant.decoration addObserver:self forKeyPath:NSStringFromSelector(@selector(logo)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) context:NULL];
  [_restaurant.decoration loadLogo:^(UIImage *image) {}];
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
  
  [_logoIcon setBackgroundImage:[[UIImage imageNamed:@"restaurant_card_circle_bg"] omn_tintWithColor:_restaurant.decoration.background_color] forState:UIControlStateNormal];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 

  [self.navigationController setNavigationBarHidden:NO animated:NO];
  [self.navigationController.navigationBar omn_setTransparentBackground];
  
}

- (void)callTap {
  
  NSString *cleanedString = [[_restaurant.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
  NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cleanedString];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
  
}

- (void)insideRestaurantTap {
  
  if ([_restaurant hasTable]) {

    [_searchRestaurantMediator showRestaurant:_restaurant];
    
  }
  else {
    
    [_searchRestaurantMediator scanTableQrTap];
    
  }
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([object isEqual:_restaurant.decoration] &&
      [keyPath isEqualToString:NSStringFromSelector(@selector(logo))]) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
      UIImage *circleImage = [_restaurant.decoration.logo omn_circleImageWithDiametr:175.0f];
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [_logoIcon setImage:circleImage forState:UIControlStateNormal];
        
      });
      
    });
    
  } else {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
  }
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleDefault;
  
}

- (void)setup {
  
  _logoIcon = [UIButton omn_autolayoutView];
  _logoIcon.userInteractionEnabled = NO;
  [_logoIcon setBackgroundImage:[UIImage imageNamed:@"restaurant_card_circle_bg"] forState:UIControlStateNormal];
  [self.view addSubview:_logoIcon];
  
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
    @"logoIcon" : _logoIcon,
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
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[reserveButton(>=0)][fillView1(>=0)][insideButton(==reserveButton)][fillView2(==fillView1)][preorderButton(==reserveButton)]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[reserveButton]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[insideButton]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[preorderButton]|" options:kNilOptions metrics:metrics views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[bottonsView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];

  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[restaurantDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(74)-[logoIcon]-(<=20)-[restaurantDetailsView]-(10)-[phoneButton]-(10)-[fillView3(>=0)][bottonsView][fillView4(==fillView3)]-(10)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_phoneButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_logoIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

@end
