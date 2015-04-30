//
//  OMNSearchBeaconRootVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"
#import "UILabel+numberOfLines.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UINavigationBar+omn_custom.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>

@interface OMNCircleRootVC ()

@property (nonatomic, strong) UIView *fadeView;

@end

@implementation OMNCircleRootVC

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super init];
  if (self) {
    _text = @"";
    _circleBackground = parent.circleBackground;
    self.backgroundImage = parent.backgroundImage;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self setupCircle];
  
  if (self.circleIcon) {
    self.circleIcon = _circleIcon;
  }
  
  if (self.faded) {
    self.fadeView.hidden = NO;
  }
  
  self.circleBackground = _circleBackground;
  self.label.alpha = 0.0f;
  self.text = _text;
  [self.view layoutIfNeeded];
  
}

- (UIView *)fadeView {
  
  if (_fadeView) {
    return _fadeView;
  }
  
  _fadeView = [UIView omn_autolayoutView];
  _fadeView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
  _fadeView.hidden = !self.faded;
  [self.backgroundView addSubview:_fadeView];
  
  NSDictionary *views =
  @{
    @"fadeView" : _fadeView,
    };
  
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:kNilOptions metrics:nil views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fadeView]|" options:kNilOptions metrics:nil views:views]];
  
  return _fadeView;
}

- (void)setupCircle {
  
  _label = [UILabel omn_autolayoutView];
  _label.hidden = YES;
  _label.font = FuturaOSFOmnomRegular(25.0f);
  _label.numberOfLines = 0;
  [self.view addSubview:_label];
  
  _circleButton = [UIButton omn_autolayoutView];
  _circleButton.userInteractionEnabled = NO;
  [self.view addSubview:_circleButton];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    @"circleButton" : _circleButton,
    };
  
  NSDictionary *metrics =
  @{
    @"circleSize" : @(200.0f),
    @"bottomOffset" : @(OMNStyler.bottomToolbarHeight),
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[circleButton(circleSize)]-[label]-(bottomOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[circleButton(circleSize)]" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=20)-[label]-(>=20)-|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_circleButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_circleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.35f constant:0.0f]];

}

- (void)setText:(NSString *)newText {
  _text = newText;
  
  if (!self.isViewLoaded) {
    return;
  }
  
  NSString *text = (self.text) ? (self.text) : @"";
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.lineSpacing = 0.0f;
  style.maximumLineHeight = 25.0f;
  [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
  
  self.label.attributedText = attributedText;
  if ([self.label omn_linesCount] > 3) {
    self.label.textAlignment = NSTextAlignmentLeft;
  }
  else {
    self.label.textAlignment = NSTextAlignmentCenter;
  }
  self.label.textColor = [UIColor blackColor];
  self.label.hidden = NO;
  [UIView animateWithDuration:0.3 animations:^{
    self.label.alpha = 1.0f;
  }];
  
}

- (void)setCircleBackground:(UIImage *)circleBackground {
  _circleBackground = circleBackground;
  if (self.isViewLoaded) {
    [self.circleButton setBackgroundImage:self.circleBackground forState:UIControlStateNormal];
  }
  
}

- (void)setCircleIcon:(UIImage *)circleIcon {
  _circleIcon = circleIcon;
  if (self.isViewLoaded) {
    [self.circleButton setImage:circleIcon forState:UIControlStateNormal];
  }
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.text = _text;
  
  if (self.didCloseBlock) {
    
    self.navigationItem.titleView = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeBlockAction)];
    
  }
  else {
    
    self.navigationItem.titleView = nil;
    
  }
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  [self.navigationController.navigationBar omn_setTransparentBackground];

}

- (void)closeBlockAction {
  
  self.didCloseBlock();
  
}

- (void)setFaded:(BOOL)faded {
  _faded = faded;
  if (self.isViewLoaded) {
    self.fadeView.hidden = !self.faded;
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end

