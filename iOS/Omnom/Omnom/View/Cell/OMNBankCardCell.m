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
  UIView *_bottomLine;
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
  
  _label = [[UILabel alloc] init];
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  _label.font = FuturaLSFOmnomLERegular(15.0f);
  _label.backgroundColor = [UIColor clearColor];
  _label.textColor = [UIColor blackColor];
  [_label setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
  [self.contentView addSubview:_label];

  _iconView = [[UIImageView alloc] init];
  [_iconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
  _iconView.backgroundColor = [UIColor clearColor];
  _iconView.contentMode = UIViewContentModeRight;
  _iconView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_iconView];
  
  _bottomLine = [[UIView alloc] init];
  _bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
  _bottomLine.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];;
  [self addSubview:_bottomLine];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    @"iconView" : _iconView,
    @"bottomLine" : _bottomLine,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLine(1)]|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLine]|" options:0 metrics:metrics views:views]];
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
  
  self.backgroundView = nil;
  _iconView.image = nil;

  if (kOMNBankCardStatusHeld == bankCard.status) {
    
    masked_panColor = [UIColor colorWithWhite:0.0f alpha:0.15f];
    associationColor = [UIColor colorWithWhite:0.0f alpha:0.15f];
    
  }
  else if (selected) {
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = colorWithHexString(@"4A90E2");;
    self.backgroundView = backgroundView;

    _iconView.image = [UIImage imageNamed:@"active_card_icon"];
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
  
}


@end
