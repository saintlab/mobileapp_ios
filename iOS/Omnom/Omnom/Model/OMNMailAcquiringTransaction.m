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
#import "OMNAuthorization.h"
#import "OMNAnalitics.h"
#import "OMNBankCardInfo+omn_mailRuBankCardInfo.h"
#import "OMNUser+omn_mailRu.h"

@implementation OMNMailAcquiringTransaction {
  
  OMNBankCardInfo *_bankCardInfo;
  
}

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super initWithOrder:order];
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
  self = [super initWithWish:wish];
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
    parameters[@"restaurateur_order_id"] = self.order_id;
  }
  
  if (self.wish_id.length) {
    parameters[@"wish_id"] = self.wish_id;
  }
  
  @weakify(self)
  [[OMNOperationManager sharedManager] POST:@"/bill" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    OMNError *error = [OMNError billErrorFromResponse:responseObject];
    if (error) {
      
      [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BILL_CREATE" jsonRequest:parameters responseOperation:operation];
      completionBlock(nil, error);
      
    }
    else {
      
      @strongify(self)
      OMNBill *bill = [[OMNBill alloc] initWithJsonData:responseObject];
      [self didCreateBill:bill completion:completionBlock];
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BILL_CREATE" jsonRequest:parameters responseOperation:operation];
    completionBlock(nil, [error omn_internetError]);
    
  }];
  
}

- (void)didCreateBill:(OMNBill *)bill completion:(OMNPaymentDidFinishBlock)completionBlock {
  
  OMNBankCardInfo *bankCardInfo = _bankCardInfo;
  OMNMailRuTransaction *transaction = [[OMNMailRuTransaction alloc] init];
  transaction.card = [bankCardInfo omn_mailRuCardInfo];
  transaction.user = [[OMNAuthorization authorisation].user omn_mailRuUser];
  transaction.extra = [OMNMailRuExtra extraWithRestaurantID:bill.mail_restaurant_id tipAmount:self.tips_amount type:self.type];
  transaction.order = [OMNMailRuOrder orderWithID:bill.id amount:@(0.01*self.total_amount)];

  [OMNMailRuAcquiring payWithInfo:transaction].then(^(id response, id pollResponse) {
    
    [[OMNAnalitics analitics] logPayment:self cardInfo:bankCardInfo bill:bill];
    completionBlock(bill, nil);
    
  }).catch(^(NSError *error) {
    
    OMNError *omnomError = [OMNError omnnomErrorFromError:error];
    [[OMNAnalitics analitics] logMailEvent:@"ERROR_MAIL_CARD_PAY" cardInfo:bankCardInfo error:error];
    completionBlock(bill, omnomError);
    
  });
  
}

@end


