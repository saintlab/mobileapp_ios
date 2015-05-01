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
#import "UIView+screenshot.h"
#import <PromiseKit.h>

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
  
  UIActivityIndicatorView *_menuTableLoader;
  OMNTableButton *_tableButton;
  BOOL _tableButtonAnimationDidShow;
  
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
  _restaurantWaiterCallIdentifier = [_restaurantMediator.table bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:NSKeyValueObservingOptionNew task:^(OMNTable *table, NSDictionary *change) {
    
    @strongify(self)
    (table.waiterIsCalled) ? ([self callWaiterDidStart]) : ([self callWaiterDidStop]);
    
  }];
  
  _menuModel.didEndDraggingBlock = ^(UITableView *tableView) {
    
    CGFloat tableTopOffset = tableView.contentOffset.y + tableView.contentInset.top;
    if (tableTopOffset > 50.0f) {
      
      @strongify(self)
      [self showMenuAtCategory:nil];
      
    }
    
  };
  
  _menuModel.didSelectBlock = ^(OMNMenuCategory *selectedMenuCategory) {
    
    @strongify(self)
    [self showMenuAtCategory:selectedMenuCategory];
    
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
  [self removeTableButton];
  
}

- (void)removeTableButton {
  [_tableButton removeFromSuperview] ,_tableButton = nil;
}

- (void)updateNavigationButtons {
  
  self.navigationItem.leftBarButtonItem = [_restaurantMediator exitRestaurantButton];
  UIButton *userButton = [_restaurantMediator userProfileButton];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userButton];
  self.navigationItem.titleView = [_restaurantMediator titleView];
  
  if (_tableButtonAnimationDidShow ||
      !_restaurantMediator.showTableButton) {
    return;
  }

  _tableButtonAnimationDidShow = YES;
  OMNVisitor *visitor = _restaurantMediator.visitor;
  OMNTableButton *tableButton = [OMNTableButton buttonWithColor:visitor.restaurant.decoration.antagonist_color];
  [tableButton addTarget:_restaurantMediator action:@selector(showUserProfile) forControlEvents:UIControlEventTouchUpInside];
  [tableButton setText:_restaurantMediator.table.name];
  tableButton.center = userButton.center;
  [userButton.superview addSubview:tableButton];
  CGFloat centerX = CGRectGetWidth(userButton.superview.frame)/2.0f;
  tableButton.transform = CGAffineTransformMakeTranslation(centerX - tableButton.center.x, 0.0f);
  tableButton.alpha = 0.0f;
  _tableButton = tableButton;
  
  [UIView promiseWithDuration:0.8 delay:1.0 options:0 animations:^{
    
    tableButton.alpha = 1.0f;
    
  }].then(^{
    
    return [UIView promiseWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      
      tableButton.transform = CGAffineTransformIdentity;
      userButton.alpha = 0.0f;
      
    }];
    
  }).then(^{
    
    return [UIView promiseWithDuration:0.8 delay:2.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
      
      tableButton.alpha = 0.0f;
      userButton.alpha = 1.0f;
      
    }];
    
  }).then(^{
    
    [self removeTableButton];
    
  });
  
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
    self.circleIcon = image;
    
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
    [self setBackgroundImage:image animated:YES];
    
  }];

}

- (void)menuDidChange:(OMNMenu *)menu {

  _menuModel.menu = menu;
  [_menuTable reloadData];
  
  CGFloat topOffset = CGRectGetMaxY(self.circleButton.frame) + 40.0f;
  CGFloat bottomInset = _menuTable.frame.size.height - _menuTable.contentSize.height - topOffset;
  _menuTable.contentInset = UIEdgeInsetsMake(topOffset, 0.0f, bottomInset, 0.0f);
  [_menuTableLoader stopAnimating];
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
  
  _topGradientView = [UIImageView omn_autolayoutView];
  _topGradientView.image = [UIImage imageNamed:@"top_gradient"];
  [self.view addSubview:_topGradientView];
  
  UIImageView *gradientView = [UIImageView omn_autolayoutView];
  gradientView.image = [UIImage imageNamed:@"menu_gradient_bg"];
  [self.backgroundView addSubview:gradientView];
  
  NSMutableDictionary *views =
  [@{
     @"topGradientView" : _topGradientView,
     @"gradientView" : gradientView,
     } mutableCopy];
  
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[gradientView]|" options:kNilOptions metrics:nil views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradientView]|" options:kNilOptions metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topGradientView]|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGradientView]" options:kNilOptions metrics:nil views:views]];
  
  OMNRestaurantSettings *restaurantSettings = _restaurantMediator.restaurant.settings;
  if (restaurantSettings.has_menu) {
    
    [self addMenu];
    
  }
  else if (restaurantSettings.has_promo) {

    [self addPromo];
    
  }
  
}

- (void)addMenu {
  
  [self addMenuObserver];
  
  _menuModel = [[OMNMenuModel alloc] init];
  _menuTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _menuTable.translatesAutoresizingMaskIntoConstraints = NO;
  _menuTable.alpha = 0.0f;
  [_menuModel configureTableView:_menuTable];
  [self.view insertSubview:_menuTable belowSubview:self.circleButton];

  _menuTableLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  _menuTableLoader.translatesAutoresizingMaskIntoConstraints = NO;
  _menuTableLoader.hidesWhenStopped = YES;
  [_menuTableLoader startAnimating];
  [self.view addSubview:_menuTableLoader];
  
  NSDictionary *views =
  @{
    @"menuTableLoader" : _menuTableLoader,
    @"menuTable" : _menuTable
    };
  
  NSDictionary *metrics = @{};
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuTableLoader attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_menuTableLoader attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.circleButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:70.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuTable]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuTable]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)addMenuObserver {
  
  @weakify(self)
  _restaurantMenuOserverID = [_restaurantMediator bk_addObserverForKeyPath:NSStringFromSelector(@selector(menu)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNRestaurantMediator *obj, NSDictionary *change) {
    
    @strongify(self)
    [self menuDidChange:obj.menu];
    
  }];
}

- (void)addPromo {
  
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
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-@(OMNStyler.bottomToolbarHeight).floatValue]];
  
  [self.view layoutIfNeeded];
  
}

- (void)showMenuAtCategory:(OMNMenuCategory *)selectedMenuCategory {
  
  if (!_restaurantMediator.menu.products.count > 0) {
    return;
  }
  
  OMNMenuVC *menuVC = [[OMNMenuVC alloc] initWithMediator:_restaurantMediator selectedCategory:selectedMenuCategory];
  @weakify(self)
  menuVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.navigationController popToViewController:self animated:YES];
    
  };
  menuVC.backgroundImage = [self.backgroundView omn_screenshot];
  [self.navigationController pushViewController:menuVC animated:YES];
  
}

- (void)showRestaurantInfo {
  
  OMNRestaurantInfoVC *restaurantInfoVC = [[OMNRestaurantInfoVC alloc] initWithRestaurant:_restaurantMediator.restaurant];
  restaurantInfoVC.delegate = self;
  [self.navigationController pushViewController:restaurantInfoVC animated:YES];
  
}

- (void)beginCircleAnimationIfNeeded {

  if (_restaurantMediator.table.waiterIsCalled &&
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
