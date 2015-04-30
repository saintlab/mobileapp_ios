//
//  OMNChangeTableAlertVC.m
//  omnom
//
//  Created by tea on 16.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNChangeTableAlertVC.h"
#import <TTTAttributedLabel.h>
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "UIView+omn_autolayout.h"

@interface OMNChangeTableAlertVC ()
<TTTAttributedLabelDelegate>

@end

@implementation OMNChangeTableAlertVC {
  
  UILabel *_titleLabel;
  TTTAttributedLabel *_textLabel;
  OMNTable *_table;
}

- (instancetype)initWithTable:(OMNTable *)table {
  self = [super init];
  if (self) {
    
    _table = table;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createViews];
  [self configureViews];
  
}

- (void)configureViews {
  
  UIColor *textColor = colorWithHexString(@"737478");
  _titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  _titleLabel.textColor = textColor;
  _titleLabel.text = [NSString stringWithFormat:kOMN_RESCAN_TABLE_HOWTO_FORMAT_1, _table.internal_id];
  
  NSMutableDictionary *attributes = [OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(15.0f) textColor:textColor textAlignment:NSTextAlignmentLeft];
  
  NSString *actionText = kOMN_RESCAN_TABLE_HOWTO_ACTION_TEXT;
  NSString *text = [NSString stringWithFormat:kOMN_RESCAN_TABLE_HOWTO_FORMAT_2, actionText];
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:[attributes copy]];
  
  UIColor *linkColor = colorWithHexString(@"6BB4ED");
  attributes[(__bridge NSString *)kCTUnderlineStyleAttributeName] = @(YES);
  attributes[NSForegroundColorAttributeName] = linkColor;
  _textLabel.linkAttributes = [attributes copy];
  
  attributes[NSForegroundColorAttributeName] = [linkColor colorWithAlphaComponent:0.5];
  _textLabel.activeLinkAttributes = [attributes copy];
  
  _textLabel.text = attributedText;
  
  [_textLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[text rangeOfString:actionText]];
  
}

- (void)createViews {
  
  _titleLabel = [UILabel omn_autolayoutView];
  _titleLabel.numberOfLines = 0;
  [self.contentView addSubview:_titleLabel];
  
  _textLabel = [TTTAttributedLabel omn_autolayoutView];
  _textLabel.delegate = self;
  _textLabel.numberOfLines = 0;
  [self.contentView addSubview:_textLabel];
  
  NSDictionary *views =
  @{
    @"textLabel" : _textLabel,
    @"titleLabel" : _titleLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[titleLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  if (self.didRequestRescanBlock) {
    
    self.didRequestRescanBlock();
    
  }
  
}

@end
