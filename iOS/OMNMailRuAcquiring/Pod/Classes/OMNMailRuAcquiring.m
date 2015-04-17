//
//  OMNMailRuAcquiring.m
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNMailRuAcquiring.h"

NSString *const OMNMailRuErrorDomain = @"OMNMailRuErrorDomain";

static OMNMailRuConfig *_config = nil;

@interface AFHTTPRequestOperation (omn_mailRu)

- (NSDictionary *)omn_errorResponse;

@end

@interface NSDictionary (omn_mailRuResponse)

- (BOOL)omn_refundResponseSuccess;
- (BOOL)omn_paidResponseSuccess;
- (BOOL)omn_registerCardResponseSuccessWithcardID:(NSString *)cardID;

@end

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
      
      reject([NSError omn_errorFromRequest:registerParameters response:[operation omn_errorResponse]]);
      
    }];
    
  }].then(^(NSDictionary *response) {
    
    return [self pollResponse:response];
    
  }).then(^id(NSDictionary *response, NSDictionary *pollResponse) {
    
    NSString *cardID = response[@"card_id"];
    if ([pollResponse omn_registerCardResponseSuccessWithcardID:cardID]) {
      
      return cardID;
      
    }
    else {
      
      return [NSError omn_errorFromRequest:response response:pollResponse];
      
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
        
        reject([NSError omn_errorFromRequest:verifyParameters response:responseObject]);
        
      }
      else {
      
        fulfill(responseObject);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([NSError omn_errorFromRequest:verifyParameters response:[operation omn_errorResponse]]);
      
    }];
    
  }];
  
}

- (void)pollResponse:(NSDictionary *)response time:(NSInteger)time withCompletion:(void(^)(id response))completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSString *url = response[@"url"];
  if (![url isKindOfClass:[NSString class]]) {
    failureBlock([NSError omn_errorFromRequest:response response:nil]);
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSString *status = responseObject[@"status"];
    if ([status isEqualToString:@"OK_CONTINUE"]) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf pollResponse:response time:(time + 1) withCompletion:completionBlock failure:failureBlock];
        
      });
    }
    else if(time > 20) {
      
      failureBlock([NSError omn_errorFromRequest:url response:responseObject]);
      
    }
    else {
      
      completionBlock(responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([NSError omn_errorFromRequest:url response:[operation omn_errorResponse]]);
    
  }];
  
}

+ (PMKPromise *)pollResponse:(NSDictionary *)response {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {

    [[OMNMailRuAcquiring acquiring] pollResponse:response time:0 withCompletion:^(id pollResponse) {
      
      fulfill(PMKManifold(response, pollResponse));

    } failure:reject];
    
  }];

}

+ (PMKPromise *)payWithInfo:(OMNMailRuTransaction *)paymentInfo {
  
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
      
      reject([NSError omn_errorFromRequest:payParameters response:[operation omn_errorResponse]]);
      
    }];
    
  }].then(^(NSDictionary *response) {
    
    return [self pollResponse:response];
    
  }).then(^id(NSDictionary *response, NSDictionary *pollResponse) {
    
    if ([pollResponse omn_paidResponseSuccess]) {
      
      return PMKManifold(response, pollResponse);
      
    }
    else {
      
      return [NSError omn_errorFromRequest:response response:pollResponse];
      
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
      
      reject([NSError omn_errorFromRequest:refundParameters response:[operation omn_errorResponse]]);
      
    }];
    
  }].then(^(NSDictionary *response) {
    
    return [self pollResponse:response];
    
  }).then(^id(NSDictionary *response, NSDictionary *pollResponse) {
    
    if ([pollResponse omn_refundResponseSuccess]) {
      
      return nil;
      
    }
    else {
      
      return [NSError omn_errorFromRequest:response response:pollResponse];
      
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
        
        reject([NSError omn_errorFromRequest:deleteParameters response:responseObject]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([NSError omn_errorFromRequest:deleteParameters response:[operation omn_errorResponse]]);
      
    }];
    
  }];
  
}

@end

@implementation NSError (mailRuError)

+ (NSError *)omn_errorFromRequest:(id)request response:(id)response {
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
  
  if (request) {
    userInfo[@"request"] = request;
  }
  if (response) {
    userInfo[@"response"] = response;
  }
  
  if (![response isKindOfClass:[NSDictionary class]] ||
      ![request isKindOfClass:[NSDictionary class]]) {
    return [NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:userInfo];
  }
  
  NSError *error = nil;
  if (response[@"error"]) {
    
    NSString *description = response[@"error"][@"descr"];
    NSString *codeString = response[@"error"][@"code"];
    NSInteger code = kOMNMailRuErrorCodeDefault;
    
    if (description) {
      
      if ([codeString isEqualToString:@"ERR_CARD_AMOUNT"]) {
        
        code = kOMNMailRuErrorCodeCardAmount;
        
      }
      userInfo[NSLocalizedDescriptionKey] = description;
      
    }
    
    error = [NSError errorWithDomain:OMNMailRuErrorDomain code:code userInfo:userInfo];
    
  }
  else {
    
    error = [NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:userInfo];
    
  }
  return error;
  
}

@end

@implementation AFHTTPRequestOperation (omn_mailRu)

- (NSDictionary *)omn_errorResponse {
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  parametrs[@"error"] = (self.error.userInfo) ? (self.error.userInfo) : (@"");
  if (self.responseString) {
    parametrs[@"response_string"] = self.responseString;
  }
  return parametrs;
}

@end

@implementation NSDictionary (omn_mailRuResponse)

- (BOOL)omn_refundResponseSuccess {
  
  NSString *status = self[@"status"];
  return [status isEqualToString:@"OK_REFUND_FINISH"];
  
}

- (BOOL)omn_paidResponseSuccess {
  
  NSString *status = self[@"status"];
  NSString *order_status = self[@"order_status"];
  return ([status isEqualToString:@"OK_FINISH"] && [order_status isEqualToString:@"PAID"]);
  
}

- (BOOL)omn_registerCardResponseSuccessWithcardID:(NSString *)cardID {
  
  NSString *status = self[@"status"];
  return ([status isEqualToString:@"OK_FINISH"] && cardID);
  
}

@end