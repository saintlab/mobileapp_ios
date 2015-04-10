//
//  OMNMoneyQuestionVC.m
//  omnom
//
//  Created by tea on 10.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMoneyQuestionVC.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"

@implementation OMNMoneyQuestionVC {
  
  UILabel *_textLabel;
  UILabel *_detailedTextLabel;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
  _textLabel.text = kOMN_MONEY_QUESTION_TEXT;
  _detailedTextLabel.text = kOMN_MONEY_QUESTION_DETAILED_TEXT;
  
}

- (UILabel *)textLabel {
  
  UILabel *textLabel = [UILabel omn_autolayoutView];
  textLabel.textColor = [OMNStyler greyColor];
  textLabel.opaque = YES;
  textLabel.numberOfLines = 0;
  textLabel.textAlignment = NSTextAlignmentCenter;
  return textLabel;
  
}

- (void)setup {
  
  UIColor *backgroundColor = [UIColor whiteColor];
  _textLabel = [self textLabel];
  _textLabel.backgroundColor = backgroundColor;
  _textLabel.font = FuturaOSFOmnomRegular(25.0f);
  [self.contentView addSubview:_textLabel];
  
  _detailedTextLabel = [self textLabel];
  _detailedTextLabel.backgroundColor = backgroundColor;
  _detailedTextLabel.font = FuturaOSFOmnomRegular(15.0f);
  [self.contentView addSubview:_detailedTextLabel];

  NSDictionary *views =
  @{
    @"textLabel" : _textLabel,
    @"detailedTextLabel" : _detailedTextLabel,
    @"contentView" : self.contentView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[detailedTextLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textLabel]-[detailedTextLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
