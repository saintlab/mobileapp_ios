//
//  OMNMailRUPayVC.m
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRUPayVC.h"
#import "OMNBankCardInfo.h"
#import <OMNMailRuAcquiring.h>
#import <OMNDeletedTextField.h>
#import "OMNOrder+network.h"
#import "OMNMailRuBankCardsModel.h"
#import "OMNCardBrandView.h"
#import "OMNAddBankCardVC.h"
#import <OMNStyler.h>
#import "OMNMailRUCardConfirmVC.h"
#import "OMNOrder+omn_mailru.h"
#import "OMNAuthorisation.h"
#import "OMNSocketManager.h"
#import "OMNLoadingCircleVC.h"
#import "UINavigationController+omn_replace.h"
#import "UIImage+omn_helper.h"

@interface OMNMailRUPayVC()
<OMNAddBankCardVCDelegate,
OMNMailRUCardConfirmVCDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;

@end

@implementation OMNMailRUPayVC {

  UILabel *_errorLabel;
  
  UILabel *_offerLabel;
  UIButton *_payButton;
  UIView *_bottomView;
  
  OMNOrder *_order;
  OMNBill *_bill;
  OMNBankCardsModel *_bankCardsModel;
  UIView *_contentView;
  OMNLoadingCircleVC *_loadingCircleVC;
  
  BOOL _addBankCardRequested;
}

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPayNotification:) name:OMNSocketIODidPayNotification object:nil];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Добавить карту", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addCardTap)];
  [self setup];
  
  if (self.demo) {
    _bankCardsModel = [[OMNBankCardsModel alloc] init];
  }
  else {
    _bankCardsModel = [[OMNMailRuBankCardsModel alloc] init];
  }
  
//  __weak typeof(self)weakSelf = self;
  [_bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
//    [weakSelf.delegate bankCardsVC:weakSelf didSelectCard:bankCard];
    
  }];
  
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
  [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  _errorLabel.text = nil;
  _offerLabel.text = nil;
  _offerLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  
  [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_payButton setTitle:NSLocalizedString(@"Оплатить", nil) forState:UIControlStateNormal];
  [_payButton sizeToFit];
  [_payButton addTarget:self action:@selector(payTap:) forControlEvents:UIControlEventTouchUpInside];
  _payButton.enabled = NO;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel loadCardsWithCompletion:^{
    
    [weakSelf didLoadCards];
    
  }];
  
}

- (void)didLoadCards {
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
  if (_bankCardsModel.cards.count) {
    _payButton.enabled = YES;
  }
  else if (NO ==_addBankCardRequested){
    _addBankCardRequested = YES;
    [self addCardTap];
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  _errorLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame);
  _offerLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame);
  
  [_contentView layoutIfNeeded];
  
  CGSize size = [_contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  UIView *tableFooterView = self.tableView.tableFooterView;
  CGRect frame = self.tableView.tableFooterView.frame;
  frame.size = size;
  tableFooterView.frame = frame;
  self.tableView.tableFooterView = tableFooterView;
  
  UIEdgeInsets insets = self.tableView.contentInset;
  insets.bottom = CGRectGetHeight(_contentView.frame);
  self.tableView.contentInset = insets;
  
  [self.view layoutIfNeeded];
  
}

- (void)payTap:(UIButton *)button {
  
  button.enabled = NO;
  
  if (self.demo) {
    [self demoPay];
  }
  else {
    _loadingCircleVC = [[OMNLoadingCircleVC alloc] initWithParent:nil];
    _loadingCircleVC.circleIcon = [UIImage imageNamed:@"flying_credit_card_icon"];
    _loadingCircleVC.estimateAnimationDuration = 10.0;
    UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"000000")];
    _loadingCircleVC.circleBackground = circleBackground;
    __weak typeof(self)weakSelf = self;
    [self.navigationController omn_pushViewController:_loadingCircleVC animated:YES completion:^{
      [weakSelf createOrderPaymentInfo];
    }];
  }
  
}

- (void)createOrderPaymentInfo {
  
  [_loadingCircleVC.loaderView setLoaderColor:[UIColor colorWithWhite:0.0f alpha:0.1f]];
  [_loadingCircleVC.loaderView startAnimating:10.0];

  OMNBankCard *bankCard = [_bankCardsModel selectedCard];
  OMNMailRuCardInfo *cardInfo = [OMNMailRuCardInfo cardInfoWithCardId:bankCard.external_card_id];
  
  __weak typeof(self)weakSelf = self;
  [_order getPaymentInfoForUser:[OMNAuthorisation authorisation].user cardInfo:cardInfo copmletion:^(OMNMailRuPaymentInfo *paymentInfo) {
    
    [weakSelf orderPaymentInfoDidCreated:paymentInfo];
    
  } failure:^(NSError *error) {
    
    [weakSelf didFailCreateOrderWithError:error];
    
  }];
  
}

- (void)orderPaymentInfoDidCreated:(OMNMailRuPaymentInfo *)paymentInfo {
  
  __weak typeof(self)weakSelf = self;
  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
    
    [weakSelf paymentInfo:paymentInfo didPayWithResponse:response];
    
  }];

}

- (void)didFailCreateOrderWithError:(NSError *)error {
  [self.navigationController popToViewController:self animated:YES];
  _errorLabel.text = error.localizedDescription;
}

- (void)didPayNotification:(NSNotification *)n {
  NSLog(@"didPayNotification>%@", n);
}

- (void)paymentInfo:(OMNMailRuPaymentInfo *)paymentInfo didPayWithResponse:(id)response {
  
  __weak typeof(self)weakSelf = self;
  [_loadingCircleVC finishLoading:^{
    
    NSString *status = response[@"status"];
    NSString *order_status = response[@"order_status"];
    if ([status isEqualToString:@"OK_FINISH"] &&
        [order_status isEqualToString:@"PAID"]) {

      [weakSelf mailRuDidFinish];
      
    }
    else {
      
      [weakSelf mailRuDidFail];
      
    }

  }];
  
}

- (void)mailRuDidFinish {

  [_order logPayment];
  [self.delegate mailRUPayVCDidFinish:self];
  
}

- (void)mailRuDidFail {
  
  [_loadingCircleVC setText:NSLocalizedString(@"Ваш банк отклонил платёж.\nПовторите попытку,\nдобавьте другую карту\nили оплатите наличными.", nil)];
  __weak typeof(self)weakSelf = self;
  _loadingCircleVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Ок", nil) image:nil block:^{
      
      [weakSelf cancelTap];
      
    }]
    ];
  [_loadingCircleVC updateActionBoard];
  _loadingCircleVC.bottomViewConstraint.constant = 0.0f;
  [_loadingCircleVC.view layoutIfNeeded];
  
}

- (void)demoPay {
  
  [self.delegate mailRUPayVCDidFinish:self];
  
}

- (void)cancelTap {
  
  [self.delegate mailRUPayVCDidCancel:self];
  
}

- (void)addCardTap {
  
  OMNAddBankCardVC *addBankCardVC = [[OMNAddBankCardVC alloc] init];
  addBankCardVC.delegate = self;
  [self.navigationController pushViewController:addBankCardVC animated:YES];
  
}

- (void)setup {
  
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [self.view addSubview:_tableView];
  
  _bottomView = [[UIView alloc] init];
  _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_bottomView];
  
  UIView *tableFooterView = [[UIView alloc] initWithFrame:self.view.bounds];
  
  _contentView = [[UIView alloc] init];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [tableFooterView addSubview:_contentView];
  
  UIView *bankCardDescriptionView = [[OMNCardBrandView alloc] init];
  [_contentView addSubview:bankCardDescriptionView];
  
  _errorLabel = [[UILabel alloc] init];
  _errorLabel.numberOfLines = 0;
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  _errorLabel.textColor = colorWithHexString(@"d0021b");
  _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_errorLabel];
  
  _offerLabel = [[UILabel alloc] init];
  _offerLabel.numberOfLines = 0;
  _offerLabel.textAlignment = NSTextAlignmentCenter;
  _offerLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [_bottomView addSubview:_offerLabel];
  
  _payButton = [[UIButton alloc] init];
  _payButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_bottomView addSubview:_payButton];
  
  NSDictionary *views =
  @{
    @"tableFooterView" : tableFooterView,
    @"contentView" : _contentView,
    @"bankCardDescriptionView" : bankCardDescriptionView,
    @"errorLabel" : _errorLabel,
    @"offerLabel" : _offerLabel,
    @"payButton" : _payButton,
    @"bottomView" : _bottomView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"height" : @(50.0f),
    @"offset" : @(8.0f),
    @"bottomOffset" : @(10.0f),
    @"payButtonWidth" : @(200.0f),
    };
  
  [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[offerLabel]-|" options:0 metrics:0 views:views]];
  [_bottomView addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[payButton(payButtonWidth)]" options:0 metrics:metrics views:views]];
  [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[offerLabel]-(offset)-[payButton]-(bottomOffset)-|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomView]|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView]|" options:0 metrics:metrics views:views]];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[errorLabel]-|" options:0 metrics:0 views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bankCardDescriptionView]" options:0 metrics:0 views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bankCardDescriptionView]-(offset)-[errorLabel(>=0)]-|" options:0 metrics:metrics views:views]];
  
  [tableFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:metrics views:views]];
  [tableFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:metrics views:views]];

  self.tableView.tableFooterView = tableFooterView;
  
}

#pragma mark - OMNAddBankCardVCDelegate

- (void)addBankCardVC:(OMNAddBankCardVC *)addBankCardVC didAddCard:(OMNBankCardInfo *)bankCardInfo {
  
  OMNMailRUCardConfirmVC *mailRUCardConfirmVC = [[OMNMailRUCardConfirmVC alloc] initWithCardInfo:bankCardInfo];
  mailRUCardConfirmVC.delegate = self;
  [self.navigationController pushViewController:mailRUCardConfirmVC animated:YES];
  
}

- (void)addBankCardVCDidCancel:(OMNAddBankCardVC *)addBankCardVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNMailRUCardConfirmVCDelegate

- (void)mailRUCardConfirmVCDidFinish:(OMNMailRUCardConfirmVC *)mailRUCardConfirmVC {

  [self.navigationController popToViewController:self animated:YES];
  
}


@end
