//
//  OMNBankCardCell.m
//  omnom
//
//  Created by tea on 01.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardCell.h"
#import "OMNBankCard.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import <BlocksKit.h>

NSString * const OMNBankCardCellDeleteIdentifier = @"OMNBankCardCellDeleteIdentifier";

@implementation OMNBankCardCell {
  UILabel *_label;
  UIImageView *_iconView;
  OMNBankCard *_bankCard;
}

- (void)dealloc {
  [_bankCard bk_removeObserversWithIdentifier:OMNBankCardCellDeleteIdentifier];
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
  
  UIColor *backgroundColor = [UIColor whiteColor];
  self.contentView.opaque = YES;
  self.contentView.backgroundColor = backgroundColor;
  
  _label = [[UILabel alloc] init];
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  _label.font = FuturaLSFOmnomLERegular(15.0f);
  _label.opaque = YES;
  _label.backgroundColor = backgroundColor;
  _label.textColor = [UIColor blackColor];
  [_label setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
  [self.contentView addSubview:_label];

  _iconView = [[UIImageView alloc] init];
  _iconView.opaque = YES;
  [_iconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
  _iconView.backgroundColor = backgroundColor;
  _iconView.contentMode = UIViewContentModeRight;
  _iconView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_iconView];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    @"iconView" : _iconView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconView]|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]-[iconView]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  
  
}

- (UIActivityIndicatorView *)spinner {
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  return spinner;
}

- (UILabel *)confirmButton {
  
  UILabel *label = [[UILabel alloc] init];
  label.text = NSLocalizedString(@"CARD_CONFIRM_BUTTON_TITLE", @"Подтвердить");
  label.textColor = colorWithHexString(@"4A90E2");
  label.font = FuturaOSFOmnomRegular(15.0f);
  [label sizeToFit];
  return label;
  
}

- (void)setBankCard:(OMNBankCard *)bankCard selected:(BOOL)selected {

  [_bankCard bk_removeObserversWithIdentifier:OMNBankCardCellDeleteIdentifier];
  _bankCard = bankCard;
  __weak typeof(self)weakSelf = self;

  [_bankCard bk_addObserverForKeyPath:NSStringFromSelector(@selector(deleting)) identifier:OMNBankCardCellDeleteIdentifier options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial task:^(OMNBankCard *bc, NSDictionary *change) {
    
    if (bc.deleting) {
      weakSelf.accessoryView = [weakSelf spinner];
    }
    else {
      weakSelf.accessoryView = (kOMNBankCardStatusHeld == bankCard.status) ? ([weakSelf confirmButton]) : (nil);
    }
    
  }];
  
  UIColor *masked_panColor = nil;
  UIColor *associationColor = nil;
  
  if (selected) {
    _iconView.image = [UIImage imageNamed:@"selected_card_icon_blue"];
    masked_panColor = colorWithHexString(@"4A90E2");
    associationColor = [colorWithHexString(@"4A90E2") colorWithAlphaComponent:0.5f];
  }
  else {
    masked_panColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    associationColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _iconView.image = nil;
  }

  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", bankCard.masked_pan, bankCard.association]];
  [attributedString setAttributes:@{NSForegroundColorAttributeName : masked_panColor} range:[attributedString.string rangeOfString:bankCard.masked_pan]];
  [attributedString setAttributes:@{NSForegroundColorAttributeName : associationColor} range:[attributedString.string rangeOfString:bankCard.association]];
  _label.attributedText = attributedString;
  
}


@end
