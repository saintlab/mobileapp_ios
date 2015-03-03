//
//  OMNR1VC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNR1VC.h"
#import "OMNOrdersVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNSocketManager.h"
#import "OMNLightBackgroundButton.h"
#import "OMNAnalitics.h"
#import "OMNPaymentNotificationControl.h"
#import "OMNCircleAnimation.h"
#import "OMNRestaurantInfoVC.h"
#import "OMNMenuModel.h"
#import "OMNMenuVC.h"
#import "OMNTableButton.h"
#import "UIBarButtonItem+omn_custom.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"

@interface OMNR1VC ()
<OMNRestaurantInfoVCDelegate>

@end

@implementation OMNR1VC {
  
  OMNCircleAnimation *_circleAnimation;
  OMNRestaurantMediator *_restaurantMediator;
  UIPercentDrivenInteractiveTransition *_interactiveTransition;
  NSString *_restaurantWaiterCallIdentifier;
  NSString *_restaurantMenuOserverID;
  
  OMNMenuModel *_menuModel;
  
  OMNTableButton *_tableButton;
  BOOL _showTableButtonAnimation;
  
}

- (void)dealloc {
  
  _circleAnimation = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  if (_restaurantWaiterCallIdentifier) {
    [_restaurantMediator.visitor bk_removeObserversWithIdentifier:_restaurantWaiterCallIdentifier];
  }
  if (_restaurantMenuOserverID) {
    [_restaurantMediator bk_removeObserversWithIdentifier:_restaurantMenuOserverID];
  }
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super initWithParent:nil];
  if (self) {
    
    _restaurantMediator = restaurantMediator;

  }
  return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitioning {
  
  return _interactiveTransition;
  
}

- (BOOL)isViewVisible {
  
  return [self.navigationController.topViewController isEqual:self];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _circleAnimation = [[OMNCircleAnimation alloc] initWithCircleButton:self.circleButton];

  self.navigationItem.title = @"";
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidPay:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];

  [[OMNAnalitics analitics] logEnterRestaurant:_restaurantMediator.restaurant mode:kRestaurantEnterModeApplicationLaunch];
  
  [self omn_setup];
  [self loadBackgroundIfNeeded];
  [self loadIconIfNeeded];

  @weakify(self)
  _restaurantWaiterCallIdentifier = [_restaurantMediator.visitor bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:NSKeyValueObservingOptionNew task:^(OMNVisitor *visitor, NSDictionary *change) {
    
    @strongify(self)
    (visitor.waiterIsCalled) ? ([self callWaiterDidStart]) : ([self callWaiterDidStop]);
    
  }];
  
  _restaurantMenuOserverID = [_restaurantMediator bk_addObserverForKeyPath:NSStringFromSelector(@selector(menu)) options:(NSKeyValueObservingOptionNew) task:^(OMNRestaurantMediator *obj, NSDictionary *change) {
    
    @strongify(self)
    [self menuDidChange:obj.menu];
    
  }];

  _menuModel.didEndDraggingBlock = ^(UITableView *tableView) {
    
    if (tableView.contentOffset.y > -20.0f) {
      
      @strongify(self)
      [self menuTap];
      
    }
    
  };
  
  self.circleBackground = _restaurantMediator.restaurant.decoration.circleBackground;
  
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self updateNavigationButtons];
  
  @weakify(self)
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  
    @strongify(self)
    [self beginCircleAnimationIfNeeded];
    
  });
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [_circleAnimation finishCircleAnimation];
  [_tableButton removeFromSuperview] ,_tableButton = nil;
  
}

- (void)updateNavigationButtons {
  
  self.navigationItem.leftBarButtonItem = nil;
  self.navigationItem.rightBarButtonItem = nil;

  OMNRestaurant *restaurant = _restaurantMediator.restaurant;
  if (restaurant.is_demo) {
    
    OMNLightBackgroundButton *cancelButton = [[OMNLightBackgroundButton alloc] init];
    [cancelButton setTitle:NSLocalizedString(@"Выйти из Демо", nil) forState:UIControlStateNormal];
    [cancelButton addTarget:_restaurantMediator action:@selector(exitRestaurant) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
  }
  else {
    
    UIColor *color = restaurant.decoration.antagonist_color;
    UIButton *userButton = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:color target:_restaurantMediator action:@selector(showUserProfile)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userButton];

    if (kRestaurantMode2gis_dinner != restaurant.enterance_mode) {
      
      self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"back_button"] color:color target:_restaurantMediator action:@selector(exitRestaurant)];

    }
    
    if (!_showTableButtonAnimation &&
        _restaurantMediator.visitor.showTableButton) {

      _showTableButtonAnimation = YES;
      _tableButton = [OMNTableButton buttonWithColor:color];
      [_tableButton addTarget:_restaurantMediator action:@selector(showUserProfile) forControlEvents:UIControlEventTouchUpInside];
      [_tableButton setText:_restaurantMediator.visitor.tableName];
      _tableButton.center = userButton.center;
      [userButton.superview addSubview:_tableButton];
      CGFloat centerX = CGRectGetWidth(userButton.superview.frame)/2.0f;
      _tableButton.transform = CGAffineTransformMakeTranslation(centerX - _tableButton.center.x, 0.0f);
      _tableButton.alpha = 0.0f;
      
      [UIView animateWithDuration:0.8 delay:1.0 options:kNilOptions animations:^{
        
        _tableButton.alpha = 1.0f;
        
      } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          
          _tableButton.transform = CGAffineTransformIdentity;
          userButton.alpha = 0.0f;
          
        } completion:^(BOOL finished1) {
          
          [UIView animateWithDuration:0.8 delay:2.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            _tableButton.alpha = 0.0f;
            userButton.alpha = 1.0f;
            
          } completion:^(BOOL finished2) {
            
            [_tableButton removeFromSuperview], _tableButton = nil;
            
          }];
          
        }];
        
      }];
      
    }
    
  }
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleLightContent;
  
}

- (void)pan:(UIPanGestureRecognizer *)panGR {
  
  CGPoint translation = [panGR translationInView:panGR.view];
  CGFloat percentage = MAX(0.0f, -translation.y / panGR.view.bounds.size.height);
  CGFloat velocity = [panGR velocityInView:panGR.view].y;
  
  switch (panGR.state) {
    case UIGestureRecognizerStateBegan: {
      
      _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
      [self showRestaurantInfo];
      
    } break;
    case UIGestureRecognizerStateChanged: {
      
      [_interactiveTransition updateInteractiveTransition:percentage];

      break;
    }
    case UIGestureRecognizerStateEnded: {
      
      if (percentage > 0.3f ||
          velocity < -100.0f) {
        
        [_interactiveTransition finishInteractiveTransition];
        
      }
      else {
        
        [_interactiveTransition cancelInteractiveTransition];
        
      }
      _interactiveTransition = nil;
      
    } break;
    case UIGestureRecognizerStateCancelled: {
      
      [_interactiveTransition cancelInteractiveTransition];
      _interactiveTransition = nil;
      
    } break;
    default:
      break;
  }
  
}

- (void)loadIconIfNeeded {

  UIImage *logo = _restaurantMediator.restaurant.decoration.logo;
  if (logo) {
    self.circleIcon = logo;
    return;
  }
  
  @weakify(self)
  [_restaurantMediator.restaurant.decoration loadLogo:^(UIImage *image) {
    
    @strongify(self)
    if (image) {
      
      self.circleIcon = image;
      
    }
    else {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadIconIfNeeded];
        
      });
    }
    
  }];
  
}

- (void)loadBackgroundIfNeeded {

  OMNRestaurantDecoration *decoration = _restaurantMediator.restaurant.decoration;
  if (decoration.background_image) {

    self.backgroundImage = decoration.background_image;
    return;
    
  }
  
  [self setBackgroundImage:[UIImage imageNamed:@"wood_bg"] animated:NO];
  
  if (!decoration.hasBackgroundImage) {
    return;
  }
  
  @weakify(self)
  [decoration loadBackground:^(UIImage *image) {
    
    @strongify(self)
    if (image) {
      
      [self setBackgroundImage:image animated:YES];
      
    }
    else {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadBackgroundIfNeeded];
        
      });
    }
    
  }];

}

- (void)menuDidChange:(OMNMenu *)menu {
  
  _menuModel.menu = menu;
  [_menuTable reloadData];
  
  CGFloat bottomInset = _menuTable.frame.size.height - _menuTable.contentSize.height - kMenuTableTopOffset;
  _menuTable.contentInset = UIEdgeInsetsMake(kMenuTableTopOffset, 0.0f, bottomInset, 0.0f);

  [UIView animateWithDuration:0.5 animations:^{
    
    _menuTable.alpha = (menu.products.count > 0) ? (1.0f) : (0.0f);
    
  }];
  
}

- (void)orderDidPay:(NSNotification *)n {
  
  id paymentData = n.userInfo[OMNPaymentDataKey];
  OMNPaymentDetails *paymentDetails = [[OMNPaymentDetails alloc] initWithJsonData:paymentData];
  [OMNPaymentNotificationControl showWithPaymentDetails:paymentDetails];

}

- (void)omn_setup {
  
  UIImageView *topGradientView = [UIImageView omn_autolayoutView];
  topGradientView.image = [UIImage imageNamed:@"top_gradient"];
  [self.backgroundView addSubview:topGradientView];
  
  UIImageView *gradientView = [UIImageView omn_autolayoutView];
  gradientView.image = [UIImage imageNamed:@"menu_gradient_bg"];
  [self.backgroundView addSubview:gradientView];
  
  NSMutableDictionary *views =
  [@{
     @"topGradientView" : topGradientView,
     @"gradientView" : gradientView,
     } mutableCopy];
  
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[gradientView]|" options:kNilOptions metrics:nil views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradientView]|" options:kNilOptions metrics:nil views:views]];
  
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[gradientView]|" options:kNilOptions metrics:nil views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGradientView]" options:kNilOptions metrics:nil views:views]];
  
  if (_restaurantMediator.restaurant.settings.has_menu) {
    
    _menuModel = [[OMNMenuModel alloc] init];
    _menuTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _menuTable.alpha = 0.0f;
    _menuTable.clipsToBounds = NO;
    _menuTable.showsVerticalScrollIndicator = NO;
    _menuTable.allowsSelection = NO;
    _menuTable.translatesAutoresizingMaskIntoConstraints = NO;
    [_menuModel configureTableView:_menuTable];
    [self.view insertSubview:_menuTable belowSubview:self.circleButton];
    
    views[@"menuTable"] = _menuTable;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuTable]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.circleButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTap)];
    [_menuTable addGestureRecognizer:tapGR];
    
  }
  else {

    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panGR];

    UIButton *actionButton = [[UIButton alloc] init];
    actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    [actionButton addTarget:self action:@selector(showRestaurantInfo) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setImage:[UIImage imageNamed:@"down_button_icon"] forState:UIControlStateNormal];
    [self.view addSubview:actionButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-[OMNStyler styler].bottomToolbarHeight.floatValue]];
    
    [self.view layoutIfNeeded];
    
  }
  
}

- (void)menuTap {
  
  if (!_restaurantMediator.menu.products.count > 0) {
    return;
  }
  
  OMNMenuVC *menuVC = [[OMNMenuVC alloc] initWithMediator:_restaurantMediator];
  @weakify(self)
  menuVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.navigationController popToViewController:self animated:YES];
    
  };
  menuVC.backgroundImage = self.backgroundImage;
  [self.navigationController pushViewController:menuVC animated:YES];
  
}

- (void)showRestaurantInfo {
  
  OMNRestaurantInfoVC *restaurantInfoVC = [[OMNRestaurantInfoVC alloc] initWithRestaurant:_restaurantMediator.restaurant];
  restaurantInfoVC.delegate = self;
  [self.navigationController pushViewController:restaurantInfoVC animated:YES];
  
}

- (void)beginCircleAnimationIfNeeded {

  if (_restaurantMediator.visitor.waiterIsCalled &&
      [self.navigationController.topViewController isEqual:self]) {
    
    [_circleAnimation beginCircleAnimationIfNeededWithImage:[UIImage imageNamed:@"bell_ringing_icon_white_big"]];
    
  }
  
}

- (void)callWaiterDidStart {
  
  [self beginCircleAnimationIfNeeded];
  
}

- (void)callWaiterDidStop {
  
  [_circleAnimation finishCircleAnimation];

}

#pragma mark - OMNRestaurantInfoVCDelegate

- (void)restaurantInfoVCDidFinish:(OMNRestaurantInfoVC *)restaurantInfoVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

@end
