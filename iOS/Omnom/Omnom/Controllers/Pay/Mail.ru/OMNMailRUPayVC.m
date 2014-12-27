//
//  OMNMailRUPayVC.m
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorization.h"
#import "OMNBankCardInfo.h"
#import "OMNCardBrandView.h"
#import "OMNLoadingCircleVC.h"
#import "OMNMailRUCardConfirmVC.h"
#import "OMNMailRUPayVC.h"
#import "OMNMailRuBankCardsModel.h"
#import "OMNTestBankCardsModel.h"
#import "OMNOperationManager.h"
#import "OMNOrder+network.h"
#import "OMNOrder+omn_mailru.h"
#import "OMNSocketManager.h"
#import "OMNError.h"
#import "UIImage+omn_helper.h"
#import "UINavigationController+omn_replace.h"
#import <BlocksKit.h>
#import <OMNDeletedTextField.h>
#import <OMNMailRuAcquiring.h>
#import <OMNStyler.h>
#import "OMNBankCard.h"
#import "OMNBankCardMediator.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNMailRUPayVC()

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
  NSString *_mailRUPayVCLoadingIdentifier;
  BOOL _addBankCardRequested;
  
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  if (_mailRUPayVCLoadingIdentifier) {
    
    [self bk_removeObserversWithIdentifier:_mailRUPayVCLoadingIdentifier];
    _mailRUPayVCLoadingIdentifier = nil;
    
  }
  
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
  [self setup];
  
  __weak typeof(self)weakSelf = self;
  if (self.demo) {
    
    _bankCardsModel = [[OMNTestBankCardsModel alloc] initWithRootVC:self];
    
  }
  else {
    
    _bankCardsModel = [[OMNMailRuBankCardsModel alloc] initWithRootVC:self];
    
  }

  _mailRUPayVCLoadingIdentifier = [_bankCardsModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(loading)) options:NSKeyValueObservingOptionNew task:^(OMNBankCardsModel *obj, NSDictionary *change) {
    
    [weakSelf.navigationItem setRightBarButtonItem:(obj.loading) ? ([UIBarButtonItem omn_loadingItem]) : ([weakSelf addCardButton]) animated:YES];
    
  }];

  [_bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
    return weakSelf;
    
  }];
  
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
  _errorLabel.text = nil;
  _offerLabel.text = nil;
  _offerLabel.font = FuturaOSFOmnomRegular(18.0f);
  
  _payButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  _payButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
  [_payButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  
  NSString *toPayString = [NSString stringWithFormat:NSLocalizedString(@"TO_PAY_BUTTON_TEXT %@", @"Оплатить {AMOUNT}"),  [OMNUtils formattedMoneyStringFromKop:_order.enteredAmountWithTips]];
  [_payButton setTitle:toPayString forState:UIControlStateNormal];

  [_payButton addTarget:self action:@selector(payTap:) forControlEvents:UIControlEventTouchUpInside];
  _payButton.enabled = NO;
  
}

- (UIBarButtonItem *)addCardButton {
  
  return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Добавить карту", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addCardTap)];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  
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
  
  if (_bankCardsModel.hasRegisterdCards) {
    
    _payButton.enabled = YES;
    
  }
  else if (NO ==_addBankCardRequested &&
           0 == _bankCardsModel.cards.count) {
    
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
  
  OMNBankCard *bankCard = [_bankCardsModel selectedCard];
  OMNBankCardInfo *bankCardInfo = [[OMNBankCardInfo alloc] init];
  bankCardInfo.card_id = bankCard.external_card_id;
  [self payWithCardInfo:bankCardInfo];
  
}

- (void)payWithCardInfo:(OMNBankCardInfo *)bankCardInfo {
  
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel payForOrder:_order cardInfo:bankCardInfo completion:^{
    
    [weakSelf mailRuDidFinish];
    
  } failure:^(NSError *error, NSDictionary *debugInfo) {
    
    if (OMNErrorOrderClosed == error.code) {
      
      [weakSelf orderDidClosed];
      
    }
    else {
      
      [weakSelf popViewController];
      
    }

  }];
  
}

- (void)mailRuDidFinish {

  [self.delegate mailRUPayVCDidFinish:self withBill:_bill];
  
}

- (void)popViewController {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)orderDidClosed {
  
  [self.delegate mailRUPayVCOrderDidClosed:self];
  
}

- (void)demoPay {
  
  [self.delegate mailRUPayVCDidFinish:self withBill:nil];
  
}

- (void)cancelTap {
  
  [self.delegate mailRUPayVCDidCancel:self];
  
}

- (void)addCardTap {
  
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel.bankCardMediator addCardForOrder:_order requestPaymentWithCard:^(OMNBankCardInfo *bankCardInfo) {
    
    //clear card_id for payment
    bankCardInfo.card_id = nil;
    bankCardInfo.saveCard = NO;
    [weakSelf payWithCardInfo:bankCardInfo];
    
  }];
  
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
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[offerLabel]-|" options:0 metrics:0 views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:180.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[offerLabel]-(offset)-[payButton]-(bottomOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[errorLabel]-|" options:kNilOptions metrics:0 views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[bankCardDescriptionView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bankCardDescriptionView]-(offset)-[errorLabel(>=0)]-|" options:kNilOptions metrics:metrics views:views]];
  
  [tableFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  [tableFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:metrics views:views]];

  self.tableView.tableFooterView = tableFooterView;
  
}

@end
