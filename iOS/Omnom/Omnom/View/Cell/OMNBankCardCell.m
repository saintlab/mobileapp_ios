//
//  OMNBankCardCell.m
//  omnom
//
//  Created by tea on 01.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardCell.h"
#import "OMNBankCard.h"
#import <OMNStyler.h>
#import <BlocksKit.h>

@implementation OMNBankCardCell {
  UILabel *_label;
  UIImageView *_iconView;
  OMNBankCard *_bankCard;
  UILabel *_cardIssuerLabel;
  NSString *_bankCardCellDeleteIdentifier;
}

- (void)removeBankCardObserver {
  
  if (_bankCardCellDeleteIdentifier) {
    [_bankCard bk_removeObserversWithIdentifier:_bankCardCellDeleteIdentifier];
    _bankCardCellDeleteIdentifier = nil;
  }
  
}

- (void)dealloc {
  
  [self removeBankCardObserver];
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self omn_setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self omn_setup];
}

- (void)omn_setup {
  
  _label = [[UILabel alloc] init];
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  _label.font = FuturaLSFOmnomLERegular(15.0f);
  _label.backgroundColor = [UIColor clearColor];
  _label.textColor = [UIColor blackColor];
  [_label setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
  [self.contentView addSubview:_label];

  _cardIssuerLabel = [[UILabel alloc] init];
  _cardIssuerLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _cardIssuerLabel.font = FuturaLSFOmnomLERegular(9.0f);
  _cardIssuerLabel.backgroundColor = [UIColor clearColor];
  _cardIssuerLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
  [_cardIssuerLabel setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
  [self.contentView addSubview:_cardIssuerLabel];

  _iconView = [[UIImageView alloc] init];
  [_iconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
  _iconView.backgroundColor = [UIColor clearColor];
  _iconView.contentMode = UIViewContentModeRight;
  _iconView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_iconView];
  
  
  NSDictionary *views =
  @{
    @"label" : _label,
    @"iconView" : _iconView,
    @"cardIssuerLabel" : _cardIssuerLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" :@(OMNStyler.leftOffset),
    @"borderOffset" : @(6.0f),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(borderOffset)-[label]-(>=0)-[cardIssuerLabel]-(borderOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]-[iconView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[cardIssuerLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
}

- (UIActivityIndicatorView *)spinner {
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  return spinner;
}

- (UILabel *)confirmButton {
  
  UILabel *label = [[UILabel alloc] init];
  label.text = kOMN_CONFIRM_BUTTON_TITLE;
  label.textColor = [OMNStyler linkColor];
  label.font = FuturaOSFOmnomRegular(15.0f);
  [label sizeToFit];
  return label;
  
}

- (void)setBankCard:(OMNBankCard *)bankCard selected:(BOOL)selected {

  [self removeBankCardObserver];
  _bankCard = bankCard;
  
  @weakify(self)
  _bankCardCellDeleteIdentifier = [_bankCard bk_addObserverForKeyPath:NSStringFromSelector(@selector(deleting)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNBankCard *bc, NSDictionary *change) {
    
    @strongify(self)
    if (bc.deleting) {
      self.accessoryView = [self spinner];
    }
    else {
      self.accessoryView = (kOMNBankCardStatusHeld == bankCard.status) ? ([self confirmButton]) : (nil);
    }
    
  }];
  
  UIColor *masked_panColor = nil;
  UIColor *associationColor = nil;
  
  self.backgroundView = nil;
  _iconView.image = nil;

  if (kOMNBankCardStatusHeld == bankCard.status) {
    
    masked_panColor = [UIColor colorWithWhite:0.0f alpha:0.15f];
    associationColor = [UIColor colorWithWhite:0.0f alpha:0.15f];
    
  }
  else if (selected) {
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [OMNStyler linkColor];
    self.backgroundView = backgroundView;

    _iconView.image = [UIImage imageNamed:@"checkbox_white"];
    masked_panColor = colorWithHexString(@"FFFFFF");
    associationColor = colorWithHexString(@"FFFFFF");
    
  }
  else {
    
    masked_panColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    associationColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    
  }

  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", bankCard.masked_pan, bankCard.association]];
  [attributedString setAttributes:@{NSForegroundColorAttributeName : masked_panColor} range:[attributedString.string rangeOfString:bankCard.masked_pan]];
  [attributedString setAttributes:@{NSForegroundColorAttributeName : associationColor} range:[attributedString.string rangeOfString:bankCard.association]];
  _label.attributedText = attributedString;
  _cardIssuerLabel.text = _bankCard.issuer;
  _cardIssuerLabel.textColor = associationColor;
  
}


@end
