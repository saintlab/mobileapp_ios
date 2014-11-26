//
//  OMNLabelCell.m
//  omnom
//
//  Created by tea on 25.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLabelCell.h"
#import "OMNConstants.h"
#import <OMNStyler.h>

@implementation OMNLabelCell

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
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.contentView.opaque = YES;
  self.contentView.backgroundColor = backgroundColor;
  
  _label = [[UILabel alloc] init];
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  _label.opaque = YES;
  _label.backgroundColor = backgroundColor;
  [_label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
  _label.textColor = [UIColor blackColor];
  _label.font = FuturaOSFOmnomRegular(18.0f);
  [self.contentView addSubview:_label];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
  // need to use to set the preferredMaxLayoutWidth below.
  [self.contentView setNeedsLayout];
  [self.contentView layoutIfNeeded];
  
  // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
  // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
  _label.preferredMaxLayoutWidth = CGRectGetWidth(_label.frame);
}

@end
