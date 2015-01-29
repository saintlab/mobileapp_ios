//
//  OMNTableButton.m
//  omnom
//
//  Created by tea on 29.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNTableButton.h"
#import "OMNConstants.h"
#import "UIButton+omn_helper.h"
#import "UIImage+omn_helper.h"

@implementation OMNTableButton

+ (instancetype)buttonWithColor:(UIColor *)color {
  
  OMNTableButton *tableButton = [[OMNTableButton alloc] init];
  tableButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  
  UIColor *highlitedColor = [color colorWithAlphaComponent:0.5f];
  [tableButton setTitleColor:color forState:UIControlStateNormal];
  [tableButton setTitleColor:highlitedColor forState:UIControlStateHighlighted];
  [tableButton setImage:[[UIImage imageNamed:@"table_marker_icon"] omn_tintWithColor:color] forState:UIControlStateNormal];
  [tableButton setImage:[[UIImage imageNamed:@"table_marker_icon"] omn_tintWithColor:highlitedColor] forState:UIControlStateHighlighted];
  [tableButton omn_centerButtonAndImageWithSpacing:2.0f];
  [tableButton sizeToFit];
  return tableButton;
  
}

- (void)setText:(NSString *)text {
  
  [self setTitle:text forState:UIControlStateNormal];
  [self sizeToFit];
  
}

@end
