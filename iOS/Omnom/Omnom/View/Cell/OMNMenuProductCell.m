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
  NSString *_productParentObserverID;

}

- (void)dealloc {
  
  [self removeMenuProductObservers];
  
}

- (void)removeMenuProductObservers {
  
  if (_productSelectionObserverID) {
    [_menuProductSelectionItem.menuProduct bk_removeObserversWithIdentifier:_productSelectionObserverID];
  }
  if (_productImageObserverID) {
    [_menuProductSelectionItem.menuProduct bk_removeObserversWithIdentifier:_productImageObserverID];
  }
  if (_productParentObserverID) {
    [_menuProductSelectionItem.parent bk_removeObserversWithIdentifier:_productParentObserverID];
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
  
  _menuProductView = [OMNMenuProductView omn_autolayoutView];
  [_menuProductView.priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:_menuProductView];
  
  NSDictionary *views =
  @{
    @"menuProductView" : _menuProductView,
    };
  
  NSDictionary *metrics =
  @{
    };

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuProductView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuProductView]" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setMenuProductSelectionItem:(OMNMenuProductSelectionItem *)menuProductSelectionItem {
  
  [self removeMenuProductObservers];
  
  _menuProductSelectionItem = menuProductSelectionItem;
  _menuProductView.menuProductSelectionItem = menuProductSelectionItem;

  __weak OMNMenuProductView *menuProductView = _menuProductView;
  if (_menuProductSelectionItem.parent) {
    
    _productParentObserverID = [_menuProductSelectionItem.parent bk_addObserverForKeyPath:NSStringFromSelector(@selector(selected)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) task:^(OMNMenuProductSelectionItem *parentSelectionItem, NSDictionary *change) {
      
      BOOL hideMenuProductView = !parentSelectionItem.selected;
      if (hideMenuProductView) {
        
        [UIView animateWithDuration:0.5 animations:^{
          
          menuProductView.alpha = 0.0f;
          
        } completion:^(BOOL finished) {
       
          menuProductView.hidden = YES;
          
        }];
        
      }
      else {
      
        menuProductView.hidden = NO;
        menuProductView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3 delay:0.5 options:kNilOptions animations:^{
          
          menuProductView.alpha = 1.0f;
          
        } completion:nil];
        
      }
      
    }];
    
  }
  
  _productSelectionObserverID = [_menuProductSelectionItem.menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(quantity)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {
   
    [UIView transitionWithView:menuProductView.priceButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductView.priceButton.selected = (mp.quantity > 0.0);
      
    } completion:nil];
    
  }];
  
  _productImageObserverID = [_menuProductSelectionItem.menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(photoImage)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {

    [UIView transitionWithView:menuProductView.productIV duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductView.productIV.image = mp.photoImage;
      
    } completion:nil];
    
  }];
  
  [_menuProductSelectionItem.menuProduct loadImage];
  
}

- (void)priceTap {
  
  [self.delegate menuProductCell:self didSelectProduct:_menuProductSelectionItem];
  
}

@end
