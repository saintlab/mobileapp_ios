//
//  OMNProductModiferAlertVC.m
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNProductModiferAlertVC.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"
#import "OMNMenuProductModifersModel.h"

@interface OMNProductModiferAlertVC ()

@end

@implementation OMNProductModiferAlertVC {
  
  UILabel *_quantityLabel;
  UIButton *_minusButton;
  UIButton *_plusButton;
  UIButton *_okButton;
  UITableView *_modiferTableView;
  OMNMenuProduct *_menuProduct;
  NSInteger _quantity;
  OMNMenuProductModifersModel *_model;
  NSLayoutConstraint *_tableViewHeightConstraint;
  
}

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    _quantity = (_menuProduct.quantity > 0.0) ? (_menuProduct.quantity) : (1.0);
    _model = [[OMNMenuProductModifersModel alloc] init];
    _model.menuProduct = menuProduct;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createViews];
  [self configureViews];
 
  @weakify(self)
  _model.didSelectBlock = ^{
    
    @strongify(self)
    [self updateTableViewHeight];
    
  };
  
}

- (void)updateTableViewHeight {
  
  _tableViewHeightConstraint.constant = _model.tableViewHeight;
  [UIView animateWithDuration:0.3 animations:^{
    
    [self.view layoutIfNeeded];
    
  }];
  
}

- (void)orderTap {
  
  _menuProduct.quantity = _quantity;
  if (self.didSelectOrderBlock) {
    
    self.didSelectOrderBlock();
    
  }
  
}

- (void)updateQuantityControl {
  
  _quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)_quantity];
  _minusButton.enabled = (_quantity > 0);
  
}

- (void)plusTap {
  
  _quantity++;
  [self updateQuantityControl];
  
}

- (void)minusTap {
  
  _quantity = MAX(0, _quantity - 1);
  [self updateQuantityControl];
  
}

- (void)configureViews {
  
  _quantityLabel.font = FuturaLSFOmnomLERegular(25.0f);
  _quantityLabel.textAlignment = NSTextAlignmentCenter;
  _quantityLabel.textColor = colorWithHexString(@"000000");
  
  [_plusButton addTarget:self action:@selector(plusTap) forControlEvents:UIControlEventTouchUpInside];
  [_minusButton addTarget:self action:@selector(minusTap) forControlEvents:UIControlEventTouchUpInside];
  
  _okButton.titleLabel.font = FuturaLSFOmnomLERegular(20);
  [_okButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_okButton setTitle:kOMN_OK_BUTTON_TITLE forState:UIControlStateNormal];
  [_okButton setBackgroundImage:[[UIImage imageNamed:@"button_order"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_okButton addTarget:self action:@selector(orderTap) forControlEvents:UIControlEventTouchUpInside];
  
  [OMNMenuProductModifersModel registerCellsForTableView:_modiferTableView];
  _modiferTableView.delegate = _model;
  _modiferTableView.dataSource = _model;
  _tableViewHeightConstraint.constant = _model.tableViewHeight;
  
  [_minusButton setImage:[UIImage imageNamed:@"ic_decrease_qty"] forState:UIControlStateNormal];
  [_plusButton setImage:[UIImage imageNamed:@"ic_increase_qty"] forState:UIControlStateNormal];
  
  [self updateQuantityControl];
  
}

- (void)createViews {
  
  _okButton = [UIButton omn_autolayoutView];
  [self.contentView addSubview:_okButton];
  
  UIView *qtControlView = [UIView omn_autolayoutView];
  [self.contentView addSubview:qtControlView];
  
  _minusButton = [UIButton omn_autolayoutView];
  [qtControlView addSubview:_minusButton];
  
  _quantityLabel = [UILabel omn_autolayoutView];
  [qtControlView addSubview:_quantityLabel];

  _plusButton = [UIButton omn_autolayoutView];
  [qtControlView addSubview:_plusButton];
  
  _modiferTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _modiferTableView.translatesAutoresizingMaskIntoConstraints  = NO;
  [self.contentView addSubview:_modiferTableView];
  
  NSDictionary *views =
  @{
    @"okButton" : _okButton,
    @"qtControlView" : qtControlView,
    @"minusButton" : _minusButton,
    @"quantityLabel" : _quantityLabel,
    @"plusButton" : _plusButton,
    @"modiferTableView" : _modiferTableView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [qtControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[minusButton]-(5)-[quantityLabel(50)]-(5)-[plusButton]|" options:kNilOptions metrics:metrics views:views]];
  [qtControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[minusButton]|" options:kNilOptions metrics:metrics views:views]];
  [qtControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[quantityLabel]|" options:kNilOptions metrics:metrics views:views]];
  [qtControlView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[plusButton]|" options:kNilOptions metrics:metrics views:views]];

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[modiferTableView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:qtControlView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  _tableViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_modiferTableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
  [self.contentView addConstraint:_tableViewHeightConstraint];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_okButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[okButton(>=130)]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[qtControlView]-(leftOffset)-[modiferTableView]-(leftOffset)-[okButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
