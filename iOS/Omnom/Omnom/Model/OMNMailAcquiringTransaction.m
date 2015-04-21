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

@implementation OMNMailAcquiringTransaction

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
  
  @weakify(self)
  [self createBillWithCard:bankCardInfo].then(^(OMNBill *bill) {
    
    @strongify(self)
    OMNMailRuExtra *extra = [OMNMailRuExtra extraWithRestaurantID:bill.mail_restaurant_id tipAmount:self.tips_amount type:self.type];
    [OMNMailRuAcquiring payWithCard:[bankCardInfo omn_mailRuCard] user:[[OMNAuthorization authorisation].user omn_mailRuUser] order_id:bill.id order_amount:@(0.01*self.total_amount) extra:extra].then(^(NSDictionary *response) {
      
      [[OMNAnalitics analitics] logPayment:self cardInfo:bankCardInfo bill:bill];
      completionBlock(bill, nil);
      
    }).catch(^(NSError *error) {
      
      [[OMNAnalitics analitics] logMailEvent:@"ERROR_MAIL_CARD_PAY" cardInfo:bankCardInfo error:error];
      OMNError *omnomError = [OMNError omnnomErrorFromError:error];
      completionBlock(bill, omnomError);
      
    });

    
  }).catch(^(OMNError *error) {
    
    [[OMNAnalitics analitics] logDebugEvent:@"ERROR_BILL_CREATE" parametrs:error.userInfo];
    completionBlock(nil, error);
    
  });
  
}

- (PMKPromise *)createBillWithCard:(OMNBankCardInfo *)bankCardInfo {
  
  NSMutableDictionary *parameters =
  [@{
     @"amount": @(self.bill_amount),
     @"tip_amount": @(self.tips_amount),
     @"restaurant_id" : self.restaurant_id,
     @"table_id" : self.table_id,
     @"type" : self.type,
     } mutableCopy];
  
  if (self.order_id.length) {
    parameters[@"restaurateur_order_id"] = self.order_id;
  }
  
  if (self.wish_id.length) {
    parameters[@"wish_id"] = self.wish_id;
  }
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] POST:@"/bill" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      OMNError *error = nil;
      OMNBill *bill = [OMNBill billWithJsonData:responseObject error:&error];
      if (error) {
        
        reject(error);
        
      }
      else {
        
        fulfill(bill);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      fulfill([operation omn_internetError]);
      
    }];
    
  }];
  
}

@end


