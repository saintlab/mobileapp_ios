//
//  OMNShakeWindow.m
//  omnom
//
//  Created by tea on 06.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNShakeWindow.h"
#import <OMNStyler.h>
#import <BlocksKit+UIKit.h>

@implementation OMNShakeWindow

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  if (event.type == UIEventTypeMotion &&
      motion == UIEventSubtypeMotionShake) {
    
    [UIAlertView bk_showAlertViewWithTitle:@"reset?" message:nil cancelButtonTitle:@"No" otherButtonTitles:@[@"Yes"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
      
      if (buttonIndex != alertView.cancelButtonIndex) {
        [[OMNStyler styler] reset];
      }
      
    }];
    
  }
}


@end
