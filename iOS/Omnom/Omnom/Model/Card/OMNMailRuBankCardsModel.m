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
#import "OMNAuthorisation.h"
#import "OMNOrder+omn_mailru.h"
#import <OMNMailRuAcquiring.h>
#import "OMNOperationManager.h"
#import "OMNOrderTansactionInfo.h"
#import "OMNAnalitics.h"
#import "OMNUtils.h"

@interface OMNBankCardInfo (omn_mailRuBankCardInfo)

- (OMNMailRuCardInfo *)omn_mailRuCardInfo;

@end

@interface NSError (omn_mailru)

- (NSError *)omn_omnomError;

@end

@implementation OMNMailRuBankCardsModel {
}

- (instancetype)initWithRootVC:(UIViewController *)vc {
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
    
    [order getPaymentInfoForUser:[OMNAuthorisation authorisation].user cardInfo:mailRuCardInfo copmletion:^(OMNMailRuPaymentInfo *paymentInfo) {
      
      [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
        
        [[OMNOperationManager sharedManager] POST:@"/report/mail/payment" parameters:response success:nil failure:nil];
        [[OMNAnalitics analitics] logPayment:orderTansactionInfo bill_id:order.bill.id];
        paymentFinishBlock(nil, completionBlock);
        
      } failure:^(NSError *mailError, NSDictionary *debugInfo) {

        NSError *omnomError = [mailError omn_omnomError];

        paymentFinishBlock(omnomError, ^{
          
          failureBlock(omnomError, debugInfo);
          
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

@implementation NSError (omn_mailru)

- (NSError *)omn_omnomError {
  
  if (kOMNMailRuErrorCodeUnknown == self.code) {
    
    return [OMNUtils errorFromCode:OMNErrorPaymentError];
    
  }
  else {
    
    return [self omn_internetError];
    
  }
  
}

@end
