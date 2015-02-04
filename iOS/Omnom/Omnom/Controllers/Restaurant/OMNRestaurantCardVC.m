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
#import <BlocksKit.h>

@implementation OMNRestaurantCardVC {
  
  OMNRestaurantDetailsView *_restaurantDetailsView;
  UIButton *_logoIcon;
  OMNRestaurant *_restaurant;
  OMNBorderedButton *_phoneButton;
  
  UIScrollView *_scroll;
  
  OMNBottomTextButton *_reserveButton;
  OMNBottomTextButton *_insideButton;
  OMNBottomTextButton *_preorderButton;
  
  OMNSearchRestaurantMediator *_searchRestaurantMediator;
  UIView *_bottomView;
  UIView *_contentView;
 
  NSString *_restaurantDecorationObserverID;
  
}

- (void)dealloc {
  
  if (_restaurantDecorationObserverID) {
    [_restaurant.decoration bk_removeObserversWithIdentifier:_restaurantDecorationObserverID];
  }
  
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
  
  __weak UIButton *logoIcon = _logoIcon;
  _restaurantDecorationObserverID = [_restaurant.decoration bk_addObserverForKeyPath:NSStringFromSelector(@selector(logo)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNRestaurantDecoration *obj, NSDictionary *change) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
      UIImage *circleImage = [_restaurant.decoration.logo omn_circleImageWithDiametr:175.0f];
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [logoIcon setImage:circleImage forState:UIControlStateNormal];
        
      });
      
    });
    
  }];

  [_restaurant.decoration loadLogo:^(UIImage *image) {}];
  _restaurantDetailsView.restaurant = _restaurant;

  [_phoneButton setTitle:_restaurant.phone forState:UIControlStateNormal];
  [_phoneButton addTarget:self action:@selector(callTap) forControlEvents:UIControlEventTouchUpInside];

  UIColor *defaultColor = colorWithHexString(@"157EFB");
  UIColor *disabledColor = colorWithHexString(@"A1A1A1");
  [_reserveButton setTitle:@"Бронировать\nстолик" image:[UIImage imageNamed:@"ic_reserve_table"] color:defaultColor disabledColor:disabledColor];
  _reserveButton.enabled = NO;
  
  [_insideButton setTitle:@"Я внутри" image:[UIImage imageNamed:@"ic_im_inside"] color:defaultColor disabledColor:disabledColor];
  [_insideButton addTarget:self action:@selector(insideRestaurantTap) forControlEvents:UIControlEventTouchUpInside];
  _insideButton.enabled = YES;

  [_preorderButton setTitle:@"Сделать\nпредзаказ" image:[UIImage imageNamed:@"ic_make_order"] color:defaultColor disabledColor:disabledColor];
  _preorderButton.enabled = NO;
  
  [_logoIcon setBackgroundImage:[[UIImage imageNamed:@"restaurant_card_circle_bg"] omn_tintWithColor:_restaurant.decoration.background_color] forState:UIControlStateNormal];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  [self.navigationController.navigationBar omn_setTransparentBackground];

  [self.view layoutIfNeeded];
  _scroll.contentSize = _contentView.frame.size;
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(_bottomView.frame), 0.0f);
  _scroll.contentInset = insets;
  _scroll.scrollIndicatorInsets = insets;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.showQRScan) {
    
    [self insideRestaurantTap];
    
  }
  
}

- (void)callTap {
  
  NSString *cleanedString = [[_restaurant.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
  NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cleanedString];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
  
}

- (void)insideRestaurantTap {
  
  self.showQRScan = NO;
  if (_restaurant.hasTable) {

    [_searchRestaurantMediator showRestaurants:@[_restaurant]];
    
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

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleDefault;
  
}

- (void)setup {
  
  _scroll = [UIScrollView omn_autolayoutView];
  [self.view addSubview:_scroll];

  _contentView = [UIView omn_autolayoutView];
  [_scroll addSubview:_contentView];
  
  _bottomView = [UIView omn_autolayoutView];
  _bottomView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  [self.view addSubview:_bottomView];
  
  _logoIcon = [UIButton omn_autolayoutView];
  _logoIcon.userInteractionEnabled = NO;
  [_logoIcon setBackgroundImage:[UIImage imageNamed:@"restaurant_card_circle_bg"] forState:UIControlStateNormal];
  [_contentView addSubview:_logoIcon];
  
  _phoneButton = [OMNBorderedButton omn_autolayoutView];
  _phoneButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_contentView addSubview:_phoneButton];
  
  _restaurantDetailsView = [OMNRestaurantDetailsView omn_autolayoutView];
  [_contentView addSubview:_restaurantDetailsView];
  
  UIView *bottonsView = [UIView omn_autolayoutView];
  [_bottomView addSubview:bottonsView];
  
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
  
  NSDictionary *views =
  @{
    @"contentView" : _contentView,
    @"scroll" : _scroll,
    @"bottomView" : _bottomView,
    @"logoIcon" : _logoIcon,
    @"phoneButton" : _phoneButton,
    @"restaurantDetailsView" : _restaurantDetailsView,
    @"bottonsView" : bottonsView,
    @"reserveButton" : _reserveButton,
    @"insideButton" : _insideButton,
    @"preorderButton" : _preorderButton,
    @"fillView1" : fillView1,
    @"fillView2" : fillView2,
    };

  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];

  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[reserveButton(>=0)][fillView1(>=0)][insideButton(==reserveButton)][fillView2(==fillView1)][preorderButton(==reserveButton)]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[reserveButton]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[insideButton]|" options:kNilOptions metrics:metrics views:views]];
  [bottonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[preorderButton]|" options:kNilOptions metrics:metrics views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[bottonsView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(leftOffset)-[bottonsView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomView]|" options:kNilOptions metrics:metrics views:views]];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[restaurantDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[logoIcon]-(20)-[restaurantDetailsView]-(10)-[phoneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_phoneButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

@end
