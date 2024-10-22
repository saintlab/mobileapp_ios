//
//  OMNNavigationBarProgressView.m
//  omnom
//
//  Created by tea on 06.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNavigationBarProgressView.h"

@implementation OMNNavigationBarProgressView {
  UILabel *_label;
  UIPageControl *_pageControl;
}

- (instancetype)initWithText:(NSString *)text count:(NSInteger)count {
  self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
  if (self) {

    _label = [[UILabel alloc] init];
    _label.text = text;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
    _label.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [_label sizeToFit];
    [self addSubview:_label];
    
    _pageControl = [[UIPageControl alloc] init];
    CGFloat scale = 0.6f;
    _pageControl.transform = CGAffineTransformMakeScale(scale, scale);
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = count;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];

  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat superviewCenter = 0.5f*CGRectGetWidth(self.superview.frame);
  CGFloat centerXOffset = (superviewCenter - CGRectGetMinX(self.frame));
  _label.center = CGPointMake(centerXOffset, 17.0f);
  _pageControl.center = CGPointMake(centerXOffset, 34.0f);
}

- (void)setPage:(NSInteger)page {
  _pageControl.currentPage = page;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
