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

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    
    self.bill_amount = order.enteredAmount;
    self.tips_amount = order.tipAmount;
    self.restaurant_id = (order.restaurant_id) ? ([order.restaurant_id copy]) : (@"");
    self.order_id = (order.id) ? ([order.id copy]) : (@"");
    self.table_id = (order.table_id) ? ([order.table_id copy]) : @"";;
    self.tips_way = stringFromTipType(order.tipType);
    self.split_way = stringFromSplitType(order.splitType);
  }
  return self;
}

- (instancetype)initWithWish:(OMNWish *)wish {
  self = [super init];
  if (self) {
    
    self.bill_amount = wish.totalAmount;
    self.tips_amount = 0ll;
    self.restaurant_id = (wish.restaurant_id) ? ([wish.restaurant_id copy]) : (@"");
    self.order_id = (wish.id) ? ([wish.id copy]) : (@"");
    self.table_id = (wish.table_id) ? ([wish.table_id copy]) : @"";;
    self.tips_way = stringFromTipType(kTipTypeDefault);
    self.split_way = stringFromSplitType(kSplitTypeNone);

  }
  return self;
}

- (void)payWithCard:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void (^)(OMNError *))failureBlock {
  
  _bankCardInfo = bankCardInfo;
  
  NSDictionary *parameters =
  @{
    @"amount": @(self.bill_amount),
    @"tip_amount": @(self.tips_amount),
    @"restaurant_id" : self.restaurant_id,
    @"restaurateur_order_id" : self.order_id,
    @"table_id" : self.table_id,
    @"description" : @"",
    };
  
  @weakify(self)
  [[OMNOperationManager sharedManager] POST:@"/bill" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      
      NSString *status = responseObject[@"status"];
      if ([status isEqualToString:@"new"]) {
        
        @strongify(self)
        OMNBill *bill = [[OMNBill alloc] initWithJsonData:responseObject];
        [self didCreateBill:bill withCompletion:completionBlock failure:failureBlock];
        
      }
      else if ([status isEqualToString:@"paid"] ||
               [status isEqualToString:@"order_closed"]) {
        
        failureBlock([OMNError omnomErrorFromCode:kOMNErrorOrderClosed]);
        
      }
      else if ([status isEqualToString:@"restaurant_not_available"]) {
        
        failureBlock([OMNError omnomErrorFromCode:kOMNErrorRestaurantUnavailable]);
        
      }
      else {
        
        failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
        
      }
      
    }
    else {
      
      failureBlock([OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([error omn_internetError]);
    
  }];
  
}

- (void)didCreateBill:(OMNBill *)bill withCompletion:(dispatch_block_t)completionBlock failure:(void (^)(OMNError *))failureBlock {
  
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
    completionBlock();
    
  } failure:^(NSError *mailError, NSDictionary *request, NSDictionary *response) {
    
    [[OMNAnalitics analitics] logMailEvent:@"ERROR_MAIL_CARD_PAY" cardInfo:bankCardInfo error:mailError request:request response:response];
    OMNError *omnomError = [OMNError omnnomErrorFromError:mailError];
    failureBlock(omnomError);
    
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
