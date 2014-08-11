//
//  OMNStopRootVC.m
//  omnom
//
//  Created by tea on 25.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"

@interface OMNBackgroundVC ()

@end

@implementation OMNBackgroundVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  _backgroundView.contentMode = UIViewContentModeBottom;
  [self.view insertSubview:_backgroundView atIndex:0];
  
  if (self.backgroundImage) {
    _backgroundView.image = self.backgroundImage;
  }
  
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
  _backgroundImage = backgroundImage;
  _backgroundView.image = self.backgroundImage;
}

- (UIButton *)bottomButton {
  UIButton *actionButton = [[UIButton alloc] init];
  actionButton.tintColor = [UIColor blackColor];
  actionButton.translatesAutoresizingMaskIntoConstraints = NO;
  actionButton.titleLabel.numberOfLines = 0;
  actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [actionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [actionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
  return actionButton;
}

- (void)addBottomButtons {
  
  _buttonsBackground = [[UIView alloc] init];
  _buttonsBackground.translatesAutoresizingMaskIntoConstraints = NO;
  _buttonsBackground.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  [self.view addSubview:_buttonsBackground];
  
  _leftBottomButton = [self bottomButton];
  _leftBottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  _leftBottomButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
  _leftBottomButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
  [_buttonsBackground addSubview:_leftBottomButton];
  
  _rightBottomButton = [self bottomButton];
  _rightBottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  _rightBottomButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 10.0f);
  _rightBottomButton.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 10.0f);
  [_buttonsBackground addSubview:_rightBottomButton];
  
  NSDictionary *views =
  @{
    @"b1": _leftBottomButton,
    @"b2": _rightBottomButton,
    @"cv": _buttonsBackground,
    };
  
  NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[b1(==b2)][b2]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
  [_buttonsBackground addConstraints:constraint_H];
  
  
  NSArray *constraint_V1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b1]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
  [_buttonsBackground addConstraints:constraint_V1];
  
  NSArray *constraint_V2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b2]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
  [_buttonsBackground addConstraints:constraint_V2];
  
  NSArray *constraint_CV_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
  [self.view addConstraints:constraint_CV_H];
  
  _bottomViewConstraint = [NSLayoutConstraint constraintWithItem:_buttonsBackground attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:50];
  [self.view addConstraint:_bottomViewConstraint];
  
  NSArray *constraint_CV_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[cv(==50)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
  [self.view addConstraints:constraint_CV_V];
  
}

@end
