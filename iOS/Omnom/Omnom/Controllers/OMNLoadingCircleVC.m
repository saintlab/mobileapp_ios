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
#import "UINavigationController+omn_replace.h"

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
  
  UIButton *currentLogoButton = [[UIButton alloc] initWithFrame:self.circleButton.bounds];
  [currentLogoButton setImage:[self.circleButton imageForState:UIControlStateNormal] forState:UIControlStateNormal];
  [self.circleButton addSubview:currentLogoButton];
  [self.circleButton setImage:nil forState:UIControlStateNormal];
  
  UIButton *nextLogoButton = [[UIButton alloc] initWithFrame:self.circleButton.bounds];
  [nextLogoButton setImage:logo forState:UIControlStateNormal];
  nextLogoButton.alpha = 0.0f;
  [self.circleButton addSubview:nextLogoButton];
  
  NSTimeInterval circleChangeLogoAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"CircleChangeLogoAnimationDuration"];;
  NSTimeInterval circleChangeColorAnimationDuration = [[OMNStyler styler] animationDurationForKey:@"CircleChangeColorAnimationDuration"];
  
  [UIView animateWithDuration:circleChangeLogoAnimationDuration animations:^{
    
    currentLogoButton.alpha = 0.0f;
    nextLogoButton.alpha = 1.0f;
    
  } completion:^(BOOL finished) {
    
    [self.circleButton setImage:logo forState:UIControlStateNormal];
    [currentLogoButton removeFromSuperview];
    
    [UIView animateWithDuration:circleChangeColorAnimationDuration animations:^{
      
      circleIV.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      self.circleBackground = coloredCircleImage;
      [circleIV removeFromSuperview];
      [nextLogoButton removeFromSuperview];
      if (completionBlock) {
        completionBlock();
      }
    }];
    
  }];
  
}

- (void)finishLoading:(dispatch_block_t)completionBlock {
  
  if (UIApplicationStateActive == [UIApplication sharedApplication].applicationState) {
  
    [_loaderView completeAnimation:completionBlock];
    
  }
  else {

    completionBlock();
    
  }
  
}

- (void)showRetryMessageWithError:(OMNError *)error retryBlock:(dispatch_block_t)retryBlock cancelBlock:(dispatch_block_t)cancelBlock {

  OMNCircleRootVC *repeatVC = [[OMNCircleRootVC alloc] initWithParent:self];
  repeatVC.faded = YES;
  if (error) {
    
    repeatVC.text = error.localizedDescription;
    repeatVC.circleIcon = error.circleImage;
    
  }
  else {
    
    repeatVC.text = NSLocalizedString(@"NO_OMNOM_CONNECTION_ERROR_TEXT", @"Нет связи с заведением.\nОфициант в помощь.");
    repeatVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
    
  }
  
  repeatVC.didCloseBlock = cancelBlock;
  __weak typeof(self)weakSelf = self;
  repeatVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Проверить ещё") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{

      
      [weakSelf.navigationController omn_popToViewController:weakSelf animated:YES completion:^{
        
        if (retryBlock) {
          retryBlock();
        }
        
      }];

    }]
    ];
  
  [self.navigationController pushViewController:repeatVC animated:YES];
  
}


@end
