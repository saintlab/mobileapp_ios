//
//  OMNMailRuAcquiring.m
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNMailRuAcquiring.h"
#import "OMNMailRu3DSConfirmVC.h"
#import "OMNMailRuPoll.h"

static OMNMailRuConfig *_config = nil;

@implementation OMNMailRuAcquiring

+ (OMNMailRuConfig *)config {
  return _config;
}

+ (instancetype)acquiring {
  
  if (!_config) {
    [self setConfig:
     @{
       @"OMNMailRu_merch_id" : @"DGIS",
       @"OMNMailRu_vterm_id" : @"DGISMobile",
       @"OMNMailRu_cardholder" : @"Omnom",
       @"OMNMailRu_secret_key" : @"5FEgXKDjuaegndwVJugNVUTMov8AXR7kY6CFLdivveDpxn5XmF",
       @"OMNMailRuAcquiringBaseURL" : @"https://cpg.money.mail.ru/api/",
       @"OMNMailRuTestCVV" : @"",
       }];
  }
  
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:_config.baseURL]];
  });
  return manager;
}

+ (void)setConfig:(NSDictionary *)parametrs {
  
  OMNMailRuConfig *config = [OMNMailRuConfig configWithParametrs:parametrs];
  if (config.isValid) {
    _config = config;
  }

}

+ (NSDictionary *)configWithName:(NSString *)name {
  NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"]];
  NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  return config;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {

    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 15.0;
    
  }
  return self;
}

+ (PMKPromise *)registerCard:(OMNMailRuCard *)card user:(OMNMailRuUser *)user {
  
  OMNMailRuCardRegisterTransaction *transaction = [[OMNMailRuCardRegisterTransaction alloc] initWithCard:card user:user order:nil extra:nil];
  NSDictionary *registerParameters = [transaction parametersWithConfig:_config];
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNMailRuAcquiring acquiring] POST:@"card/register" parameters:registerParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      fulfill(responseObject);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([OMNMailRuError omn_errorWithRequest:registerParameters responseOperation:operation]);
      
    }];
    
  }].then(^(NSDictionary *response) {
    
    return [OMNMailRuPoll pollRequest:response];
    
  }).then(^id(OMNMailRuPoll *poll) {
    
    if (poll.registered) {
      
      return poll.card_id;
      
    }
    else {
      
      return poll.error;
      
    }
    
  });
  
}

+ (PMKPromise *)registerCardWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user {
  return [self registerCard:[OMNMailRuCard cardWithPan:pan exp_date:exp_date cvv:cvv] user:user];
}

+ (PMKPromise *)verifyCardWithID:(NSString *)cardID user:(OMNMailRuUser *)user amount:(NSNumber *)amount {
  
  OMNMailRuCardVerifyTransaction *transaction = [[OMNMailRuCardVerifyTransaction alloc] initWithCard:[OMNMailRuCard cardWithID:cardID] user:user order:[OMNMailRuOrder orderWithID:@"0" amount:amount] extra:nil];
  NSDictionary *verifyParameters = [transaction parametersWithConfig:_config];
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if ([transaction.order.amount doubleValue] <= 0.0) {
      reject([NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeCardAmount userInfo:nil]);
      return;
    }

    [[OMNMailRuAcquiring acquiring] POST:@"card/verify" parameters:verifyParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if (responseObject[@"error"]) {
        
        reject([OMNMailRuError omn_errorFromRequest:verifyParameters response:responseObject]);
        
      }
      else {
      
        fulfill(responseObject);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([OMNMailRuError omn_errorWithRequest:verifyParameters responseOperation:operation]);
      
    }];
    
  }];
  
}

+ (PMKPromise *)payAndRegisterWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user {
  
  OMNMailRuCard *card = [OMNMailRuCard cardWithPan:pan exp_date:exp_date cvv:cvv];
  card.add = YES;
  OMNMailRuPaymentTransaction *transaction = [[OMNMailRuPaymentTransaction alloc] initWithCard:card user:user order:[OMNMailRuOrder orderWithID:@"0" amount:@(1)] extra:nil];
  return [self pay:transaction];
  
}

+ (PMKPromise *)payWithCardID:(NSString *)cardID user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount extra:(OMNMailRuExtra *)extra {
  
  OMNMailRuPaymentTransaction *transaction = [[OMNMailRuPaymentTransaction alloc] initWithCard:[OMNMailRuCard cardWithID:cardID] user:user order:[OMNMailRuOrder orderWithID:order_id amount:order_amount] extra:extra];
  return [self pay:transaction];
  
}

+ (PMKPromise *)payWithCard:(OMNMailRuCard *)card user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount extra:(OMNMailRuExtra *)extra {
  
  OMNMailRuPaymentTransaction *transaction = [[OMNMailRuPaymentTransaction alloc] initWithCard:card user:user order:[OMNMailRuOrder orderWithID:order_id amount:order_amount] extra:extra];
  return [self pay:transaction];

}

+ (PMKPromise *)payWithWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount extra:(OMNMailRuExtra *)extra {
  
  OMNMailRuPaymentTransaction *transaction = [[OMNMailRuPaymentTransaction alloc] initWithCard:[OMNMailRuCard cardWithPan:pan exp_date:exp_date cvv:cvv] user:user order:[OMNMailRuOrder orderWithID:order_id amount:order_amount] extra:extra];
  return [self pay:transaction];
  
}

+ (PMKPromise *)pay:(OMNMailRuPaymentTransaction *)transaction {
  
  if (!transaction.card.valid) {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
      reject([NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:nil]);
    }];
  }
  
  NSDictionary *payParameters = [transaction parametersWithConfig:_config];
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (!payParameters) {
      reject([NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:nil]);
      return;
    }
    
    __weak typeof(self)weakSelf = self;
    [[OMNMailRuAcquiring acquiring] POST:@"order/pay" parameters:payParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      fulfill(responseObject);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([OMNMailRuError omn_errorWithRequest:payParameters responseOperation:operation]);
      
    }];
    
  }].then(^(NSDictionary *response) {
    
    return [OMNMailRuPoll pollRequest:response];
    
  }).then(^id(OMNMailRuPoll *poll) {
    
    if (poll.paid) {
      return poll;
    }
    else if (poll.require3ds) {
      return [self enter3DSWithPoll:poll];
    }
    else {
      return poll.error;
    }
    
  });
  
}

+ (NSDictionary *)refundParametersWithOrderID:(NSString *)orderID {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config.merch_id,
    @"vterm_id" : _config.vterm_id,
    @"order_id" : orderID,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_mailRuSignatureWithSecret:_config.secret_key];
  return [parameters copy];
  
}

+ (PMKPromise *)refundOrder:(NSString *)orderID {
  
  NSString *refundParameters = [self refundParametersWithOrderID:orderID];
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNMailRuAcquiring acquiring] POST:@"order/refund" parameters:refundParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      fulfill(responseObject);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([OMNMailRuError omn_errorWithRequest:refundParameters responseOperation:operation]);
      
    }];
    
  }].then(^(NSDictionary *response) {
    
    return [OMNMailRuPoll pollRequest:response];
    
  }).then(^id(OMNMailRuPoll *poll) {
    
#warning TODO: check refund error
    if (kMailRuPollStatusOK_REFUND_FINISH == poll.status) {
      return poll;
    }
    else {
      return poll.error;
    }
    
  });
  
}

+ (PMKPromise *)deleteCardWithID:(NSString *)cardID user:(OMNMailRuUser *)user {
  
  if (!cardID) {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
      reject([NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:nil]);
    }];
  }
  
  OMNMailRuCardDeleteTransaction *transaction = [[OMNMailRuCardDeleteTransaction alloc] initWithCard:[OMNMailRuCard cardWithID:cardID] user:user order:nil extra:nil];
  NSDictionary *deleteParameters = [transaction parametersWithConfig:_config];
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNMailRuAcquiring acquiring] POST:@"card/delete" parameters:deleteParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if ([responseObject[@"status"] isEqualToString:@"OK"]) {
        
        fulfill(responseObject);
        
      }
      else {
        
        reject([OMNMailRuError omn_errorFromRequest:deleteParameters response:responseObject]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([OMNMailRuError omn_errorWithRequest:deleteParameters responseOperation:operation]);
      
    }];
    
  }];
  
}

+ (PMKPromise *)enter3DSWithPoll:(OMNMailRuPoll *)pollResponse {
  
  UIViewController *topMostController = [self topMostController];
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {

    OMNMailRu3DSConfirmVC *mailRu3DSConfirmVC = [[OMNMailRu3DSConfirmVC alloc] initWithPollResponse:pollResponse];
    [mailRu3DSConfirmVC setDidFinishBlock:^(NSDictionary *response, NSError *error) {
      
      [topMostController dismissViewControllerAnimated:YES completion:nil];
      if (error) {
        reject(error);
      }
      else {
        fulfill(pollResponse);
      }
      
    }];
    [topMostController presentViewController:[[UINavigationController alloc] initWithRootViewController:mailRu3DSConfirmVC] animated:YES completion:nil];

  }];
  
}

+ (UIViewController*)topMostController {
  
  UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
  while (topController.presentedViewController) {
    topController = topController.presentedViewController;
  }
  return topController;
  
}

@end
