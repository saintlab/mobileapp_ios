//
//  OMNRestaurantActionsToolbar.m
//  omnom
//
//  Created by tea on 17.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantActionsToolbar.h"
#import <OMNStyler.h>
#import "OMNMyOrderButton.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNToolbarButton.h"
#import "OMNUtils.h"
#import "UIButton+omn_helper.h"
#import "OMNMyOrderButton.h"
#import <BlocksKit+UIKit.h>
#import "OMNOrderToolbarButton.h"

@implementation OMNRestaurantActionsToolbar {
  
  NSString *_restaurantWaiterCallObserverId;
  BOOL _hasSelectedMenuItems;
  
}

- (void)dealloc {

  [self removeRestaurantWaiterCallObserver];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)removeRestaurantWaiterCallObserver {
  
  if (_restaurantWaiterCallObserverId) {
    [_restaurantMediator.visitor bk_removeObserversWithIdentifier:_restaurantWaiterCallObserverId];
  }

}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    [self setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    [self setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    self.backgroundColor = [OMNStyler toolbarColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRestaurantActionButtons) name:OMNRestaurantOrdersDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuProductDidChange:) name:OMNMenuProductDidChangeNotification object:nil];
    
  }
  return self;
}

- (void)setRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator {
  
  [self removeRestaurantWaiterCallObserver];
  _restaurantMediator = restaurantMediator;
  _hasSelectedMenuItems = restaurantMediator.menu.hasSelectedItems;
  __weak typeof(self)weakSelf = self;
  _restaurantWaiterCallObserverId = [_restaurantMediator.visitor bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNVisitor *obj, NSDictionary *change) {
    
    [weakSelf updateRestaurantActionButtons];
    
  }];
  
}

- (void)menuProductDidChange:(NSNotification *)n {
  
  BOOL hasSelectedMenuItems = _restaurantMediator.menu.hasSelectedItems;
  if (hasSelectedMenuItems != _hasSelectedMenuItems) {
    
    _hasSelectedMenuItems = hasSelectedMenuItems;
    [self updateRestaurantActionButtons];
    
  }
  
}

- (void)updateRestaurantActionButtons {
  
  OMNOrderToolbarButton *callBillButton = [[OMNOrderToolbarButton alloc] initWithTotalAmount:_restaurantMediator.totalOrdersAmount target:_restaurantMediator action:@selector(requestTableOrders)];

  UIButton *callWaiterButton = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"call_waiter_icon_small"] color:[UIColor blackColor] target:nil action:nil];
  __weak typeof(self)weakSelf = self;
  [callWaiterButton bk_addEventHandler:^(id sender) {
    
    [weakSelf setLoadingState];
    [weakSelf.restaurantMediator waiterCall];
    
  } forControlEvents:UIControlEventTouchUpInside];
  OMNRestaurantSettings *settings = _restaurantMediator.restaurant.settings;
  callWaiterButton.hidden = !settings.has_waiter_call;
  NSArray *bottomToolbarItems = nil;
  
  if (settings.has_waiter_call &&
      _restaurantMediator.visitor.waiterIsCalled) {
    
    OMNToolbarButton *cancelWaiterButton = [[OMNToolbarButton alloc] initWithImage:nil title:NSLocalizedString(@"WAITER_CALL_CANCEL_BUTTON_TITLE", @"Отменить вызов")];
    [cancelWaiterButton bk_addEventHandler:^(id sender) {
      
      [weakSelf setLoadingState];
      [weakSelf.restaurantMediator waiterCallStop];
      
    } forControlEvents:UIControlEventTouchUpInside];
    [cancelWaiterButton sizeToFit];
    
    bottomToolbarItems =
    @[
      [UIBarButtonItem omn_flexibleItem],
      [[UIBarButtonItem alloc] initWithCustomView:cancelWaiterButton],
      [UIBarButtonItem omn_flexibleItem],
      ];
    
  }
  else if (settings.has_menu &&
           _restaurantMediator.menu.hasSelectedItems) {
    
    OMNMyOrderButton *myOrderButton = [[OMNMyOrderButton alloc] initWithRestaurantMediator:_restaurantMediator];
    
    bottomToolbarItems =
    @[
      [[UIBarButtonItem alloc] initWithCustomView:callWaiterButton],
      [UIBarButtonItem omn_flexibleItem],
      [[UIBarButtonItem alloc] initWithCustomView:myOrderButton],
      [UIBarButtonItem omn_flexibleItem],
      ];
    
  }
  else if (settings.has_waiter_call) {
    
    [callWaiterButton setTitle:NSLocalizedString(@"WAITER_CALL_BUTTON_TITLE", @"Официант") forState:UIControlStateNormal];
    [callWaiterButton omn_centerButtonAndImageWithSpacing:4.0f];
    [callWaiterButton sizeToFit];
    bottomToolbarItems =
    @[
      [[UIBarButtonItem alloc] initWithCustomView:callWaiterButton],
      [UIBarButtonItem omn_flexibleItem],
      [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
      ];
    
  }
  else {
    
    bottomToolbarItems =
    @[
      [UIBarButtonItem omn_flexibleItem],
      [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
      [UIBarButtonItem omn_flexibleItem],
      ];
    
  }
  
  [self setItems:bottomToolbarItems animated:YES];
  
}

- (void)setLoadingState {
  
  [self setItems:
   @[
     [UIBarButtonItem omn_flexibleItem],
     [UIBarButtonItem omn_loadingItem],
     [UIBarButtonItem omn_flexibleItem],
     ]
        animated:YES];
  
}

@end
