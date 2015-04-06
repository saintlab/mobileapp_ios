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
#import "OMNLunchOrderAlertVC.h"
#import "OMNBarVisitor.h"
#import "OMNPreorderVisitor.h"

@implementation OMNRestaurantCardVC {
  
  OMNRestaurantDetailsView *_restaurantDetailsView;
  UIButton *_logoIcon;
  OMNRestaurant *_restaurant;
  OMNBorderedButton *_phoneButton;
  
  UIScrollView *_scroll;
  
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
  
  self.navigationItem.titleView = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
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
    
    [self inTap];
    
  }
  
}

- (void)callTap {
  
  NSString *cleanedString = [[_restaurant.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
  NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cleanedString];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
  
}

- (void)inTap {
  
  self.showQRScan = NO;
  if (_restaurant.canProcess) {

    [_searchRestaurantMediator showVisitor:[OMNVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery delivery]]];
    
  }
  else {
    
    [_searchRestaurantMediator scanTableQrTap];
    
  }
  
}

- (void)barTap {
  [_searchRestaurantMediator showVisitor:[OMNBarVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery delivery]]];
}

- (void)lunchTap {
  
  OMNLunchOrderAlertVC *lunchOrderAlertVC = [[OMNLunchOrderAlertVC alloc] initWithRestaurant:_restaurant];
  @weakify(self)
  lunchOrderAlertVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  OMNSearchRestaurantMediator *searchRestaurantMediator = _searchRestaurantMediator;
  lunchOrderAlertVC.didSelectVisitorBlock = ^(OMNVisitor *visitor) {

    @strongify(self)
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [searchRestaurantMediator showVisitor:visitor];
    
  };
  [self.navigationController presentViewController:lunchOrderAlertVC animated:YES completion:nil];
  
}

- (void)preorderTap {
  [_searchRestaurantMediator showVisitor:[OMNPreorderVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery delivery]]];
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
  _bottomView.backgroundColor = [OMNStyler toolbarColor];
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
  
  UIView *buttonsView = [UIView omn_autolayoutView];
  [_bottomView addSubview:buttonsView];
  
  NSMutableArray *buttons = [NSMutableArray array];
  UIColor *defaultColor = [OMNStyler blueColor];
  UIColor *disabledColor = colorWithHexString(@"A1A1A1");

  if (_restaurant.settings.has_bar) {
    
    OMNBottomTextButton *barButton = [OMNBottomTextButton omn_autolayoutView];
    [barButton setTitle:kOMN_RESTAURANT_MODE_BAR_TITLE image:[UIImage imageNamed:@"card_ic_bar"] highlightedImage:[UIImage imageNamed:@"card_ic_bar_selected"] color:defaultColor disabledColor:disabledColor];
    [barButton addTarget:self action:@selector(barTap) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:barButton];
  }
  
  if (_restaurant.settings.has_table_order) {
    
    OMNBottomTextButton *orderButton = [OMNBottomTextButton omn_autolayoutView];
    [orderButton setTitle:kOMN_RESTAURANT_MODE_IN_TITLE image:[UIImage imageNamed:@"card_ic_table"] highlightedImage:[UIImage imageNamed:@"card_ic_table_selected"] color:defaultColor disabledColor:disabledColor];
    [orderButton addTarget:self action:@selector(inTap) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:orderButton];
    
  }
  
  if (_restaurant.settings.has_lunch) {
    
    OMNBottomTextButton *lunchButton = [OMNBottomTextButton omn_autolayoutView];
    [lunchButton setTitle:kOMN_RESTAURANT_MODE_LUNCH_TITLE image:[UIImage imageNamed:@"card_ic_order"] highlightedImage:[UIImage imageNamed:@"card_ic_order_selected"] color:defaultColor disabledColor:disabledColor];
    [lunchButton addTarget:self action:@selector(lunchTap) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:lunchButton];
    
  }
  
  if (_restaurant.settings.has_pre_order) {
    
    OMNBottomTextButton *preorderButton = [OMNBottomTextButton omn_autolayoutView];
    [preorderButton setTitle:kOMN_RESTAURANT_MODE_TAKE_AWAY_TITLE image:[UIImage imageNamed:@"card_ic_takeaway"] highlightedImage:[UIImage imageNamed:@"card_ic_takeaway_selected"] color:defaultColor disabledColor:disabledColor];
    [preorderButton addTarget:self action:@selector(preorderTap) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:preorderButton];
    
  }
  
  NSMutableDictionary *buttonViews = [NSMutableDictionary dictionary];
  UIView *fillView = [UIView omn_autolayoutView];
  [buttonsView addSubview:fillView];
  buttonViews[@"v0"] = fillView;
  NSMutableString *format = [NSMutableString stringWithString:@"H:|[v0(>=0)]"];
  
  [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
    
    NSString *buttonName = [NSString stringWithFormat:@"b%lu", (unsigned long)idx];
    buttonViews[buttonName] = button;
    [format appendFormat:@"[%@]", buttonName];
    
    NSString *fillViewName = [NSString stringWithFormat:@"v%lu", (unsigned long)idx + 1];
    UIView *fillView = [UIView omn_autolayoutView];
    [buttonsView addSubview:fillView];
    buttonViews[fillViewName] = fillView;
    
    [format appendFormat:@"[%@(==v0)]", fillViewName];
    
    [buttonsView addSubview:button];
    [buttonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[%@]|", buttonName] options:kNilOptions metrics:nil views:buttonViews]];
    
  }];
  
  [format appendString:@"|"];
  [buttonsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:kNilOptions metrics:nil views:buttonViews]];

  NSDictionary *views =
  @{
    @"contentView" : _contentView,
    @"scroll" : _scroll,
    @"bottomView" : _bottomView,
    @"logoIcon" : _logoIcon,
    @"phoneButton" : _phoneButton,
    @"restaurantDetailsView" : _restaurantDetailsView,
    @"buttonsView" : buttonsView,
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

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[buttonsView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(leftOffset)-[buttonsView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomView]|" options:kNilOptions metrics:metrics views:views]];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[restaurantDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[logoIcon]-(20)-[restaurantDetailsView]-(10)-[phoneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_phoneButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

@end
