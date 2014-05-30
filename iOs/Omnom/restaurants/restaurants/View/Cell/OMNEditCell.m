//
//  OMNEditCell.m
//  restaurants
//
//  Created by tea on 08.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEditCell.h"

@implementation OMNEditCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
  if (self) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_textField];
    self.detailTextLabel.text = @"";
    self.detailTextLabel.hidden = YES;
    
  }
  return self;
}

- (void)awakeFromNib {
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  static const CGFloat leftOffset = 110.0f;
  static const CGFloat rightOffset = 8.0f;
  
  _textField.frame = CGRectMake(leftOffset, 0, CGRectGetWidth(self.contentView.frame) - leftOffset - rightOffset, CGRectGetHeight(self.contentView.frame));

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
