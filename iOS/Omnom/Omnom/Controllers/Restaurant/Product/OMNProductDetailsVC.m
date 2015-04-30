//
//  OMNProductDetailsVC.m
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProductDetailsVC.h"
#import "OMNTransitionFromProductToList.h"
#import "OMNFeedItem.h"
#import "UIBarButtonItem+omn_custom.h"
#import <OMNStyler.h>

@interface OMNProductDetailsVC ()
<UINavigationControllerDelegate>

@end

@implementation OMNProductDetailsVC {

  UIPercentDrivenInteractiveTransition *_interactivePopTransition;
  UILabel *_textLabel;
  UIScrollView *_scroll;
}

- (void)dealloc
{
  @try {
    [_feedItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(image))];
  }
  @catch (NSException *exception) {
  }
}

- (instancetype)initFeedItem:(OMNFeedItem *)feedItem {
  self = [super init];
  if (self) {
    _feedItem = feedItem;
    [_feedItem addObserver:self forKeyPath:NSStringFromSelector(@selector(image)) options:NSKeyValueObservingOptionNew context:NULL];

  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setup];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  
  self.navigationItem.titleView = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  self.view.backgroundColor = [UIColor whiteColor];
  
  _imageView.image = _feedItem.image;
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  
  _textLabel.textColor = [UIColor blackColor];
  _textLabel.font = FuturaOSFOmnomRegular(18.0f);
  _textLabel.text = _feedItem.Description;

  UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
  popRecognizer.edges = UIRectEdgeLeft;
  [self.view addGestureRecognizer:popRecognizer];
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, OMNStyler.bottomToolbarHeight, 0.0f);
  _scroll.contentInset = insets;
  _scroll.scrollIndicatorInsets = insets;

}

- (void)closeTap {
  [self.delegate productDetailsVCDidFinish:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:NSStringFromSelector(@selector(image))]) {
    
    if (!self.isViewLoaded) {
      return;
    }
    
    _imageView.alpha = 0.0f;
    _imageView.image = _feedItem.image;
    [UIView animateWithDuration:0.3 animations:^{
      _imageView.alpha = 1.0f;
    }];
    
  }
  
}

- (void)setup {
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  _scroll = [[UIScrollView alloc] init];
  _scroll.translatesAutoresizingMaskIntoConstraints = NO;
  _scroll.opaque = YES;
  _scroll.backgroundColor = backgroundColor;
  [self.view addSubview:_scroll];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.opaque = YES;
  contentView.backgroundColor = backgroundColor;
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scroll addSubview:contentView];
  
  _imageView = [[UIImageView alloc] init];
  _imageView.opaque = YES;
  _imageView.backgroundColor = backgroundColor;
  _imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_imageView];
  
  _textLabel = [[UILabel alloc] init];
  _textLabel.opaque = YES;
  _textLabel.backgroundColor = backgroundColor;
  _textLabel.numberOfLines = 0;
  _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_textLabel];
  
  NSDictionary *views =
  @{
    @"imageView" : _imageView,
    @"textLabel" : _textLabel,
    @"contentView" : contentView,
//    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scroll,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:kNilOptions metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:kNilOptions metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:kNilOptions metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]-[textLabel]-|" options:kNilOptions metrics:nil views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:kNilOptions toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:kNilOptions toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:nil views:views]];
  
}

- (IBAction)closeTap:(id)sender {
  
  [self.delegate productDetailsVCDidFinish:self];
  
}

#pragma mark UIViewController methods

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
  // Check if we're transitioning from this view controller to a DSLFirstViewController
//  if (fromVC == self && [toVC isKindOfClass:[OMNRestaurantMenuVC class]]) {
//    return [[OMNTransitionFromProductToList alloc] init];
//  }
//  else {
    return nil;
//  }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
  // Check if this is for our custom transition
  if ([animationController isKindOfClass:[OMNTransitionFromProductToList class]]) {
    return _interactivePopTransition;
  }
  else {
    return nil;
  }
}


#pragma mark UIGestureRecognizer handlers

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
  CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
  progress = MIN(1.0, MAX(0.0, progress));
  
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    // Create a interactive transition and pop the view controller
    _interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    [self.navigationController popViewControllerAnimated:YES];
  }
  else if (recognizer.state == UIGestureRecognizerStateChanged) {
    // Update the interactive transition's progress
    [_interactivePopTransition updateInteractiveTransition:progress];
  }
  else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
    // Finish or cancel the interactive transition
    if (progress > 0.5) {
      [_interactivePopTransition finishInteractiveTransition];
    }
    else {
      [_interactivePopTransition cancelInteractiveTransition];
    }
    
    _interactivePopTransition = nil;
  }
  
}

@end
