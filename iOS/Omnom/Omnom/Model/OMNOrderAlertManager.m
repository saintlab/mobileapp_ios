//
//  OMNOrderAlertManager.m
//  omnom
//
//  Created by tea on 21.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNOrderAlertManager.h"
#import <BlocksKit+UIKit.h>

@implementation OMNOrderAlertManager {
  
  __weak UIAlertView *_updateAlertView;
  BOOL _orderIsClosed;
  
}

+ (instancetype)sharedManager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNOrderDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidClose:) name:OMNOrderDidCloseNotification object:nil];
    
  }
  return self;
}

- (void)setOrder:(OMNOrder *)order {
  
  _order = order;
  _orderIsClosed = NO;
  
}

- (void)orderDidChange:(NSNotification *)n {
  
  OMNOrder *changedOrder = n.userInfo[OMNOrderKey];
  if (!_updateAlertView &&
      [changedOrder.id isEqualToString:self.order.id] &&
      self.didUpdateBlock) {
    
    @weakify(self)
    _updateAlertView = [UIAlertView bk_showAlertViewWithTitle:kOMN_ORDER_DID_UPDATE_ALERT_TITLE message:nil cancelButtonTitle:kOMN_ORDER_UPDATE_ALERT_BUTTON_TITLE otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
      
      @strongify(self)
      if (self.didUpdateBlock) {
        
        self.didUpdateBlock();
        
      }
      
    }];
    
  }
  
}


- (void)checkOrderIsClosed {
  
  if (self.didCloseBlock &&
      _orderIsClosed) {
    
    [_updateAlertView dismissWithClickedButtonIndex:_updateAlertView.firstOtherButtonIndex animated:NO];
    _updateAlertView = nil;
    
    @weakify(self)
    [UIAlertView bk_showAlertViewWithTitle:kOMN_ORDER_DID_CLOSE_ALERT_TITLE message:nil cancelButtonTitle:kOMN_ORDER_CLOSE_ALERT_BUTTON_TITLE otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
      
      @strongify(self)
      if (self.didCloseBlock) {
        self.didCloseBlock();
      }
      
    }];
    
  }
  
}

- (void)orderDidClose:(NSNotification *)n {
  
  OMNOrder *closedOrder = n.userInfo[OMNOrderKey];
  if (![closedOrder.id isEqualToString:self.order.id]) {
    return;
  }
  
  _orderIsClosed = YES;
  [self checkOrderIsClosed];
  
}

@end
