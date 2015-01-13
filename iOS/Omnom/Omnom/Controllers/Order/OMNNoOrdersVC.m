//
//  OMNNoOrdersVC.m
//  omnom
//
//  Created by tea on 12.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNNoOrdersVC.h"
#import <TTTAttributedLabel.h>
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"
#import "OMNUtils.h"
#import "OMNConstants.h"
#import "OMNNoOrdersAlertVC.h"

@interface OMNNoOrdersVC ()
<TTTAttributedLabelDelegate>

@end

@implementation OMNNoOrdersVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  TTTAttributedLabel *_textLabel;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super initWithParent:restaurantMediator.restaurantActionsVC.r1VC];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Ок", nil) image:nil block:^{
        
        [restaurantMediator popToRootViewControllerAnimated:YES];
        
      }]
      ];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self createViews];
  [self configureViews];
  
}

- (void)createViews {
  
  _textLabel = [TTTAttributedLabel omn_autolayoutView];
  _textLabel.delegate = self;
  _textLabel.numberOfLines = 0;
  [self.view addSubview:_textLabel];
  
  NSDictionary *views =
  @{
    @"circleButton" : self.circleButton,
    @"bottomToolbar" : self.bottomToolbar,
    @"textLabel" : _textLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.circleButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomToolbar attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)configureViews {
  
  self.faded = YES;
  self.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
  
  NSMutableDictionary *attributes = [OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(25.0f) textColor:colorWithHexString(@"000000") textAlignment:NSTextAlignmentCenter];
  
  NSString *actionText = NSLocalizedString(@"NO_ORDERS_HOWTO_ACTION_TEXT", @"Почему так может быть");
  NSString *text = [NSString stringWithFormat:NSLocalizedString(@"NO_ORDERS_HOWTO_TEXT %@ %@", @"Стол %@\nНа этом столе\nпока нет заказов.\n{NO_ORDERS_HOWTO_ACTION_TEXT}?"), _restaurantMediator.table.internal_id, actionText];
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:[attributes copy]];
  
  UIColor *linkColor = colorWithHexString(@"000000");
  attributes[(__bridge NSString *)kCTUnderlineStyleAttributeName] = @(YES);
  attributes[NSForegroundColorAttributeName] = linkColor;
  _textLabel.linkAttributes = [attributes copy];
  
  attributes[NSForegroundColorAttributeName] = [linkColor colorWithAlphaComponent:0.5];
  _textLabel.activeLinkAttributes = [attributes copy];
  
  _textLabel.text = attributedText;
  
  [_textLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[text rangeOfString:actionText]];
  
}

- (void)showChangeTableAlert {
  
  OMNNoOrdersAlertVC *noOrdersAlertVC = [[OMNNoOrdersAlertVC alloc] initWithTable:_restaurantMediator.table];
  __weak typeof(self)weakSelf = self;
  noOrdersAlertVC.didCloseBlock = ^{
    
    [weakSelf dismissViewControllerAnimated:YES completion:nil];
    
  };
  noOrdersAlertVC.didChangeTableBlock = ^{
    
    [weakSelf dismissViewControllerAnimated:YES completion:^{
      
      [weakSelf rescanTable];
      
    }];
    
  };
  [self presentViewController:noOrdersAlertVC animated:YES completion:nil];
  
}

- (void)rescanTable {
  
  [_restaurantMediator rescanTable];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  [self showChangeTableAlert];
  
}

@end
