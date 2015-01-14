//
//  OMNNoOrdersAlertVC.m
//  omnom
//
//  Created by tea on 12.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNNoOrdersAlertVC.h"
#import <TTTAttributedLabel.h>
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "OMNConstants.h"
#import "UIView+omn_autolayout.h"

@interface OMNNoOrdersAlertVC ()
<TTTAttributedLabelDelegate>

@end

@implementation OMNNoOrdersAlertVC {
  
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
  
  NSMutableDictionary *attributes = [OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(15.0f) textColor:colorWithHexString(@"737478") textAlignment:NSTextAlignmentLeft];
  
  NSString *actionText = NSLocalizedString(@"CHANGE_TABLE_HOWTO_ACTION_TEXT", @"измените номер своего стола");
  NSString *text = [NSString stringWithFormat:NSLocalizedString(@"CHANGE_TABLE_HOWTO_TEXT %@ %@",   @"Омном отображает все заказы в соответствии с номером стола в ресторане.\nСейчас на %@ столе открытых заказов нет.\n\nЕсли вы уже сделали заказ, но его ещё не видно, то, вероятно, официант ещё не успел внести его в систему. Дайте ему пару минут.\nЕсли заказ по-прежнему не виден, уточните у официанта, на какой стол заказ записан.\n\nЕсли нужно, {CHANGE_TABLE_HOWTO_ACTION_TEXT}."), _table.internal_id, actionText];
  
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
  
  _textLabel = [TTTAttributedLabel omn_autolayoutView];
  _textLabel.delegate = self;
  _textLabel.numberOfLines = 0;
  [self.contentView addSubview:_textLabel];
  
  NSDictionary *views =
  @{
    @"textLabel" : _textLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  if (self.didChangeTableBlock) {
    
    self.didChangeTableBlock();
    
  }
  
}

@end
