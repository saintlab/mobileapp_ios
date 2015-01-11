//
//  OMNMailRuBankCardsModel.m
//  omnom
//
//  Created by tea on 19.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMailRuBankCardsModel.h"
#import <SSKeychain.h>
#import "OMNMailRUCardConfirmVC.h"
#import "OMNPaymentAlertVC.h"
#import "OMNMailRuBankCardMediator.h"
#import "OMNBankCard.h"
#import "OMNAuthorization.h"
#import "OMNOrder+omn_mailru.h"
#import <OMNMailRuAcquiring.h>
#import "OMNOperationManager.h"
#import "OMNOrderTansactionInfo.h"
#import "OMNAnalitics.h"
#import "OMNUtils.h"
#import "OMNError.h"

@interface OMNBankCardInfo (omn_mailRuBankCardInfo)

- (OMNMailRuCardInfo *)omn_mailRuCardInfo;

@end

@implementation OMNMailRuBankCardsModel {
}

- (instancetype)initWithRootVC:(__weak UIViewController *)vc {
  self = [super initWithRootVC:vc];
  if (self) {
    
    self.bankCardMediator = [[OMNMailRuBankCardMediator alloc] initWithRootVC:vc];
    
  }
  return self;
}

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {

  __weak typeof(self)weakSelf = self;
  self.loading = YES;
  [OMNBankCard getCardsWithCompletion:^(NSArray *cards) {
    
    [weakSelf didLoadCards:cards];
    completionBlock();
    
  } failure:^(NSError *error) {
    
    [weakSelf didLoadCards:nil];
    completionBlock();
    
  }];
  
}

- (void)didLoadCards:(NSArray *)cards {
  
  if (cards) {
    self.cards = [cards mutableCopy];
  }
  
  [self updateCardSelection];
  self.loading = NO;
  
}

- (void)payForOrder:(OMNOrder *)order cardInfo:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void (^)(NSError *, NSDictionary *))failureBlock {
  
  [self.bankCardMediator beginPaymentProcessWithPresentBlock:^(OMNPaymentFinishBlock paymentFinishBlock) {
    
    OMNMailRuCardInfo *mailRuCardInfo = [bankCardInfo omn_mailRuCardInfo];
    OMNOrderTansactionInfo *orderTansactionInfo = [[OMNOrderTansactionInfo alloc] initWithOrder:order];
    
    [order getPaymentInfoForUser:[OMNAuthorization authorisation].user cardInfo:mailRuCardInfo copmletion:^(OMNMailRuPaymentInfo *paymentInfo) {
      
      [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
        
        [[OMNOperationManager sharedManager] POST:@"/report/mail/payment" parameters:response success:nil failure:nil];
        [[OMNAnalitics analitics] logPayment:orderTansactionInfo cardInfo:bankCardInfo bill_id:order.bill.id];
        paymentFinishBlock(nil, completionBlock);

      } failure:^(NSError *mailError, NSDictionary *request, NSDictionary *response) {
        
        [[OMNAnalitics analitics] logMailEvent:@"ERROR_MAIL_CARD_PAY" cardInfo:bankCardInfo error:mailError request:request response:response];
        NSError *omnomError = [OMNError omnnomErrorFromError:mailError];
        paymentFinishBlock(omnomError, ^{
          
          failureBlock(omnomError, nil);
          
        });
        
      }];
      
    } failure:^(NSError *error) {
      
      paymentFinishBlock(error, ^{
        
        failureBlock(error, nil);
        
      });
      
    }];
    
  }];
  
}

@end

@implementation OMNBankCardInfo (omn_mailRuBankCardInfo)

- (OMNMailRuCardInfo *)omn_mailRuCardInfo {
  
  OMNMailRuCardInfo *mailRuCardInfo = nil;
  if (self.card_id) {
    
    mailRuCardInfo = [OMNMailRuCardInfo cardInfoWithCardId:self.card_id];
    
  }
  else if (self.expiryMonth &&
           self.expiryYear &&
           self.cvv &&
           self.pan){
    
    NSString *exp_date = [OMNMailRuCardInfo exp_dateFromMonth:self.expiryMonth year:self.expiryYear];
    mailRuCardInfo = [OMNMailRuCardInfo cardInfoWithCardPan:self.pan exp_date:exp_date cvv:self.cvv];
    
  }
  
  return mailRuCardInfo;
  
}

@end

