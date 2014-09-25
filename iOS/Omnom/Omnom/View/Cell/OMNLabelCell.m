//
//  OMNLabelCell.m
//  omnom
//
//  Created by tea on 25.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLabelCell.h"
#import "OMNConstants.h"

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
  
  _label = [[UILabel alloc] init];
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  _label.textColor = [UIColor blackColor];
  _label.font = FuturaOSFOmnomRegular(18.0f);
  [self.contentView addSubview:_label];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:nil views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:nil views:views]];
  
}


@end
