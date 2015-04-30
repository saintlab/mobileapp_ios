//
//  OMNUserProfileCell.m
//  omnom
//
//  Created by tea on 14.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNUserProfileCell.h"
#import "OMNUserIconView.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNAuthorization.h"
#import <BlocksKit.h>

@interface OMNUserProfileCell ()

@property (nonatomic, strong, readonly) OMNUserIconView *iconView;

@end

@implementation OMNUserProfileCell {
  
  UILabel *_userNameLabel;
  NSString *_userObserverIdentifier;
  NSString *_userImageObserverIdentifier;
  
}

- (void)omn_removeObservers {
  
  OMNAuthorization *authorisation = [OMNAuthorization authorisation];
  if (_userObserverIdentifier) {
    [authorisation bk_removeObserversWithIdentifier:_userObserverIdentifier];
  }
  if (_userImageObserverIdentifier) {
    [authorisation.user bk_removeObserversWithIdentifier:_userImageObserverIdentifier];
  }
  
}

- (void)dealloc {
  [self omn_removeObservers];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self omn_setup];
  }
  return self;
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 20.0f);
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  _iconView = [OMNUserIconView omn_autolayoutView];
  _iconView.userInteractionEnabled = NO;
  [self.contentView addSubview:_iconView];
  
  _userNameLabel = [UILabel omn_autolayoutView];
  _userNameLabel.numberOfLines = 3;
  _userNameLabel.textAlignment = NSTextAlignmentCenter;
  _userNameLabel.backgroundColor = backgroundColor;
  _userNameLabel.opaque = YES;
  _userNameLabel.textColor = colorWithHexString(@"000000");
  _userNameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self.contentView addSubview:_userNameLabel];
  
  NSDictionary *views =
  @{
    @"iconView" : _iconView,
    @"userNameLabel" : _userNameLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    @"iconViewSize" : @(120.0f),
    };
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset@999)-[userNameLabel]-(leftOffset@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(leftOffset@999)-[iconView(iconViewSize)]-(leftOffset@999)-[userNameLabel(>=82@999)]-(leftOffset@999)-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setItem:(OMNUserProfileCellItem *)item {
  _item = item;
  [self omn_addObservers];
}

- (void)omn_addObservers {
  
  OMNAuthorization *authorisation = [OMNAuthorization authorisation];
  @weakify(self)
  _userObserverIdentifier = [authorisation bk_addObserverForKeyPath:NSStringFromSelector(@selector(user)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(id obj, NSDictionary *change) {
    
    @strongify(self)
    [self updateUserInfo];
    
  }];
  _userImageObserverIdentifier = [authorisation.user bk_addObserverForKeyPath:NSStringFromSelector(@selector(image)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNUser *user, NSDictionary *change) {
    
    @strongify(self)
    [self.iconView updateWithImage:user.image];
    
  }];
  
}

- (void)updateUserInfo {
  
  OMNUser *user = [OMNAuthorization authorisation].user;
  NSString *name = (user.name.length) ? (user.name) : (@"no name");
  NSString *emailPhone = [NSString stringWithFormat:@"%@\n%@", user.email, user.phone];
  NSString *text = [NSString stringWithFormat:@"%@\n%@", name, emailPhone];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  
  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : colorWithHexString(@"000000"),
     NSFontAttributeName : FuturaOSFOmnomRegular(20.0f),
     } range:[text rangeOfString:name]];
  
  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f],
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:[text rangeOfString:emailPhone]];
  
  _userNameLabel.attributedText = attributedString;
  
}

- (void)layoutSubviews {
  
  _userNameLabel.preferredMaxLayoutWidth = MAX(0.0f, CGRectGetWidth(self.frame) - 2*OMNStyler.leftOffset);
  [super layoutSubviews];
  
}

@end
