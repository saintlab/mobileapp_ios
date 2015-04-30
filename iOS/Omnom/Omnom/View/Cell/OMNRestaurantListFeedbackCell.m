//
//  OMNRestaurantListFeedbackCell.m
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantListFeedbackCell.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "OMNUtils.h"

@implementation OMNRestaurantListFeedbackCell {
  
  UILabel *_notFoundLabel;
  UIImageView *_mailIconImageView;
  
}

+ (instancetype)cellForTableView:(UITableView *)tableView {
  
  static NSString *reuseIdentifier = @"OMNRestaurantListFeedbackCell";
  OMNRestaurantListFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (nil == cell) {
    cell = [[OMNRestaurantListFeedbackCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  }
  
  return cell;
  
}

+ (CGFloat)height {
  
  return 140.0f;
  
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

- (NSMutableParagraphStyle *)centerParagraphStyle {
  
  NSMutableParagraphStyle *attributeStyle = [[NSMutableParagraphStyle alloc] init];
  attributeStyle.alignment = NSTextAlignmentCenter;
  return attributeStyle;
  
}

- (void)configureNotFoundLabel {
  
  NSMutableAttributedString *notFoundText = [[NSMutableAttributedString alloc] initWithString:kOMN_NOT_FOUND_RESTARANT_BUTTON_TEXT1 attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(18.0f) textColor:[colorWithHexString(@"000000") colorWithAlphaComponent:0.5f] textAlignment:NSTextAlignmentCenter]];
  
  NSMutableAttributedString *notFoundText1 = [[NSMutableAttributedString alloc] initWithString:kOMN_NOT_FOUND_RESTARANT_BUTTON_TEXT2 attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(18.0f) textColor:[OMNStyler blueColor] textAlignment:NSTextAlignmentCenter]];
  
  [notFoundText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
  [notFoundText appendAttributedString:notFoundText1];
  _notFoundLabel.attributedText = notFoundText;
  
}

- (void)setup {

  UIColor *color = [UIColor whiteColor];

  self.selectedBackgroundView = [[UIView alloc] init];
  self.selectedBackgroundView.opaque = YES;
  self.selectedBackgroundView.backgroundColor = color;
  
  _mailIconImageView = [[UIImageView alloc] init];
  _mailIconImageView.image = [[UIImage imageNamed:@"send_mail_icon"] omn_tintWithColor:[OMNStyler blueColor]];
  _mailIconImageView.opaque = YES;
  _mailIconImageView.backgroundColor = color;
  _mailIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_mailIconImageView];
  
  _notFoundLabel = [[UILabel alloc] init];
  _notFoundLabel.opaque = YES;
  _notFoundLabel.backgroundColor = color;
  _notFoundLabel.numberOfLines = 0;
  _notFoundLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_notFoundLabel];
  [self configureNotFoundLabel];
  
  NSDictionary *views =
  @{
    @"mailIconImageView" : _mailIconImageView,
    @"notFoundLabel" : _notFoundLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[notFoundLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[notFoundLabel]-(7)-[mailIconImageView]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_mailIconImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  
  [super setHighlighted:highlighted animated:animated];
  _mailIconImageView.alpha = (highlighted) ? (0.5f) : (1.0f);
  _notFoundLabel.alpha = (highlighted) ? (0.5f) : (1.0f);
  
}

@end
