//
//  OMNWizardVC.m
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWizardVC.h"
#import "OMNWizardPageVC.h"

@interface OMNWizardVC ()
<UIScrollViewDelegate>

@end

@implementation OMNWizardVC {
  NSArray *_viewControllers;
  NSMutableDictionary *_imageViews;
  __weak IBOutlet UIScrollView *_scroll;
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
  self = [super initWithNibName:@"OMNWizardVC" bundle:nil];
  if (self) {
    _imageViews = [NSMutableDictionary dictionaryWithCapacity:viewControllers.count];
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
  [self scrollViewDidScroll:_scroll];
  
}

- (UIImageView *)imageViewAtPage:(NSInteger)page {
  
  UIImageView *imageView = _imageViews[@(page)];
  if (imageView) {
    return imageView;
  }
  
  imageView = [[UIImageView alloc] init];
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.backgroundView insertSubview:imageView atIndex:page];
  
  NSDictionary *views =
  @{
    @"imageView" : imageView,
    };
  
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:kNilOptions metrics:nil views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:kNilOptions metrics:nil views:views]];
  
  _imageViews[@(page)] = imageView;
  
  return imageView;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationItem setHidesBackButton:YES animated:NO];

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
  OMNWizardPageVC *wizardPageVC = _viewControllers[index];

  if (wizardPageVC.view.superview) {
    return;
  }
  
  UIImageView *iv = [self imageViewAtPage:index];
  iv.image = wizardPageVC.imageView.image;
  wizardPageVC.imageView.hidden = YES;
  
  CGRect frame = self.view.bounds;
  frame.origin.x = frame.size.width * index;
  wizardPageVC.view.frame = frame;
  [_scroll addSubview:wizardPageVC.view];
  [self addChildViewController:wizardPageVC];
  
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
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGFloat offset = scrollView.contentOffset.x;
  CGFloat pageFloat = offset/scrollView.frame.size.width;
  NSInteger currentPage = floorf(pageFloat + 0.5f);
  
  [_imageViews enumerateKeysAndObjectsUsingBlock:^(NSNumber *page, UIImageView *iv, BOOL *stop) {
    
    CGFloat p = [page floatValue];
    CGFloat alpha = MIN(MAX(0.0f, 1.0f + pageFloat - p), 1.0f);
    iv.alpha = alpha;
    
  }];
  
  if (currentPage == _pageControl.currentPage) {
    return;
  }
  
  _pageControl.currentPage = currentPage;
  
  [self loadControllerAtIndex:currentPage + 1];
  [self loadControllerAtIndex:currentPage - 1];

  if (currentPage < _viewControllers.count - 2) {
    [self unloadControllerAtIndex:currentPage + 2];
  }
  
  if (currentPage >= 2) {
    [self unloadControllerAtIndex:currentPage - 2];
  }
  
}

@end
