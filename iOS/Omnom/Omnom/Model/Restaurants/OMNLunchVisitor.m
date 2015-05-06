//
//  OMNLunchVisitor.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchVisitor.h"
#import "OMNLunchRestaurantMediator.h"
#import "OMNLunchOrderAlertVC.h"

@implementation OMNLunchVisitor

- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC {
  return [[OMNLunchRestaurantMediator alloc] initWithVisitor:self rootViewController:rootVC];
}

- (PMKPromise *)enter:(UIViewController *)rootVC {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {

    OMNLunchOrderAlertVC *lunchOrderAlertVC = [[OMNLunchOrderAlertVC alloc] initWithRestaurant:self.restaurant];
    lunchOrderAlertVC.didCloseBlock = ^{
      
      [rootVC dismissViewControllerAnimated:YES completion:^{
        
        reject([OMNError omnomErrorFromCode:kOMNErrorCancel]);
        
      }];
      
    };
    lunchOrderAlertVC.didSelectVisitorBlock = ^(OMNVisitor *visitor) {
      
      [rootVC dismissViewControllerAnimated:YES completion:^{
        
        fulfill(visitor);
        
      }];
      
    };
    [rootVC presentViewController:lunchOrderAlertVC animated:YES completion:nil];
    
  }];
  
}

- (NSString *)tags {
  return kEntranceModeLunch;
}
- (NSString *)restarantCardButtonTitle {
  return kOMN_RESTAURANT_MODE_LUNCH_TITLE;
}
- (NSString *)restarantCardButtonIcon {
  return @"card_ic_order";
}

@end
