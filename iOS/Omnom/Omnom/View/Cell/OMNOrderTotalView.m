//
//  OMNOrderTotalView.m
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderTotalView.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNUtils.h"

NSString * const OMNOrderTotalViewIdentifier = @"OMNOrderTotalViewIdentifier";

@implementation OMNOrderTotalView {
  UILabel *_totalLabel;
  UILabel *_payLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:OMNOrderTotalViewIdentifier];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.backgroundView = [[UIView alloc] init];
  self.backgroundView.backgroundColor = backgroundColor;
  
  _totalLabel = [[UILabel alloc] init];
  _totalLabel.opaque = YES;
  _totalLabel.backgroundColor = backgroundColor;
  [_totalLabel setContentHuggingPriority:751 forAxis:UILayoutConstraintAxisVertical];
  _totalLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.8f];
  _totalLabel.textAlignment = NSTextAlignmentRight;
  _totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _totalLabel.font = FuturaLSFOmnomLERegular(17.0f);
  [self addSubview:_totalLabel];
  
  _payLabel = [[UILabel alloc] init];
  _payLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _payLabel.opaque = YES;
  _payLabel.backgroundColor = backgroundColor;
  [_payLabel setContentHuggingPriority:750 forAxis:UILayoutConstraintAxisVertical];
  _payLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  _payLabel.textAlignment = NSTextAlignmentRight;
  _payLabel.font = FuturaLSFOmnomLERegular(17.0f);
  _payLabel.textAlignment = NSTextAlignmentRight;
  [self addSubview:_payLabel];
  
  NSDictionary *views =
  @{
    @"totalLabel" : _totalLabel,
    @"payLabel" : _payLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"labelHeight" : @(24.0f),
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10@751)-[totalLabel(labelHeight@751)]" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[payLabel(labelHeight@750)]-(10@751)-|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[totalLabel]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[payLabel]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  
}

- (void)setOrder:(OMNOrder *)order {
  
  _order = order;
  
  _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Итого: %@", nil), [OMNUtils commaStringFromKop:order.totalAmount]];
  if (order.paid.net_amount > 0) {
    _payLabel.hidden = NO;
    _payLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Оплачено: %@", nil), [OMNUtils commaStringFromKop:order.paid.net_amount]];
  }
  else {
    _payLabel.hidden = YES;
  }
  
}

@end
