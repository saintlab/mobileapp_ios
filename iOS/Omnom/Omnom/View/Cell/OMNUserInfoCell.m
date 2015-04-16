//
//  OMNUserInfoCell.m
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoCell.h"
#import "OMNConstants.h"
#import <OMNStyler.h>

@implementation OMNUserInfoCell

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
  
  _button = [[UIButton alloc] init];
  _button.translatesAutoresizingMaskIntoConstraints = NO;
  _button.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  _button.opaque = YES;
  _button.clipsToBounds = YES;
  _button.userInteractionEnabled = NO;
  _button.backgroundColor = [UIColor clearColor];
  [self.contentView addSubview:_button];
  
  UIView *downSeporator = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.frame) - 0.5f, CGRectGetWidth(self.frame), 0.5f)];
  downSeporator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
  downSeporator.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
  [self addSubview:downSeporator];
  
  NSDictionary *views =
  @{
    @"button" : _button,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    @"borderOffset" : @(6.0f),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[button]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];

}

- (void)setItem:(OMNUserInfoItem *)item {
  
  _item = item;
  self.accessoryType = item.cellAccessoryType;
  [self.button setTitle:item.title forState:UIControlStateNormal];
  self.button.contentHorizontalAlignment = item.contentHorizontalAlignment;
  [self.button setTitleColor:item.titleColor forState:UIControlStateNormal];
  
}

@end
