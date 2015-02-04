//
//  OMNClearButton.m
//  omnom
//
//  Created by tea on 04.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNClearButton.h"
#import "UIButton+omn_helper.h"

@implementation OMNClearButton

+ (id)omn_clearButtonWithTargett:(id)target action:(SEL)action {
  
  UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
  clearButton.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
  [clearButton omn_setImage:[UIImage imageNamed:@"clear_button_icon"] withColor:[UIColor blackColor]];
  [clearButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
  return clearButton;
  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
