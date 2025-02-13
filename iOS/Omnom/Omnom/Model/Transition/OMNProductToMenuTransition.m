//
//  OMNProductToMenuTransition.m
//  omnom
//
//  Created by tea on 01.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNProductToMenuTransition.h"
#import "OMNMenuProductVC.h"
#import "OMNMenuVC.h"

@implementation OMNProductToMenuTransition

+ (NSArray *)keys {
  
  return @[[self keyFromClass:[OMNMenuProductVC class] toClass:[OMNMenuVC class]]];
  
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  
  OMNMenuProductVC *fromViewController = (OMNMenuProductVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  OMNMenuVC *toViewController = (OMNMenuVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  OMNMenuProductFullCell *fromCell = fromViewController.rootCell;
  OMNMenuProductCell *toCell = toViewController.selectedCell;
  
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
