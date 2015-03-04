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

@interface OMNRestaurantMediator (omn_toolbar)

- (BOOL)showPreorderButton;

@end

@implementation OMNRestaurantActionsToolbar {
  
  NSString *_restaurantWaiterCallObserverId;
  BOOL _hasPreorderedMenuItems;
  
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
  _hasPreorderedMenuItems = restaurantMediator.menu.hasPreorderedItems;
  @weakify(self)
  _restaurantWaiterCallObserverId = [_restaurantMediator.visitor bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNVisitor *obj, NSDictionary *change) {
    
    @strongify(self)
    [self updateRestaurantActionButtons];
    
  }];
  
}

- (void)menuProductDidChange:(NSNotification *)n {
  
  BOOL hasPreorderedMenuItems = _restaurantMediator.menu.hasPreorderedItems;
  if (hasPreorderedMenuItems != _hasPreorderedMenuItems) {
    
    _hasPreorderedMenuItems = hasPreorderedMenuItems;
    [self updateRestaurantActionButtons];
    
  }
  
}

- (void)updateRestaurantActionButtons {
  
  OMNRestaurantSettings *settings = _restaurantMediator.restaurant.settings;
  OMNOrderToolbarButton *callBillButton = [[OMNOrderToolbarButton alloc] initWithTotalAmount:_restaurantMediator.totalOrdersAmount target:_restaurantMediator action:@selector(requestTableOrders)];
  callBillButton.hidden = !settings.has_table_order;
  
  UIButton *callWaiterButton = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"call_waiter_icon_small"] color:[UIColor blackColor] target:nil action:nil];
  @weakify(self)
  [callWaiterButton bk_addEventHandler:^(id sender) {
    
    @strongify(self)
    [self setLoadingState];
    [self.restaurantMediator waiterCall];
    
  } forControlEvents:UIControlEventTouchUpInside];
  callWaiterButton.hidden = !settings.has_waiter_call;
  
  NSArray *bottomToolbarItems = nil;
  
  if (settings.has_waiter_call &&
      _restaurantMediator.visitor.waiterIsCalled) {
    
    OMNToolbarButton *cancelWaiterButton = [[OMNToolbarButton alloc] initWithImage:nil title:NSLocalizedString(@"WAITER_CALL_CANCEL_BUTTON_TITLE", @"Отменить вызов")];
    [cancelWaiterButton bk_addEventHandler:^(id sender) {
      
      @strongify(self)
      [self setLoadingState];
      [self.restaurantMediator waiterCallStop];
      
    } forControlEvents:UIControlEventTouchUpInside];
    [cancelWaiterButton sizeToFit];
    
    bottomToolbarItems =
    @[
      [UIBarButtonItem omn_flexibleItem],
      [[UIBarButtonItem alloc] initWithCustomView:cancelWaiterButton],
      [UIBarButtonItem omn_flexibleItem],
      ];
    
  }
  else if (_restaurantMediator.showPreorderButton) {
    
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

@implementation OMNRestaurantMediator (omn_toolbar)

- (BOOL)showPreorderButton {
  
  const OMNRestaurantMode entrance_mode = self.restaurant.entrance_mode;
  BOOL showPreorderButton =
  (
   self.restaurant.settings.has_menu &&
   (self.menu.hasPreorderedItems ||
    kRestaurantMode2gis_dinner == entrance_mode ||
    kRestaurantModeBar == entrance_mode)
   );
  return showPreorderButton;
  
}

@end

