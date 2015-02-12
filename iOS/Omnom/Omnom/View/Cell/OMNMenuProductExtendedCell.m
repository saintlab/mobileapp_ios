//
//  OMNMenuProductDetailsCell.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductExtendedCell.h"
#import "OMNMenuProductExtendedView.h"
#import <BlocksKit.h>
#import "UIView+omn_autolayout.h"

@implementation OMNMenuProductExtendedCell {
  
  NSString *_productSelectionObserverID;
  NSString *_productImageObserverID;
  OMNMenuProductExtendedView *_menuProductDetailsView;
  
}

@synthesize menuProduct=_menuProduct;

- (void)dealloc {
  
  [self removeMenuProductObservers];
  
}

- (void)removeMenuProductObservers {
  
  if (_productSelectionObserverID) {
    [_menuProduct bk_removeObserversWithIdentifier:_productSelectionObserverID];
  }
  if (_productImageObserverID) {
    [_menuProduct bk_removeObserversWithIdentifier:_productImageObserverID];
  }
  
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.contentView.clipsToBounds = YES;
  
  _menuProductDetailsView = [OMNMenuProductExtendedView omn_autolayoutView];
  [_menuProductDetailsView.priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:_menuProductDetailsView];
  
  NSDictionary *views =
  @{
    @"menuProductDetailsView" : _menuProductDetailsView,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuProductDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuProductDetailsView]" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setMenuProduct:(OMNMenuProduct *)menuProduct {
  
  [self removeMenuProductObservers];
  
  _menuProduct = menuProduct;
  _menuProductDetailsView.menuProduct = menuProduct;
  
  __weak OMNMenuProductExtendedView *menuProductDetailsView = _menuProductDetailsView;
  _productSelectionObserverID = [_menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(quantity)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {
    
    [UIView transitionWithView:menuProductDetailsView.priceButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductDetailsView.priceButton.selected = (mp.quantity > 0.0);
      
    } completion:nil];
    
  }];
  
  _productImageObserverID = [_menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(photoImage)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {
    
    [UIView transitionWithView:menuProductDetailsView.productIV duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductDetailsView.productIV.image = mp.photoImage;
      
    } completion:nil];
    
  }];
  
  [_menuProduct loadImage];
  
}

- (void)priceTap {
  
  [self.delegate menuProductCell:self editProduct:_menuProduct];
  
}

@end
