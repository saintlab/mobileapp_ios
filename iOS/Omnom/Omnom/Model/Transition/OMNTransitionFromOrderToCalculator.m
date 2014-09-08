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
  
  UIImage *totalImage = [fromViewController.tableView omn_screenshotOfSection:1];
  UIImage *footerImage = [fromViewController.tableView.tableFooterView omn_screenshot];
  
  CGFloat totalViewHeight = totalImage.size.height;
  CGFloat footerViewHeight = footerImage.size.height;
  CGFloat blankImageTopOffset = fromViewController.tableView.contentSize.height - footerViewHeight - totalViewHeight;
  
  UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, blankImageTopOffset, totalImage.size.width, totalViewHeight)];
  blankView.backgroundColor = [UIColor whiteColor];
  
  UIImageView *totalView = [[UIImageView alloc] initWithImage:totalImage];
  totalView.clipsToBounds = NO;
  [blankView addSubview:totalView];
  
  UIImageView *footerView = [[UIImageView alloc] initWithImage:footerImage];
  CGRect footerViewFrame = footerView.frame;
  footerViewFrame.origin.y = totalViewHeight;
  footerView.frame = footerViewFrame;
  footerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  [blankView addSubview:footerView];
  
  toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
  [containerView addSubview:toViewController.view];
  [toViewController.view layoutIfNeeded];
  
  UIView *tableViewSnapshot = [fromViewController.tableView snapshotViewAfterScreenUpdates:NO];
  [tableViewSnapshot addSubview:blankView];
  tableViewSnapshot.frame = [fromViewController.tableView convertRect:fromViewController.tableView.bounds toView:containerView];
  [containerView insertSubview:tableViewSnapshot belowSubview:toViewController.view];
  
  fromViewController.tableView.hidden = YES;
  toViewController.splitTableView.hidden = YES;
  toViewController.view.alpha = 0.0f;
  toViewController.view.backgroundColor = [UIColor clearColor];
  
  CGPoint destinationOffset = [toViewController.splitTableView convertPoint:CGPointZero toView:containerView];
  destinationOffset.y -= CGRectGetHeight(fromViewController.tableView.tableHeaderView.frame);
  
  [UIView animateWithDuration:duration - 0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
    CGRect frame = tableViewSnapshot.frame;
    frame.origin = destinationOffset;
    tableViewSnapshot.frame = frame;
    
    CGFloat height = MAX(0.0f, toViewController.splitTableView.frame.size.height - toViewController.splitTableView.contentSize.height);
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

    toViewController.view.alpha = 1.0f;
    CGRect blankViewFrame = blankView.frame;
    blankViewFrame.size.height += height;
    blankView.frame = blankViewFrame;
    totalView.alpha = 0.0f;
    totalView.transform = CGAffineTransformMakeTranslation(0.0f, height);
    
  } completion:^(BOOL finished) {
    
    toViewController.splitTableView.hidden = NO;
    toViewController.splitTableView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
      
      toViewController.splitTableView.alpha = 1.0f;
      
    } completion:^(BOOL finished) {
      
      [tableViewSnapshot removeFromSuperview];
      [blankView removeFromSuperview];
      toViewController.view.backgroundColor = [UIColor whiteColor];
      fromViewController.tableView.hidden = NO;
      
      // Declare that we've finished
      [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
      
    }];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.8;
}

+ (NSArray *)keys {
  return @[
           [self keyFromClass:[OMNPayOrderVC class] toClass:[OMNCalculatorVC class]]
           ];
}

@end
