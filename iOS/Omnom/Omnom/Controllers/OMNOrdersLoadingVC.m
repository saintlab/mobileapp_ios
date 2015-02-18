//
//  OMNSearchOrdersVC.m
//  omnom
//
//  Created by tea on 18.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNOrdersLoadingVC.h"
#import "OMNTable+omn_network.h"
#import "UINavigationController+omn_replace.h"

@implementation OMNOrdersLoadingVC {
  
  OMNRestaurantMediator *_restaurantMediator;

}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super initWithParent:restaurantMediator.restaurantActionsVC.r1VC];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    self.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
    self.didCloseBlock = ^{
      
      [restaurantMediator popToRootViewControllerAnimated:YES];
      
    };
    
  }
  return self;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self startLoadingOrders];
  
}

- (void)startLoadingOrders {
  
  OMNTable *table = _restaurantMediator.visitor.table;
  
  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    [weakSelf.loaderView startAnimating:10.0];
    
    [table getOrders:^(NSArray *orders) {
      
      [weakSelf finishLoading:^{
        
        [weakSelf didLoadOrders:orders];
        
      }];
      
    } error:^(OMNError *error) {
      
      [weakSelf finishLoading:^{
        
        [weakSelf showRetryMessageWithError:error retryBlock:^{
          
          [weakSelf startLoadingOrders];
          
        } cancelBlock:weakSelf.didCloseBlock];
        
      }];
      
    }];
    
  }];
  
}

- (void)didLoadOrders:(NSArray *)orders {
  
  if (self.didLoadOrdersBlock) {
    self.didLoadOrdersBlock(orders);
  }
  
}

@end
