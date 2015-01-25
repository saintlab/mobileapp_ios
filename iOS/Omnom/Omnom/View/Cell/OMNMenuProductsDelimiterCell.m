//
//  OMNMenuProductsDelimiterCell.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductsDelimiterCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"

@implementation OMNMenuProductsDelimiterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.backgroundView = [[UIView alloc] init];
  self.backgroundView.backgroundColor = [UIColor clearColor];
  self.backgroundColor = [UIColor clearColor];
  
  UIColor *lineColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.2f];
  UIView *line = [UIView omn_autolayoutView];
  line.backgroundColor = lineColor;
  [self.contentView addSubview:line];

  NSDictionary *views =
  @{
    @"line" : line,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[line(1)]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[line]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
