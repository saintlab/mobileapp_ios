//
//  OMNMenuProductCell.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductCell.h"
#import <BlocksKit.h>
#import "OMNMenuProductView.h"
#import "UIView+omn_autolayout.h"

@implementation OMNMenuProductCell {
  
  OMNMenuProductView *_menuProductView;
  NSString *_productSelectionObserverID;
  NSString *_productImageObserverID;

}

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  [_menuProductView.priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  
  _menuProductView = [OMNMenuProductView omn_autolayoutView];
  [self.contentView addSubview:_menuProductView];
  
  NSDictionary *views =
  @{
    @"menuProductView" : _menuProductView,
    };
  
  NSDictionary *metrics =
  @{
    };

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuProductView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuProductView]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setMenuProduct:(OMNMenuProduct *)menuProduct {
  
  [self removeMenuProductObservers];
  _menuProduct = menuProduct;
  _menuProductView.menuProduct = menuProduct;
  
  __weak OMNMenuProductView *menuProductView = _menuProductView;
  _productSelectionObserverID = [_menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(selected)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {
   
    [UIView transitionWithView:menuProductView.priceButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductView.priceButton.selected = mp.selected;
      
    } completion:nil];
    
  }];
  
  _productImageObserverID = [_menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(photoImage)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {

    [UIView transitionWithView:menuProductView.productIV duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductView.productIV.image = mp.photoImage;
      
    } completion:nil];
    
  }];
  
  [_menuProduct loadImage];
  
}

- (void)priceTap {
  
  [self.delegate menuProductCell:self didSelectProduct:_menuProduct];
  
}

@end
