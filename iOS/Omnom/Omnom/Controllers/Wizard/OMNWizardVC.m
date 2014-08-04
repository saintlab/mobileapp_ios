//
//  OMNWizardVC.m
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWizardVC.h"
#import <OMNStyler.h>

@interface OMNWizardVC ()
<UIScrollViewDelegate>

@end

@implementation OMNWizardVC {
  NSArray *_viewControllers;

  __weak IBOutlet UIScrollView *_scroll;
  
//  __weak IBOutlet UIButton *_registerButton;
//  __weak IBOutlet UIButton *_loginButton;
  
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
  self = [super initWithNibName:@"OMNWizardVC" bundle:nil];
  if (self) {
    _viewControllers = viewControllers;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  _pageControl.numberOfPages = _viewControllers.count;
  _pageControl.currentPage = 0;
  
  [self loadControllerAtIndex:0];
  [self loadControllerAtIndex:1];

  
//  OMNStyle *style = [[OMNStyler styler] styleForClass:self.class];
//  UIColor *buttonsBGColor = [style colorForKey:@"buttonsBGColor"];
//  UIColor *buttonTextColor = [style colorForKey:@"buttonsTextColor"];
//  UIFont *buttonsFont = [style fontForKey:@"buttonsFont"];
//  _loginButton.backgroundColor = buttonsBGColor;
//  [_loginButton setTitleColor:buttonTextColor forState:UIControlStateNormal];
//  _loginButton.titleLabel.font = buttonsFont;
//  
//  _registerButton.backgroundColor = buttonsBGColor;
//  [_registerButton setTitleColor:buttonTextColor forState:UIControlStateNormal];
//  _registerButton.titleLabel.font = buttonsFont;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  _scroll.frame = self.view.bounds;
  CGSize size = _scroll.frame.size;
  size.width = _scroll.frame.size.width * _viewControllers.count;
  _scroll.contentSize = size;

}

- (void)loadControllerAtIndex:(NSInteger)index {
  
  if (index >= _viewControllers.count) {
    return;
  }
  UIViewController *vc = _viewControllers[index];

  if (vc.view.superview) {
    return;
  }
  
  CGRect frame = self.view.bounds;
  frame.origin.x = frame.size.width * index;
  vc.view.frame = frame;
  [_scroll addSubview:vc.view];
  [self addChildViewController:vc];
  
}

- (void)unloadControllerAtIndex:(NSInteger)index {
  
  if (index >= _viewControllers.count) {
    return;
  }
  
  UIViewController *vc = _viewControllers[index];
  if (nil == vc.view.superview) {
    return;
  }
  
  [vc willMoveToParentViewController:nil];
  [vc removeFromParentViewController];
  [vc.view removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGFloat offset = scrollView.contentOffset.x;
  CGFloat pageFloat = offset/scrollView.frame.size.width;
  NSInteger page = floorf(pageFloat + 0.5f);
  
  [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
    
    if (pageFloat > idx) {
      vc.view.alpha = MAX(0, 1.0f - pageFloat + idx);
    }
    else {
      vc.view.alpha = MAX(0, 1.0f + pageFloat - idx);
    }
    
  }];
  
  if (page == _pageControl.currentPage) {
    return;
  }
  
  _pageControl.currentPage = page;
  
  [self loadControllerAtIndex:page + 1];
  [self loadControllerAtIndex:page - 1];

  if (page < _viewControllers.count - 2) {
    [self unloadControllerAtIndex:page + 2];
  }
  
  if (page >= 2) {
    [self unloadControllerAtIndex:page - 2];
  }
  
}

@end
