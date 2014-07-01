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

@interface OMNProductDetailsVC ()
<UINavigationControllerDelegate>

@end

@implementation OMNProductDetailsVC {

  UIPercentDrivenInteractiveTransition *_interactivePopTransition;
}

- (instancetype)initWithProduct:(OMNProduct *)product {
  self = [super initWithNibName:@"OMNProductDetailsVC" bundle:nil];
  if (self) {
    _product = product;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.imageView.image = [UIImage imageNamed:_product.imageName];
  
  UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
  popRecognizer.edges = UIRectEdgeLeft;
  [self.view addGestureRecognizer:popRecognizer];
  
}

#pragma mark UIViewController methods

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // Set outself as the navigation controller's delegate so we're asked for a transitioning object
  self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  // Stop being the navigation controller's delegate
  if (self.navigationController.delegate == self) {
    self.navigationController.delegate = nil;
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
