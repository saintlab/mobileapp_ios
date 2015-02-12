//
//  OMNPreorderDoneVC.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderDoneVC.h"
#import "UIView+omn_autolayout.h"
#import "UIButton+omn_helper.h"
#import <OMNStyler.h>
#import "OMNConstants.h"

@interface OMNPreorderDoneVC ()

@end

@implementation OMNPreorderDoneVC {
  
  UILabel *_textLabel;
  UILabel *_detailedTextLabel;
  UIButton *_closeButton;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self omn_setup];
  
  _textLabel.text = NSLocalizedString(@"PREORDER_DONE_LABEL_TEXT_1", @"Заказ принят\nи обрабатывается");
  _textLabel.font = FuturaLSFOmnomLERegular(25.0f);
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.textColor = colorWithHexString(@"FFFFFF");
  
  _detailedTextLabel.text = NSLocalizedString(@"PREORDER_DONE_LABEL_TEXT_2", @"Выбранные блюда скоро будут\nдобавлены официантом на ваш стол.");
  _detailedTextLabel.font = FuturaLSFOmnomLERegular(17.0f);
  _detailedTextLabel.textAlignment = NSTextAlignmentCenter;
  _detailedTextLabel.textColor = [colorWithHexString(@"FFFFFF") colorWithAlphaComponent:0.5f];
  
  [_closeButton addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (void)omn_setup {
  
  UIView *fadeView = [UIView omn_autolayoutView];
  fadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.92f];
  [self.view addSubview:fadeView];
  
  _closeButton = [UIButton omn_autolayoutView];
  [_closeButton omn_setImage:[UIImage imageNamed:@"cross_icon_white"] withColor:[UIColor whiteColor]];
  [self.view addSubview:_closeButton];
  
  _textLabel = [UILabel omn_autolayoutView];
  _textLabel.numberOfLines = 0;
  [self.view addSubview:_textLabel];
  
  _detailedTextLabel = [UILabel omn_autolayoutView];
  _detailedTextLabel.numberOfLines = 0;
  [self.view addSubview:_detailedTextLabel];
  
  NSDictionary *views =
  @{
    @"fadeView" : fadeView,
    @"closeButton" : _closeButton,
    @"detailedTextLabel" : _detailedTextLabel,
    @"textLabel" : _textLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[closeButton]-(20)-[textLabel]-[detailedTextLabel]" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[detailedTextLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  
  
}

@end
