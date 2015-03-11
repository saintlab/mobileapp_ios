//
//  OMNBarSuccessVC.m
//  omnom
//
//  Created by tea on 10.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWishSuccessVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import <TTTAttributedLabel.h>
#import "OMNUtils.h"
#import "UIImage+omn_helper.h"

@interface OMNWishSuccessVC ()
<TTTAttributedLabelDelegate>

@end

@implementation OMNWishSuccessVC {
  
  UILabel *_orderDoneLabel;
  UILabel *_orderNumberLabel;
  UILabel *_orderPinLabel;
  TTTAttributedLabel *_orderHelpLabel;
  UILabel *_orderMailLabel;
 
  UIImageView *_logoView;
  
  UIScrollView *_scroll;
  UIView *_contentView;
  
  OMNWish *_wish;
  
}

- (instancetype)initWithWish:(OMNWish *)wish {
  self = [super init];
  if (self) {
    
    _wish = wish;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  self.view.backgroundColor = [UIColor redColor];

  UIColor *titleColor = colorWithHexString(@"00881E");
  
  _logoView.image = [[UIImage imageNamed:@"bar_success"] omn_tintWithColor:titleColor];
  
  _orderDoneLabel.text = kOMN_BAR_SUCCESS_TITLE1;
  _orderDoneLabel.font = FuturaOSFOmnomRegular(30.0f);
  _orderDoneLabel.textColor = titleColor;
  
  NSMutableDictionary *attributes = [OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(16.0f) textColor:colorWithHexString(@"515753") textAlignment:NSTextAlignmentCenter];
  NSMutableAttributedString *numberText = [[NSMutableAttributedString alloc] initWithString:kOMN_BAR_SUCCESS_ORDER_NUMBER_TEXT attributes:[attributes copy]];
  attributes[NSFontAttributeName] = FuturaLSFOmnomLERegular(25.0f);
  [numberText appendAttributedString:[[NSAttributedString alloc] initWithString:@" 9999" attributes:[attributes copy]]];
  _orderNumberLabel.attributedText = numberText;
  
  attributes[NSFontAttributeName] = FuturaLSFOmnomLERegular(16.0f);
  NSMutableAttributedString *pinText = [[NSMutableAttributedString alloc] initWithString:kOMN_BAR_SUCCESS_PIN_TEXT attributes:[attributes copy]];
  attributes[NSFontAttributeName] = FuturaLSFOmnomLERegular(25.0f);
  [pinText appendAttributedString:[[NSAttributedString alloc] initWithString:@" 9991" attributes:[attributes copy]]];
  _orderPinLabel.attributedText = pinText;
  
  _orderHelpLabel.linkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : colorWithHexString(@"4A90E2"),
    NSFontAttributeName : FuturaLSFOmnomLERegular(15.0f),
    };
  _orderHelpLabel.activeLinkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : [colorWithHexString(@"4A90E2") colorWithAlphaComponent:0.5f],
    NSFontAttributeName : FuturaLSFOmnomLERegular(15.0f),
    };
  
  NSString *helpText = [NSString stringWithFormat:kOMN_BAR_SUCCESS_HELP_TEXT, kOMN_BAR_SUCCESS_HELP_ACTION_TEXT];
  _orderHelpLabel.text = [[NSAttributedString alloc] initWithString:helpText attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(15.0f) textColor:colorWithHexString(@"515753") textAlignment:NSTextAlignmentCenter]];
  [_orderHelpLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[helpText rangeOfString:kOMN_BAR_SUCCESS_HELP_ACTION_TEXT]];
  _orderHelpLabel.delegate = self;
  
  _orderHelpLabel.font = FuturaOSFOmnomRegular(20.0f);
  _orderHelpLabel.textColor = colorWithHexString(@"000000");
  
  _orderMailLabel.text = kOMN_BAR_SUCCESS_MAIL_TEXT;
  _orderMailLabel.font = FuturaLSFOmnomLERegular(20.0f);
  _orderMailLabel.textColor = colorWithHexString(@"515753");
  
  self.automaticallyAdjustsScrollViewInsets = NO;

  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithTitle:kOMN_DONE_BUTTON_TITLE color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  
}

- (void)closeTap {
  
  if (self.didFinishBlock) {
    self.didFinishBlock();
  }
  
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGSize size = _contentView.frame.size;
  size.height += 1.0f;
  _scroll.contentSize = size;
  
}

- (void)omn_setup {
  
  _scroll = [UIScrollView omn_autolayoutView];
  _scroll.clipsToBounds = NO;
  [self.view addSubview:_scroll];
  
  _contentView = [[UIView alloc] init];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  _contentView.backgroundColor = [UIColor clearColor];
  [_scroll addSubview:_contentView];
  
  UIView *whiteBGView = [UIView omn_autolayoutView];
  whiteBGView.backgroundColor = [UIColor whiteColor];
  [_contentView addSubview:whiteBGView];

  _orderDoneLabel = [UILabel omn_autolayoutView];
  _orderDoneLabel.textAlignment = NSTextAlignmentCenter;
  [_contentView addSubview:_orderDoneLabel];
  
  _orderNumberLabel = [UILabel omn_autolayoutView];
  _orderNumberLabel.textAlignment = NSTextAlignmentCenter;
  [_contentView addSubview:_orderNumberLabel];
  
  _orderPinLabel = [UILabel omn_autolayoutView];
  _orderPinLabel.textAlignment = NSTextAlignmentCenter;
  [_contentView addSubview:_orderPinLabel];
  
  _orderHelpLabel = [TTTAttributedLabel omn_autolayoutView];
  _orderHelpLabel.numberOfLines = 0;
  _orderHelpLabel.textAlignment = NSTextAlignmentCenter;
  [_contentView addSubview:_orderHelpLabel];
  
  _orderMailLabel = [UILabel omn_autolayoutView];
  _orderMailLabel.numberOfLines = 0;
  _orderMailLabel.textAlignment = NSTextAlignmentCenter;
  [_contentView addSubview:_orderMailLabel];
  
  _logoView = [UIImageView omn_autolayoutView];
  [_contentView addSubview:_logoView];
  
  UIImageView *dividerIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_divider"]];
  dividerIV.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:dividerIV];
  
  UIImageView *chequeImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"zub"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
  chequeImageView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:chequeImageView];
  
  NSDictionary *views =
  @{
    @"whiteBGView" : whiteBGView,
    @"logoView" : _logoView,
    @"dividerIV" : dividerIV,
    @"chequeImageView" : chequeImageView,
    @"contentView" : _contentView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"orderDoneLabel" : _orderDoneLabel,
    @"orderNumberLabel" : _orderNumberLabel,
    @"orderPinLabel" : _orderPinLabel,
    @"orderHelpLabel" : _orderHelpLabel,
    @"orderMailLabel" : _orderMailLabel,
    @"scroll" : _scroll,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    @"labelOffset" : @(10.0f),
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:kNilOptions metrics:metrics views:views]];

  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[whiteBGView]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[whiteBGView(2000)]" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:whiteBGView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:chequeImageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:dividerIV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderDoneLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderNumberLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderPinLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderHelpLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderMailLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chequeImageView]|" options:kNilOptions metrics:nil views:views]];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[logoView]-(20)-[orderDoneLabel]-(labelOffset)-[orderNumberLabel]-(labelOffset)-[orderPinLabel]-(20)-[orderHelpLabel]-(labelOffset)-[dividerIV]-(labelOffset)-[orderMailLabel]-(20)-[chequeImageView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:nil views:views]];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
}

@end
