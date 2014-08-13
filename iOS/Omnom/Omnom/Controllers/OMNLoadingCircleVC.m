//
//  OMNLoadingCircleVC.m
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoadingCircleVC.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"

@implementation OMNLoadingCircleVC

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    _estimateAnimationDuration = 10.0;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _loaderView = [[OMNLoaderView alloc] initWithInnerFrame:self.circleButton.frame];
  _loaderView.center = CGPointMake(CGRectGetWidth(self.circleButton.frame)/2.0f, CGRectGetHeight(self.circleButton.frame)/2.0f);
  [self.circleButton addSubview:_loaderView];
  
}

- (void)setLogo:(UIImage *)logo withColor:(UIColor *)color completion:(dispatch_block_t)completionBlock {
  
  UIImage *coloredCircleImage = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:color];
  UIImageView *circleIV = [[UIImageView alloc] initWithFrame:self.circleButton.bounds];
  circleIV.contentMode = UIViewContentModeCenter;
  circleIV.alpha = 0.0f;
  circleIV.image = coloredCircleImage;
  [self.circleButton addSubview:circleIV];
  
  UIImageView *currentLogoIV = [[UIImageView alloc] initWithFrame:self.circleButton.bounds];
  currentLogoIV.contentMode = UIViewContentModeCenter;
  currentLogoIV.image = [self.circleButton imageForState:UIControlStateNormal];
  [self.circleButton addSubview:currentLogoIV];
  [self.circleButton setImage:nil forState:UIControlStateNormal];
  
  UIImageView *nextLogoIV = [[UIImageView alloc] initWithFrame:self.circleButton.bounds];
  nextLogoIV.contentMode = UIViewContentModeCenter;
  nextLogoIV.image = logo;
  nextLogoIV.alpha = 0.0f;
  [self.circleButton addSubview:nextLogoIV];
  
  NSTimeInterval circleChangeLogoAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"CircleChangeLogoAnimationDuration"];;
  NSTimeInterval circleChangeColorAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"CircleChangeColorAnimationDuration"];
  
  [UIView animateWithDuration:circleChangeLogoAnimationDuration animations:^{
    
    currentLogoIV.alpha = 0.0f;
    nextLogoIV.alpha = 1.0f;
    
  } completion:^(BOOL finished) {
    
    [self.circleButton setImage:logo forState:UIControlStateNormal];
    [currentLogoIV removeFromSuperview];
    
    [UIView animateWithDuration:circleChangeColorAnimationDuration animations:^{
      
      circleIV.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      self.circleBackground = coloredCircleImage;
      [circleIV removeFromSuperview];
      [nextLogoIV removeFromSuperview];
      if (completionBlock) {
        completionBlock();
      }
    }];
    
  }];
  
}

- (void)finishLoading:(dispatch_block_t)completionBlock {
  [_loaderView completeAnimation:completionBlock];
}


@end
