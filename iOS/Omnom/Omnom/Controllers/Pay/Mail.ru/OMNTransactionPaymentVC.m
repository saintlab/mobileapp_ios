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
#import "OMNTransactionPaymentVC.h"
#import "OMNOperationManager.h"
#import <BlocksKit.h>
#import <OMNStyler.h>
#import "OMNBankCard+omn_info.h"
#import "OMNBankCardMediator.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurant+omn_payment.h"
#import "OMNNavigationController.h"

@interface OMNTransactionPaymentVC()

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) OMNBankCardMediator *bankCardMediator;
@property (nonatomic, copy) PMKFulfiller fulfill;
@property (nonatomic, copy) PMKRejecter reject;

@end

@implementation OMNTransactionPaymentVC {

  UILabel *_errorLabel;
  
  UILabel *_offerLabel;
  UIButton *_payButton;
  UIView *_bottomView;
  
  OMNBankCardsModel *_bankCardsModel;
  UIView *_contentView;
  BOOL _addBankCardRequested;
  
  NSString *_bankCardsModelLoadingIdentifier;
  
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  if (_bankCardsModelLoadingIdentifier) {
    [_bankCardMediator bk_removeObserversWithIdentifier:_bankCardsModelLoadingIdentifier];
  }
  
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor transaction:(OMNAcquiringTransaction *)acquiringTransaction {
  self = [super init];
  if (self) {
    
    _acquiringTransaction = acquiringTransaction;
    _visitor = visitor;
    self.bankCardMediator = [[visitor.restaurant paymentFactory] bankCardMediatorWithRootVC:self transaction:acquiringTransaction];
    _bankCardsModel = [self.bankCardMediator bankCardsModel];

  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];

  [self omn_setup];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kOMN_CANCEL_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
  @weakify(self)
  _bankCardsModelLoadingIdentifier = [_bankCardsModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(loading)) options:NSKeyValueObservingOptionNew task:^(OMNBankCardsModel *obj, NSDictionary *change) {
    
    @strongify(self)
    [self.navigationItem setRightBarButtonItem:(obj.loading) ? ([UIBarButtonItem omn_loadingItem]) : ([self addCardButton]) animated:YES];
    
  }];

  [_bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
    if (kOMNBankCardStatusHeld == bankCard.status) {
      
      @strongify(self)
      [self.bankCardMediator confirmCard:[bankCard bankCardInfo]];
      
    }
    
  }];
  
  [self.bankCardMediator setDidPayBlock:^(OMNBill *bill, OMNError *error) {
    
    @strongify(self)
    if (error) {
      
      if (kOMNErrorOrderClosed == error.code) {
        
        [self orderDidClosed];
        
      }
      else {
        
        [self.navigationController popToViewController:self animated:YES];
        
      }
      
    }
    else {
      
      [self paymentDidFinishWithBill:bill];
      
    }
    
  }];
  
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
  _errorLabel.text = nil;
  _offerLabel.text = nil;
  _offerLabel.font = FuturaOSFOmnomRegular(18.0f);
  
  _payButton.titleLabel.font = PRICE_BUTTON_FONT;
  [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  _payButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
  [_payButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  
  long long totalAmount = self.bankCardMediator.acquiringTransaction.total_amount;
  NSString *toPayString = [NSString stringWithFormat:kOMN_TO_PAY_BUTTON_FORMAT,  [OMNUtils formattedMoneyStringFromKop:totalAmount]];
  [_payButton setTitle:toPayString forState:UIControlStateNormal];

  [_payButton addTarget:self action:@selector(payTap:) forControlEvents:UIControlEventTouchUpInside];
  _payButton.enabled = NO;
  
}

- (PMKPromise *)pay:(UIViewController *)presentingVC {
  
  [presentingVC presentViewController:[OMNNavigationController controllerWithRootVC:self] animated:YES completion:nil];
  @weakify(self)
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    @strongify(self)
    self.fulfill = fulfill;
    self.reject = reject;
    
  }];
  
}

- (UIBarButtonItem *)addCardButton {
  return [[UIBarButtonItem alloc] initWithTitle:kOMN_ADD_CARD_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(addCardTap)];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  @weakify(self)
  [_bankCardsModel loadCardsWithCompletion:^{
    
    @strongify(self)
    [self didLoadCards];
    
  }];
  
}

- (void)didLoadCards {
  
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
  
  if (_bankCardsModel.hasRegisterdCards) {
    
    _payButton.enabled = YES;
    
  }
  else if (!_addBankCardRequested &&
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
  OMNBankCardInfo *bankCardInfo = [bankCard bankCardInfo];
  [_bankCardMediator payWithCardInfo:bankCardInfo];

}

- (void)paymentDidFinishWithBill:(OMNBill *)bill {

  [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    
    self.fulfill(PMKManifold(self, bill));
    
  }];
  
}

- (void)orderDidClosed {
  [self didFinishWithError:[OMNError errorWithDomain:OMNErrorDomain code:kOMNErrorOrderClosed userInfo:nil]];
}

- (void)cancelTap {
  [self didFinishWithError:[OMNError errorWithDomain:OMNErrorDomain code:kOMNErrorCancel userInfo:nil]];
}

- (void)didFinishWithError:(OMNError *)error {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    self.reject(error);
  }];
}

- (void)addCardTap {
  [_bankCardMediator registerCard];
}

- (void)omn_setup {
  
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
  _errorLabel.textColor = [OMNStyler redColor];
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
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[offerLabel]-|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:180.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[offerLabel]-(offset)-[payButton]-(bottomOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[errorLabel]-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[bankCardDescriptionView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[bankCardDescriptionView]-(offset)-[errorLabel(>=0)]-|" options:kNilOptions metrics:metrics views:views]];
  
  [tableFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  [tableFooterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:metrics views:views]];

  self.tableView.tableFooterView = tableFooterView;
  
}

@end
