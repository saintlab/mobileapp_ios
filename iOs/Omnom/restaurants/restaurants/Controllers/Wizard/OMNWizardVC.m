//
//  OMNWizardVC.m
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWizardVC.h"
#import "OMNConstants.h"

@interface OMNWizardVC ()
<UIScrollViewDelegate>

@end

@implementation OMNWizardVC {
  NSArray *_viewControllers;

  __weak IBOutlet UIPageControl *_pageControl;
  __weak IBOutlet UIScrollView *_scroll;
  
  __weak IBOutlet UIButton *_registerButton;
  __weak IBOutlet UIButton *_loginButton;
  
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
  
  UIColor *buttonBGColor = [UIColor colorWithWhite:1 alpha:0.3];
  UIColor *buttonTextColor = [UIColor whiteColor];
  UIFont *buttonFont = FuturaMediumFont(20);
  
  _loginButton.backgroundColor = buttonBGColor;
  [_loginButton setTitleColor:buttonTextColor forState:UIControlStateNormal];
  [_loginButton setTitle:NSLocalizedString(@"Вход", nil) forState:UIControlStateNormal];
  _loginButton.titleLabel.font = buttonFont;
  
  _registerButton.backgroundColor = buttonBGColor;
  [_registerButton setTitleColor:buttonTextColor forState:UIControlStateNormal];
  [_registerButton setTitle:NSLocalizedString(@"Регистрация", nil) forState:UIControlStateNormal];
  _registerButton.titleLabel.font = buttonFont;
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
  NSInteger page = floorf(offset/scrollView.frame.size.width + 0.5);
  
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
