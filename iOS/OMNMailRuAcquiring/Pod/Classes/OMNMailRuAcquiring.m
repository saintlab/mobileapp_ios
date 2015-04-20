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


+ (PMKPromise *)registerCard:(OMNMailRuTransaction *)transaction {
  
  NSDictionary *registerParameters = [transaction registerCardParametersWithConfig:_config];
  
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


+ (PMKPromise *)verifyCard:(OMNMailRuTransaction *)transaction {
  
  NSDictionary *verifyParameters = [transaction verifyCardParametersWithConfig:_config];
  
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

+ (PMKPromise *)pay:(OMNMailRuTransaction *)paymentInfo {
  
  NSDictionary *payParameters = [paymentInfo payParametersWithConfig:_config];

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
      return poll.response;
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
      return nil;
    }
    else {
      return poll.error;
    }
    
  });
  
}

+ (PMKPromise *)deleteCard:(OMNMailRuTransaction *)transaction {
  
  NSDictionary *deleteParameters = [transaction deleteCardParameterWithConfig:_config];
  
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
        fulfill(response);
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
