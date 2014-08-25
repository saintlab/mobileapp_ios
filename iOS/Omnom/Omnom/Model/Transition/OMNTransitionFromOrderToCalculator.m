//
//  OMNCalculatorTransition.m
//  restaurants
//
//  Created by tea on 23.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTransitionFromOrderToCalculator.h"
#import "OMNCalculatorVC.h"
#import "OMNPayOrderVC.h"
#import "UITableView+screenshot.h"
#import "UIView+screenshot.h"

@implementation OMNTransitionFromOrderToCalculator {
  UIPercentDrivenInteractiveTransition *_interactivePopTransition;
}

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNPayOrderVC *fromViewController = (OMNPayOrderVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNCalculatorVC *toViewController = (OMNCalculatorVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  UIImage *rows1Image = [fromViewController.tableView omn_screenshotOfSection:1];
  UIImage *footerImage = [fromViewController.tableView.tableFooterView omn_screenshot];
  
  CGFloat toPayViewHeight = rows1Image.size.height;
  
  CGFloat blankImageTopOffset = fromViewController.tableView.contentSize.height - footerImage.size.height - toPayViewHeight;
  
  UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, blankImageTopOffset, rows1Image.size.width, toPayViewHeight)];
  blankView.backgroundColor = [UIColor whiteColor];
  
  UIImageView *totalView = [[UIImageView alloc] initWithImage:rows1Image];
  totalView.clipsToBounds = NO;
  [blankView addSubview:totalView];
  
  UIImageView *footerView = [[UIImageView alloc] initWithImage:footerImage];
  CGRect footerViewFrame = footerView.frame;
  footerViewFrame.origin.y = toPayViewHeight;
  footerView.frame = footerViewFrame;
  [totalView addSubview:footerView];
  
  [fromViewController.tableView addSubview:blankView];
  
  // Setup the initial view states
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];
  [toViewController.view layoutIfNeeded];
  
  CGFloat tableVisiblePart = CGRectGetHeight(fromViewController.tableView.frame) - (fromViewController.tableView.contentSize.height - fromViewController.tableView.contentOffset.y);
  
  CGPoint initialContentOffset = fromViewController.tableView.contentOffset;
  CGPoint contentOffset = initialContentOffset;
  contentOffset.y -= tableVisiblePart;
  
  [fromViewController.view bringSubviewToFront:fromViewController.tableView];
  toViewController.containerView.alpha = 0.0f;
  toViewController.view.alpha = 0.0f;
  
  CGPoint desinationEndOffset = CGPointMake(0.0f, toViewController.splitTableView.contentSize.height - CGRectGetHeight(toViewController.splitTableView.frame) + toPayViewHeight + footerImage.size.height);
  CGPoint destinationStartOffset = desinationEndOffset;
  destinationStartOffset.y += tableVisiblePart + footerImage.size.height;
  toViewController.splitTableView.contentOffset = destinationStartOffset;
  
  [UIView animateWithDuration:duration animations:^{
    // Fade out the source view controller
    toViewController.view.alpha = 1.0f;
    toViewController.containerView.alpha = 1.0f;
    // Move the image view

    toViewController.splitTableView.contentOffset = desinationEndOffset;
    fromViewController.tableView.contentOffset = contentOffset;
    
    totalView.transform = CGAffineTransformMakeTranslation(0.0f, toPayViewHeight);
    
//    snapshotView.frame = [containerView convertRect:toViewController.view.frame fromView:toViewController.view.superview];
  } completion:^(BOOL finished) {
    // Clean up
//    [snapshotView removeFromSuperview];
    [blankView removeFromSuperview];
    
    toViewController.containerView.alpha = 1.0f;
    [toViewController.splitTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    fromViewController.tableView.contentOffset = initialContentOffset;

    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 1.0;
}

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNPayOrderVC class] toClass:[OMNCalculatorVC class]]
           ];
}

@end
