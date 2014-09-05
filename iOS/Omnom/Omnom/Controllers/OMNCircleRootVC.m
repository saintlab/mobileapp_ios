//
//  OMNSearchBeaconRootVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"
#import "UILabel+numberOfLines.h"

@interface OMNCircleRootVC ()

@end

@implementation OMNCircleRootVC {
  UIView *_fadeView;
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithNibName:@"OMNCircleRootVC" bundle:nil];
  if (self) {
    _text = @"";
    self.circleBackground = parent.circleBackground;
    self.backgroundImage = parent.backgroundImage;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  if (self.circleIcon) {
    [self.circleButton setImage:self.circleIcon forState:UIControlStateNormal];
  }
  
  _fadeView = [[UIView alloc] initWithFrame:self.backgroundView.bounds];
  _fadeView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
  _fadeView.hidden = !self.faded;
  [self.backgroundView addSubview:_fadeView];
  
  self.circleBackground = _circleBackground;
  self.label.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:25.0f];
  self.label.alpha = 0.0f;

  self.text = _text;
  
}

- (void)setText:(NSString *)newText {
  _text = newText;
  
  if (NO == self.isViewLoaded) {
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
  
  [UIView animateWithDuration:0.3 animations:^{
    self.label.alpha = 1.0f;
    [self.label layoutIfNeeded];
    [self.view layoutIfNeeded];
  }];
  
}

- (void)setCircleBackground:(UIImage *)circleBackground {
  _circleBackground = circleBackground;
  [self.circleButton setBackgroundImage:self.circleBackground forState:UIControlStateNormal];
}

- (void)setCircleIcon:(UIImage *)circleIcon {
  _circleIcon = circleIcon;
  [self.circleButton setImage:circleIcon forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.text = _text;
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  
}

- (void)setFaded:(BOOL)faded {
  _faded = faded;
  _fadeView.hidden = !self.faded;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end

