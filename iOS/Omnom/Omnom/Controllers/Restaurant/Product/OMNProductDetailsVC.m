//
//  OMNProductDetailsVC.m
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProductDetailsVC.h"
#import "OMNTransitionFromProductToList.h"
#import "OMNRestaurantMenuVC.h"
#import "OMNFeedItem.h"

@interface OMNProductDetailsVC ()
<UINavigationControllerDelegate>

@end

@implementation OMNProductDetailsVC {

  UIPercentDrivenInteractiveTransition *_interactivePopTransition;
  UILabel *_textLabel;
  UIScrollView *_scroll;
}

- (instancetype)initFeedItem:(OMNFeedItem *)feedItem {
  self = [super init];
  if (self) {
    _feedItem = feedItem;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setup];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  _imageView.image = _feedItem.image;
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  
  _textLabel.textColor = [UIColor blackColor];
  _textLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  _textLabel.text = _feedItem.Description;

  UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
  popRecognizer.edges = UIRectEdgeLeft;
  [self.view addGestureRecognizer:popRecognizer];
  
}

- (void)setup {
  
  _scroll = [[UIScrollView alloc] init];
  _scroll.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scroll];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scroll addSubview:contentView];
  
  _imageView = [[UIImageView alloc] init];
  _imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_imageView];
  
  _textLabel = [[UILabel alloc] init];
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
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:0 metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textLabel]-|" options:0 metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(250)]-[textLabel]-|" options:0 metrics:nil views:views]];
  
  NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:0
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:0];
  [self.view addConstraint:leftConstraint];
  
  NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                     attribute:NSLayoutAttributeTrailing
                                                                     relatedBy:0
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:0];
  [self.view addConstraint:rightConstraint];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
  
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
  if (fromVC == self && [toVC isKindOfClass:[OMNRestaurantMenuVC class]]) {
    return [[OMNTransitionFromProductToList alloc] init];
  }
  else {
    return nil;
  }
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
