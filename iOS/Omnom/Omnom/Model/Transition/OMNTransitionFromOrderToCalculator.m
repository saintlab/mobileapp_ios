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
  CGFloat footerViewHeight = footerImage.size.height;
  CGFloat blankImageTopOffset = fromViewController.tableView.contentSize.height - footerViewHeight - toPayViewHeight;
  
  UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, blankImageTopOffset, rows1Image.size.width, toPayViewHeight)];
  blankView.backgroundColor = [UIColor whiteColor];
  
  UIImageView *totalView = [[UIImageView alloc] initWithImage:rows1Image];
  totalView.clipsToBounds = NO;
  [blankView addSubview:totalView];
  
  UIImageView *footerView = [[UIImageView alloc] initWithImage:footerImage];
  CGRect footerViewFrame = footerView.frame;
  footerViewFrame.origin.y = toPayViewHeight;
  footerView.frame = footerViewFrame;
  footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [blankView addSubview:footerView];
  
  [fromViewController.tableView addSubview:blankView];
  
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];
  [toViewController.view layoutIfNeeded];
  
  CGFloat maxVisibleHeight = fromViewController.tableView.contentSize.height - CGRectGetHeight(fromViewController.tableView.tableHeaderView.frame) - toPayViewHeight - footerViewHeight;
  CGFloat currentVisibleHeight = fromViewController.tableView.contentSize.height - fromViewController.tableView.contentOffset.y;
  
  CGFloat tableVisiblePart = CGRectGetHeight(fromViewController.tableView.frame) - MIN(currentVisibleHeight, maxVisibleHeight);
  
  CGPoint initialContentOffset = fromViewController.tableView.contentOffset;
  CGPoint contentOffset = initialContentOffset;
  contentOffset.y -= tableVisiblePart;

  [fromViewController.view bringSubviewToFront:fromViewController.tableView];
  toViewController.containerView.alpha = 0.0f;
  toViewController.view.alpha = 0.0f;
  
  CGFloat destinationStartOffset = fromViewController.tableView.contentOffset.y - CGRectGetHeight(fromViewController.tableView.tableHeaderView.frame) + kCalculatorTopOffset;
  toViewController.splitTableView.contentOffset = CGPointMake(0.0f, destinationStartOffset);
  
  [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
    // Fade out the source view controller
    toViewController.view.alpha = 1.0f;
    toViewController.containerView.alpha = 1.0f;
    // Move the image view
    
    toViewController.splitTableView.contentOffset = CGPointMake(0.0f, 0.0f);
    fromViewController.tableView.contentOffset = CGPointMake(0.0f, CGRectGetHeight(fromViewController.tableView.tableHeaderView.frame) - kCalculatorTopOffset);
    
    CGFloat height = MAX(0.0f, toViewController.splitTableView.frame.size.height - toViewController.splitTableView.contentSize.height);
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    CGRect blankViewFrame = blankView.frame;
    blankViewFrame.size.height += height;
    blankView.frame = blankViewFrame;
    totalView.transform = CGAffineTransformMakeTranslation(0.0f, height);
    
  } completion:^(BOOL finished) {
    
    [blankView removeFromSuperview];
    
    toViewController.containerView.alpha = 1.0f;
    [toViewController.splitTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    fromViewController.tableView.contentOffset = initialContentOffset;
    
    // Declare that we've finished
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 10.5;
}

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNPayOrderVC class] toClass:[OMNCalculatorVC class]]
           ];
}

@end
