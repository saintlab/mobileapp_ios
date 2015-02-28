//
//  OMNMenuProductCell.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductCell.h"
#import <BlocksKit.h>
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "UIImage+omn_helper.h"

@implementation OMNMenuProductCell {
  
  NSString *_productSelectionObserverID;
  NSString *_productImageObserverID;
  NSString *_productEditingObserverID;
  
}

- (void)dealloc {
  
  [self removeMenuProductObservers];
  
}

- (void)removeMenuProductObservers {
  
  if (_productSelectionObserverID) {
    [_item.menuProduct bk_removeObserversWithIdentifier:_productSelectionObserverID];
  }
  if (_productImageObserverID) {
    [_item.menuProduct bk_removeObserversWithIdentifier:_productImageObserverID];
  }
  if (_productEditingObserverID) {
    [_item.menuProduct bk_removeObserversWithIdentifier:_productEditingObserverID];
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
  self.contentView.clipsToBounds = YES;
  
  _menuProductView = [OMNMenuProductView omn_autolayoutView];
  [_menuProductView.priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:_menuProductView];
  
  
  NSDictionary *views =
  @{
    @"menuProductView" : _menuProductView,
    };

  NSDictionary *metrics = nil;

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuProductView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuProductView]" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setItem:(OMNMenuProductCellItem *)item {
  
  [self removeMenuProductObservers];
  
  _item = item;
  _menuProductView.item = item;

  __weak OMNMenuProductView *menuProductView = _menuProductView;
  _productSelectionObserverID = [_item.menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(quantity)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {
   
    [UIView transitionWithView:menuProductView.priceButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductView.priceButton.selected = mp.preordered;
      
    } completion:nil];
    
  }];

  _productEditingObserverID = [_item bk_addObserverForKeyPath:NSStringFromSelector(@selector(editing)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProductCellItem *mp, NSDictionary *change) {
    
    [UIView transitionWithView:menuProductView.priceButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductView.priceButton.omn_editing = mp.editing;
      
    } completion:nil];
    
  }];
  
  _productImageObserverID = [_item.menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(photoImage)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {

    [UIView transitionWithView:menuProductView.productIV duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      menuProductView.productIV.image = mp.photoImage;
      
    } completion:nil];
    
  }];
  
  [_item.menuProduct loadImage];
  
}

- (void)priceTap {
  
  [self.delegate menuProductCellDidEdit:self];
  
}

@end

@implementation OMNMenuProductView {
  
  UILabel *_nameLabel;
  UILabel *_descriptionLabel;
  UIView *_descriptionView;
  NSLayoutConstraint *_imageHeightConstraint;
  NSArray *_heightConstraints;
  UIView *_delimiterView;

}

@synthesize item = _item;
@synthesize priceButton = _priceButton;
@synthesize productIV = _productIV;

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.opaque = YES;
  self.backgroundColor = backgroundColor;
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.opaque = YES;
  _nameLabel.backgroundColor = backgroundColor;
  _nameLabel.numberOfLines = 0;
  _nameLabel.textAlignment = NSTextAlignmentCenter;
  _nameLabel.textColor = colorWithHexString(@"000000");
  _nameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self addSubview:_nameLabel];
  
  _priceButton = [OMNMenuProductPriceButton omn_autolayoutView];
  [self addSubview:_priceButton];
  
  _productIV = [UIImageView omn_autolayoutView];
  _productIV.backgroundColor = backgroundColor;
  _productIV.opaque = YES;
  _productIV.contentMode = UIViewContentModeScaleAspectFill;
  _productIV.clipsToBounds = YES;
  [self addSubview:_productIV];
  
  _descriptionView = [UIView omn_autolayoutView];
  [self addSubview:_descriptionView];
  
  _descriptionLabel = [UILabel omn_autolayoutView];
  [_descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
  _descriptionLabel.opaque = YES;
  _descriptionLabel.backgroundColor = backgroundColor;
  _descriptionLabel.textAlignment = NSTextAlignmentCenter;
  _descriptionLabel.textColor = colorWithHexString(@"000000");
  _descriptionLabel.numberOfLines = 0;
  _descriptionLabel.font = FuturaOSFOmnomRegular(15.0f);
  [_descriptionView addSubview:_descriptionLabel];
  
  UILabel *moreLabel = [UILabel omn_autolayoutView];
  moreLabel.opaque = YES;
  moreLabel.backgroundColor = backgroundColor;
  moreLabel.textAlignment = NSTextAlignmentCenter;
  moreLabel.textColor = [OMNStyler blueColor];
  [moreLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
  moreLabel.numberOfLines = 0;
  moreLabel.font = FuturaOSFOmnomRegular(15.0f);
  moreLabel.text = NSLocalizedString(@"ещё", @"ещё");
  [_descriptionView addSubview:moreLabel];
  
  _delimiterView = [UIView omn_autolayoutView];
  [self addSubview:_delimiterView];
  
  NSDictionary *views =
  @{
    @"descriptionView" : _descriptionView,
    @"descriptionLabel" : _descriptionLabel,
    @"moreLabel" : moreLabel,
    @"nameLabel" : _nameLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    @"delimiterView" : _delimiterView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[descriptionLabel][moreLabel]|" options:kNilOptions metrics:metrics views:views]];
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[descriptionLabel]|" options:kNilOptions metrics:metrics views:views]];
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moreLabel]|" options:kNilOptions metrics:metrics views:views]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-2*[OMNStyler styler].leftOffset.floatValue]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[productIV]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[delimiterView]|" options:kNilOptions metrics:metrics views:views]];

  _imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_productIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
  [self addConstraint:_imageHeightConstraint];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*[OMNStyler styler].leftOffset.floatValue;
  _nameLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)updateHeightConstraints {
  
  if (_heightConstraints) {
    
    [self removeConstraints:_heightConstraints];
    
  }
  
  BOOL hasPhoto = _item.menuProduct.hasPhoto;
  
  _imageHeightConstraint.constant = (hasPhoto) ? (110.0f) : (0.0f);
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    @"descriptionLabel" : _descriptionLabel,
    @"descriptionView" : _descriptionView,
    @"delimiterView" : _delimiterView,
    };
  
  OMNMenuProduct *menuProduct = _item.menuProduct;
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    @"imageOffset" : (hasPhoto) ? (@(8.0f)) : (@(0.0f)),
    @"descriptionLabelOffset" : (menuProduct.Description.length) ? (@(10.0f)) : (@(0.0f)),
    @"descriptionViewHeight" : (menuProduct.Description.length) ? (@(25.0f)) : (@(0.0f)),
    };
  
  _heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[nameLabel]-(imageOffset)-[productIV]-(descriptionLabelOffset)-[descriptionView(<=descriptionViewHeight)]-(8)-[priceButton]-(leftOffset)-[delimiterView(1)]|" options:kNilOptions metrics:metrics views:views];
  [self addConstraints:_heightConstraints];
  
}

- (void)setItem:(OMNMenuProductCellItem *)item {
  
  _item = item;
  OMNMenuProduct *menuProduct = item.menuProduct;
  _descriptionLabel.text = menuProduct.shortDescription;

  _productIV.image = menuProduct.photoImage;
  _priceButton.selected = menuProduct.preordered;
  _nameLabel.attributedText = menuProduct.nameAttributedString;

  [_priceButton setTitle:[OMNUtils moneyStringFromKop:menuProduct.price] forState:UIControlStateNormal];
  _delimiterView.backgroundColor = (kBottomDelimiterTypeNone == item.delimiterType) ? ([UIColor clearColor]) : ([UIColor colorWithWhite:0.0f alpha:0.3f]);

  [self updateHeightConstraints];
  
}

@end
