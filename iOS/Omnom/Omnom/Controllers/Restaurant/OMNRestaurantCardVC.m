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
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "UINavigationBar+omn_custom.h"
#import <BlocksKit.h>
#import "OMNRestaurantCardButtonsView.h"

@interface OMNRestaurantCardVC ()
<OMNRestaurantCardButtonsViewDelegate>

@end

@implementation OMNRestaurantCardVC {
  
  OMNRestaurantDetailsView *_restaurantDetailsView;
  UIButton *_logoIcon;
  OMNRestaurant *_restaurant;
  OMNBorderedButton *_phoneButton;
  
  UIScrollView *_scroll;
  
  OMNSearchRestaurantMediator *_searchRestaurantMediator;
  UIView *_bottomView;
  UIView *_contentView;
  OMNRestaurantCardButtonsView *_buttonsView;
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
  
  [self omn_setup];

  _buttonsView.delegate = self;
  
  [_logoIcon setBackgroundImage:[[UIImage imageNamed:@"restaurant_card_circle_bg"] omn_tintWithColor:_restaurant.decoration.background_color] forState:UIControlStateNormal];
  
  self.navigationItem.titleView = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  __weak UIButton *logoIcon = _logoIcon;
  _restaurantDecorationObserverID = [_restaurant.decoration bk_addObserverForKeyPath:NSStringFromSelector(@selector(logo)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNRestaurantDecoration *obj, NSDictionary *change) {
    
    dispatch_promise(^id{
      
      return [_restaurant.decoration.logo omn_circleImageWithDiametr:175.0f];
      
    }).then(^(UIImage *image) {
      
      [UIView transitionWithView:logoIcon duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        [logoIcon setImage:image forState:UIControlStateNormal];
        
      } completion:nil];
      
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
    
    [self onTableTap];
    
  }
  
}

- (void)callTap {
  
  NSString *cleanedString = [[_restaurant.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
  NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cleanedString];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
  
}

#pragma mark - OMNRestaurantCardButtonsViewDelegate

- (void)cardButtonsView:(OMNRestaurantCardButtonsView *)view didSelectVisitor:(OMNVisitor *)visitor {
  
  [visitor enter:self].then(^(OMNVisitor *enteredVisitor) {
    
    [_searchRestaurantMediator showVisitor:enteredVisitor];
    
  }).catch(^(OMNError *error) {
    
    NSLog(@"%@", error);
    
  });
  
}

- (void)onTableTap {
  
  self.showQRScan = NO;
  if (_restaurant.canProcess) {

    [_searchRestaurantMediator showVisitor:[OMNVisitor visitorWithRestaurant:_restaurant delivery:[OMNDelivery delivery]]];
    
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

- (void)omn_setup {
  
  _scroll = [UIScrollView omn_autolayoutView];
  [self.view addSubview:_scroll];

  _contentView = [UIView omn_autolayoutView];
  [_scroll addSubview:_contentView];
  
  _bottomView = [UIView omn_autolayoutView];
  _bottomView.backgroundColor = [OMNStyler toolbarColor];
  [self.view addSubview:_bottomView];
  
  _logoIcon = [UIButton omn_autolayoutView];
  _logoIcon.userInteractionEnabled = NO;
  [_contentView addSubview:_logoIcon];
  
  _phoneButton = [OMNBorderedButton omn_autolayoutView];
  _phoneButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_contentView addSubview:_phoneButton];
  
  _restaurantDetailsView = [OMNRestaurantDetailsView omn_autolayoutView];
  [_contentView addSubview:_restaurantDetailsView];
  
  _buttonsView = [[OMNRestaurantCardButtonsView alloc] initWithRestaurant:_restaurant];
  [_bottomView addSubview:_buttonsView];
  
  NSDictionary *views =
  @{
    @"contentView" : _contentView,
    @"scroll" : _scroll,
    @"bottomView" : _bottomView,
    @"logoIcon" : _logoIcon,
    @"phoneButton" : _phoneButton,
    @"restaurantDetailsView" : _restaurantDetailsView,
    @"buttonsView" : _buttonsView,
    };

  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
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
