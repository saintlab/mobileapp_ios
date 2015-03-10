//
//  OMNOrderAcquiringTransaction.m
//  omnom
//
//  Created by tea on 04.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMailAcquiringTransaction.h"
#import "OMNOperationManager.h"
#import "OMNBill.h"
#import <OMNMailRuAcquiring.h>
#import "OMNAuthorization.h"
#import "OMNAnalitics.h"

@interface OMNBankCardInfo (omn_mailRuBankCardInfo)

- (OMNMailRuCardInfo *)omn_mailRuCardInfo;

@end

@implementation OMNMailAcquiringTransaction {
  
  OMNBankCardInfo *_bankCardInfo;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.order_id = @"";
    self.wish_id = @"";
    self.table_id = @"";
    self.restaurant_id = @"";
    
  }
  return self;
}

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [self init];
  if (self) {
    
    self.bill_amount = order.enteredAmount;
    self.tips_amount = order.tipAmount;
    self.restaurant_id = (order.restaurant_id) ?: (@"");
    self.order_id = (order.id) ?: (@"");
    self.table_id = (order.table_id) ?: @"";;
    self.tips_way = stringFromTipType(order.tipType);
    self.split_way = stringFromSplitType(order.splitType);
    self.info = [order debug_info];
    
  }
  return self;
}

- (instancetype)initWithWish:(OMNWish *)wish {
  self = [self init];
  if (self) {
    
    self.bill_amount = wish.totalAmount;
    self.tips_amount = 0ll;
    self.restaurant_id = (wish.restaurant_id) ?: (@"");
    self.wish_id = (wish.id) ?: (@"");
    self.table_id = (wish.table_id) ?: @"";;
    self.tips_way = stringFromTipType(kTipTypeDefault);
    self.split_way = stringFromSplitType(kSplitTypeNone);
    
  }
  return self;
}

- (void)payWithCard:(OMNBankCardInfo *)bankCardInfo completion:(OMNPaymentDidFinishBlock)completionBlock {
  
  _bankCardInfo = bankCardInfo;
  
  NSMutableDictionary *parameters =
  [@{
    @"amount": @(self.bill_amount),
    @"tip_amount": @(self.tips_amount),
    @"restaurant_id" : self.restaurant_id,
    @"table_id" : self.table_id,
    @"description" : @"",
    } mutableCopy];

  if (self.order_id.length) {
    parameters[@""] = self.order_id;
  }
  
  if (self.wish_id.length) {
    parameters[@"wish_id"] = self.wish_id;
  }
  
  @weakify(self)
  [[OMNOperationManager sharedManager] POST:@"/bill" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      
      NSString *status = responseObject[@"status"];
      if ([status isEqualToString:@"new"]) {
        
        @strongify(self)
        OMNBill *bill = [[OMNBill alloc] initWithJsonData:responseObject];
        [self didCreateBill:bill completion:completionBlock];
        
      }
      else if ([status isEqualToString:@"paid"] ||
               [status isEqualToString:@"order_closed"]) {
        
        completionBlock(nil, [OMNError omnomErrorFromCode:kOMNErrorOrderClosed]);
        
      }
      else if ([status isEqualToString:@"restaurant_not_available"]) {
        
        completionBlock(nil, [OMNError omnomErrorFromCode:kOMNErrorRestaurantUnavailable]);
        
      }
      else {
        
        completionBlock(nil, [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
        
      }
      
    }
    else {
      
      completionBlock(nil, [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    completionBlock(nil, [error omn_internetError]);
    
  }];
  
}

- (void)didCreateBill:(OMNBill *)bill completion:(OMNPaymentDidFinishBlock)completionBlock {
  
  OMNBankCardInfo *bankCardInfo = _bankCardInfo;
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  paymentInfo.cardInfo = [bankCardInfo omn_mailRuCardInfo];
  paymentInfo.user_login = [OMNAuthorization authorisation].user.id;
  paymentInfo.user_phone = [OMNAuthorization authorisation].user.phone;
  paymentInfo.order_message = @"message";
  paymentInfo.extra.tip = self.tips_amount;
  paymentInfo.extra.restaurant_id = bill.mail_restaurant_id;
  paymentInfo.order_amount = @(0.01*self.total_amount);
  paymentInfo.order_id = bill.id;

  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
    
    [[OMNOperationManager sharedManager] POST:@"/report/mail/payment" parameters:response success:nil failure:nil];
    [[OMNAnalitics analitics] logPayment:self cardInfo:bankCardInfo bill:bill];
    completionBlock(bill, nil);
    
  } failure:^(NSError *mailError, NSDictionary *request, NSDictionary *response) {
    
    [[OMNAnalitics analitics] logMailEvent:@"ERROR_MAIL_CARD_PAY" cardInfo:bankCardInfo error:mailError request:request response:response];
    OMNError *omnomError = [OMNError omnnomErrorFromError:mailError];
    completionBlock(bill, omnomError);
    
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
