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
#import "OMNOrder.h"
#import "OMNBankCardsModel.h"
#import "OMNCardBrandView.h"
#import "OMNAddBankCardVC.h"
#import <OMNStyler.h>

@interface OMNMailRUPayVC()
<OMNAddBankCardVCDelegate>

@end

@implementation OMNMailRUPayVC {
  UIView *_bankCardDescriptionView;
  UILabel *_errorLabel;
  
  UILabel *_offerLabel;
  UIButton *_offer1Button;
  UIButton *_payButton;
  
  OMNOrder *_order;
  OMNBill *_bill;
  OMNBankCardsModel *_bankCardsModel;
  UIView *_contentView;
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
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Добавить карту", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addCardTap)];
  [self setup];
  
  _bankCardsModel = [[OMNBankCardsModel alloc] init];
//  __weak typeof(self)weakSelf = self;
  [_bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
//    [weakSelf.delegate bankCardsVC:weakSelf didSelectCard:bankCard];
    
  }];
  
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
  _errorLabel.text = @"dsa\n\n\n\nasd";
  _offerLabel.text = NSLocalizedString(@"Оплата счета и чаевых будет произведена двумя транзакциями, по причине ...", nil);
  _offerLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  
  [_offer1Button setTitle:NSLocalizedString(@"Ссылка N1 на оферту", nil) forState:UIControlStateNormal];
  _offer1Button.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  [_offer1Button setTitleColor:colorWithHexString(@"4A90E2") forState:UIControlStateNormal];
  [_offer1Button sizeToFit];
  
  [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_payButton setTitle:NSLocalizedString(@"Оплатить", nil) forState:UIControlStateNormal];
  [_payButton sizeToFit];
  [_payButton addTarget:self action:@selector(payTap) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel loadCardsWithCompletion:^{
    
    [weakSelf.tableView reloadData];
    
  }];
  
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
}

- (void)payTap {
  
  if (_bill) {
    [self billDidCreated:_bill];
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_order createBill:^(OMNBill *bill) {
    
    [weakSelf billDidCreated:bill];
    
  } failure:^(NSError *error) {
    
    _errorLabel.text = error.localizedDescription;
    
  }];
  
}

- (void)billDidCreated:(OMNBill *)bill {
  
  _bill = bill;
  
  OMNMailRuPaymentInfo *paymentInfo = [_bankCardsModel selectedCardPaymentInfo];
  paymentInfo.order_id = _bill.id;
  paymentInfo.extra.tip = _order.tipAmount;
  paymentInfo.extra.restaurant_id = @"1";
  paymentInfo.order_amount = @(_order.toPayAmount/100.);
  
  __weak typeof(self)weakSelf = self;
  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
    
    NSLog(@"payWithCardInfo>%@", response);
    [weakSelf didPayWithResponse:response];
    
  }];

}

- (void)didPayWithResponse:(id)response {
  
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
  
  UIView *tableFooterView = [[UIView alloc] initWithFrame:self.view.bounds];
  
  _contentView = [[UIView alloc] init];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [tableFooterView addSubview:_contentView];
  
  _bankCardDescriptionView = [[OMNCardBrandView alloc] init];
  [_contentView addSubview:_bankCardDescriptionView];
  
  _errorLabel = [[UILabel alloc] init];
  _errorLabel.numberOfLines = 0;
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  _errorLabel.textColor = [UIColor redColor];
  _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_errorLabel];
  
  _offerLabel = [[UILabel alloc] init];
  _offerLabel.numberOfLines = 0;
  _offerLabel.textAlignment = NSTextAlignmentCenter;
  _offerLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_offerLabel];
  
  UIColor *offserButtonColor = [UIColor colorWithRed:57/255.0f  green:142/255.0f blue:225/255.0f alpha:1.0f];
  
  _offer1Button = [[UIButton alloc] init];
  [_offer1Button setTitleColor:offserButtonColor forState:UIControlStateNormal];
  _offer1Button.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_offer1Button];

  _payButton = [[UIButton alloc] init];
  [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _payButton.translatesAutoresizingMaskIntoConstraints = NO;
  
  [_contentView addSubview:_payButton];
  
  NSDictionary *views =
  @{
    @"tableFooterView" : tableFooterView,
    @"contentView" : _contentView,
    @"bankCardDescriptionView" : _bankCardDescriptionView,
    @"errorLabel" : _errorLabel,
    @"offerLabel" : _offerLabel,
    @"offer1Button" : _offer1Button,
    @"payButton" : _payButton,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"height" : @(50.0f),
    @"offset" : @(8.0f),
    };
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[errorLabel]-|" options:0 metrics:0 views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[offerLabel]-|" options:0 metrics:0 views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bankCardDescriptionView]" options:0 metrics:0 views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[offer1Button]-|" options:0 metrics:0 views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[payButton]-|" options:0 metrics:0 views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bankCardDescriptionView]-(offset)-[errorLabel(>=0)]-(offset)-[offerLabel]-(offset)-[offer1Button]-(offset)-[payButton]-|" options:0 metrics:metrics views:views]];
  
  [tableFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:metrics views:views]];
  [tableFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:metrics views:views]];

  self.tableView.tableFooterView = tableFooterView;
  
}

#pragma mark - OMNAddBankCardVCDelegate

- (void)addBankCardVC:(OMNAddBankCardVC *)addBankCardVC didAddCard:(OMNBankCardInfo *)bankCardInfo {
  
  _bankCardsModel.customCard = bankCardInfo;
  [self.tableView reloadData];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)addBankCardVCDidCancel:(OMNAddBankCardVC *)addBankCardVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

@end
