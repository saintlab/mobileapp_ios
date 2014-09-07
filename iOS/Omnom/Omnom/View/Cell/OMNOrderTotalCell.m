//
//  OMNOrderTotalCell.m
//  omnom
//
//  Created by tea on 31.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderTotalCell.h"
#import "OMNOrder.h"
#import <OMNStyler.h>
#import "OMNUtils.h"

@implementation OMNOrderTotalCell {
  UILabel *_totalLabel;
  UILabel *_payLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (void)setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleBlue;
  self.selectedBackgroundView = [[UIView alloc] init];
  
  _totalLabel = [[UILabel alloc] init];
  [_totalLabel setContentHuggingPriority:751 forAxis:UILayoutConstraintAxisVertical];
  _totalLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.8f];
  _totalLabel.textAlignment = NSTextAlignmentRight;
  _totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _totalLabel.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:17.0f];
  [self.contentView addSubview:_totalLabel];
  
  _payLabel = [[UILabel alloc] init];
  [_payLabel setContentHuggingPriority:750 forAxis:UILayoutConstraintAxisVertical];
  _payLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  _payLabel.textAlignment = NSTextAlignmentRight;
  _payLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _payLabel.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:17.0f];
  _payLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:_payLabel];
  
  NSDictionary *views =
  @{
    @"totalLabel" : _totalLabel,
    @"payLabel" : _payLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"labelHeight" : @(24.0f),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10@751)-[totalLabel(labelHeight@751)]-(2@750)-[payLabel(labelHeight@750)]-(10@751)-|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[totalLabel]-|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[payLabel]-|" options:0 metrics:metrics views:views]];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)setOrder:(OMNOrder *)order {

  _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Итого: %@", nil), [OMNUtils commaStringFromKop:order.totalAmount]];
  if (order.paid_amount > 0) {
    _payLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Оплачено: %@", nil), [OMNUtils commaStringFromKop:order.paid_amount]];
  }
  else {
    _payLabel.text = nil;
  }
}

@end
