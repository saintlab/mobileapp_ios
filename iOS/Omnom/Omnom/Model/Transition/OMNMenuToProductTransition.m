//
//  OMNMenuToProductTransition.m
//  omnom
//
//  Created by tea on 01.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuToProductTransition.h"
#import "OMNMenuVC.h"
#import "OMNMenuProductVC.h"

@implementation OMNMenuToProductTransition

+ (NSArray *)keys {
  
  return @[[self keyFromClass:[OMNMenuVC class] toClass:[OMNMenuProductVC class]]];
  
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNMenuVC *fromViewController = (OMNMenuVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNMenuProductVC *toViewController = (OMNMenuProductVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];

  OMNMenuProductCell *fromCell = fromViewController.selectedCell;
  OMNMenuProductFullCell *toCell = toViewController.rootCell;
  [toCell layoutIfNeeded];
  toCell.productIV.hidden = YES;
  fromCell.productIV.hidden = YES;
  
  UIImageView *fromIV = [[UIImageView alloc] initWithFrame:[fromCell.productIV convertRect:fromCell.productIV.bounds toView:nil]];
  fromIV.clipsToBounds = YES;
  fromIV.contentMode = fromCell.productIV.contentMode;
  fromIV.image = fromCell.item.menuProduct.photoImage;
  
  UIView *nameLabelSnapshot = [fromCell.nameLabel snapshotViewAfterScreenUpdates:NO];
  nameLabelSnapshot.frame = [fromCell.nameLabel convertRect:fromCell.nameLabel.bounds toView:nil];
  fromCell.nameLabel.hidden = YES;
  toCell.nameLabel.hidden = YES;
  
  UIView *priceButtonSnapshot = [fromCell.priceButton snapshotViewAfterScreenUpdates:NO];
  priceButtonSnapshot.frame = [fromCell.priceButton convertRect:fromCell.priceButton.bounds toView:nil];
  fromCell.priceButton.hidden = YES;
  toCell.priceButton.hidden = YES;
  
  [containerView addSubview:toViewController.view];
  [containerView addSubview:fromViewController.view];
  [containerView addSubview:priceButtonSnapshot];
  [containerView addSubview:nameLabelSnapshot];
  [containerView addSubview:fromIV];
  
  [UIView animateWithDuration:duration animations:^{
    
    fromViewController.view.alpha = 0.0f;
    fromIV.frame = [toCell.productIV convertRect:toCell.productIV.bounds toView:nil];
    priceButtonSnapshot.frame = [toCell.priceButton convertRect:toCell.priceButton.bounds toView:nil];
    nameLabelSnapshot.frame = [toCell.nameLabel convertRect:toCell.nameLabel.bounds toView:nil];
    
  } completion:^(BOOL finished) {

    toCell.productIV.hidden = NO;
    fromCell.productIV.hidden = NO;
    [fromIV removeFromSuperview];
    
    toCell.priceButton.hidden = NO;
    fromCell.priceButton.hidden = NO;
    [priceButtonSnapshot removeFromSuperview];

    fromCell.nameLabel.hidden = NO;
    toCell.nameLabel.hidden = NO;
    [nameLabelSnapshot removeFromSuperview];

    fromViewController.view.alpha = 1.0f;
    
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    
  }];
  
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  return 0.5;
  
}

@end
