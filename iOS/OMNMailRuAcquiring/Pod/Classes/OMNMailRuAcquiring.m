//
//  OMNMailRuAcquiring.m
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNMailRuAcquiring.h"
#import <PromiseKit.h>

NSString *const OMNMailRuErrorDomain = @"OMNMailRuErrorDomain";

static OMNMailRuConfig *_config = nil;

@interface AFHTTPRequestOperation (omn_mailRu)

- (NSDictionary *)omn_errorResponse;

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

- (void)registerCard:(NSDictionary *)cardInfo user_login:(NSString *)user_login user_phone:(NSString *)user_phone completion:(void(^)(NSString *cardId))completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config.merch_id,
    @"vterm_id" : _config.vterm_id,
    @"user_login" : user_login,
    };
#warning TODO card
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_mailRuSignatureWithSecret:_config.secret_key];
  parameters[@"cardholder"] = _config.cardholder;
  parameters[@"user_phone"] = user_phone;
  
  [parameters addEntriesFromDictionary:cardInfo];
  
  __weak typeof(self)weakSelf = self;
  [self POST:@"card/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"url"]) {
      
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf checkCardRegisterResponse:responseObject withCompletion:completionBlock failure:failureBlock];
      
    }
    else {
      
      failureBlock(nil, parameters, responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error, parameters, nil);
    
  }];
  
}

- (void)checkCardRegisterResponse:(id)response withCompletion:(void(^)(NSString *cardId))completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
  __weak typeof(self)weakSelf = self;
  NSString *url = response[@"url"];
  NSString *cardID = response[@"card_id"];
  
  [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSString *status = responseObject[@"status"];
    if ([status isEqualToString:@"OK_CONTINUE"]) {
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf checkCardRegisterResponse:response withCompletion:completionBlock failure:failureBlock];
        
      });
      
    }
    else if([status isEqualToString:@"OK_FINISH"] &&
            cardID) {
      
      completionBlock(cardID);
      
    }
    else {
      
      failureBlock([NSError omn_errorFromRequest:response response:responseObject], response, responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error, response, nil);
    
  }];
  
}

NSError *errorWithCode(OMNMailRuErrorCode code) {
  
  return [NSError errorWithDomain:OMNMailRuErrorDomain code:code userInfo:nil];
  
}

- (void)verifyCard:(NSString *)card_id user_login:(NSString *)user_login amount:(double)amount completion:(dispatch_block_t)completionBlock  failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
  NSAssert(completionBlock != nil, @"cardVerify completionBlock is nil");
  NSAssert(failureBlock != nil, @"cardVerify failureBlock is nil");
  
  if (amount <= 0.0) {
    failureBlock(errorWithCode(kOMNMailRuErrorCodeCardAmount), nil, nil);
    return;
  }

  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config.merch_id,
    @"vterm_id" : _config.vterm_id,
    @"user_login" : user_login,
    @"card_id" : card_id,
    };

  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = [reqiredSignatureParams omn_mailRuSignatureWithSecret:_config.secret_key];
  parameters[@"amount"] = @(amount);
  
  __weak typeof(self)weakSelf = self;
  
  [self POST:@"card/verify" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

    if (responseObject[@"error"]) {
      
      failureBlock([NSError omn_errorFromRequest:parameters response:responseObject], parameters, responseObject);
      
    }
    else {
      
      completionBlock();
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error, parameters, nil);
    
  }];
  
}

- (void)pollUrl:(NSString *)url time:(NSInteger)time withCompletion:(void(^)(id response))completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  __weak typeof(self)weakSelf = self;
  [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSString *status = responseObject[@"status"];
    if ([status isEqualToString:@"OK_CONTINUE"]) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf pollUrl:url time:(time + 1) withCompletion:completionBlock failure:failureBlock];
        
      });
    }
    else if(time > 20) {
      
      failureBlock([NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:nil]);
      
    }
    else {
      
      completionBlock(responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

- (PMKPromise *)poll:(NSString *)url {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [self pollUrl:url time:0 withCompletion:^(id response) {
      
      fulfill(response);
      
    } failure:^(NSError *error) {
      
      reject(error);
      
    }];
    
  }];

}

- (PMKPromise *)payWithInfo:(OMNMailRuPaymentInfo *)paymentInfo {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    NSDictionary *parameters = [paymentInfo payParametersWithConfig:_config];
    if (!parameters) {
      reject(errorWithCode(kOMNMailRuErrorCodeUnknown));
      return;
    }
    
    __weak typeof(self)weakSelf = self;
    [self POST:@"order/pay" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      NSString *pollURL = responseObject[@"url"];
      if (pollURL && !responseObject[@"error"]) {
        
        fulfill(pollURL);

      }
      else {
        
        reject([NSError omn_errorFromRequest:parameters response:responseObject]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      reject(error);
    }];
    
  }];
  
}

- (void)payWithInfo:(OMNMailRuPaymentInfo *)paymentInfo completion:(void(^)(id response))completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {

  [self payWithInfo:paymentInfo].then(^(NSString *pollURL) {
    
    return [self poll:pollURL];
    
  }).then(^(NSDictionary *response) {
    
    NSString *status = response[@"status"];
    NSString *order_status = response[@"order_status"];
    if ([status isEqualToString:@"OK_FINISH"] &&
        [order_status isEqualToString:@"PAID"]) {
      
      completionBlock(response);
      
    }
    else {
      
      failureBlock([NSError omn_errorFromRequest:nil response:response], nil, nil);
      
    }
    
  }).catch(^(NSError *error) {
    
    failureBlock(error, nil, nil);
    
  });
  
}

- (NSDictionary *)refundParametersWithOrderID:(NSString *)orderID {
  
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

- (PMKPromise *)refundOrder:(NSString *)orderID {
  
  NSString *refundParameters = [self refundParametersWithOrderID:orderID];
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [self POST:@"order/refund" parameters:refundParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      NSString *pollURL = responseObject[@"url"];
      if (pollURL && !responseObject[@"error"]) {
        
        fulfill(pollURL);
        
      }
      else {
        
        reject([NSError omn_errorFromRequest:refundParameters response:responseObject]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject(error);
      
    }];
    
  }];
  
}

- (void)refundOrder:(NSString *)orderID completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
  NSAssert(orderID != nil, @"order id should not be nil");
  
  [self refundOrder:orderID].then(^(NSString *pollURL) {
    
    return [self poll:pollURL];
    
  }).then(^(NSDictionary *response) {
    
    NSString *status = response[@"status"];
    if ([status isEqualToString:@"OK_REFUND_FINISH"]) {
      
      completionBlock();
      
    }
    else {
      
      failureBlock([NSError omn_errorFromRequest:nil response:response], nil, nil);
      
    }
    
  }).catch(^(NSError *error) {
    
    failureBlock(error, nil, nil);
    
  });
  
}

- (NSDictionary *)deleteCardParametersWithCardID:(NSString *)card_id user_login:(NSString *)user_login {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config.merch_id,
    @"vterm_id" : _config.vterm_id,
    @"card_id" : card_id,
    @"user_login" : user_login,
    };
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_mailRuSignatureWithSecret:_config.secret_key];
  return [parameters copy];
  
}

- (void)deleteCard:(NSString *)card_id user_login:(NSString *)user_login сompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {

  NSAssert(card_id, @"card id should not be nil");
  NSAssert(user_login, @"user_login should not be nil");
  
  NSDictionary *deleteCardParameters = [self deleteCardParametersWithCardID:card_id user_login:user_login];
  
  [self POST:@"card/delete" parameters:deleteCardParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject[@"status"] isEqualToString:@"OK"]) {
      
      completionBlock();
      
    }
    else {
      
      failureBlock([NSError omn_errorFromRequest:deleteCardParameters response:responseObject], deleteCardParameters, responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    failureBlock(error, deleteCardParameters, nil);
    
  }];
  
}

@end

@implementation AFHTTPRequestOperation (omn_mailRu)

- (NSDictionary *)omn_errorResponse {
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  parametrs[@"error"] = (self.error.localizedDescription) ? (self.error.localizedDescription) : (@"");
  if (self.responseString) {
    parametrs[@"response_string"] = self.responseString;
  }
  return parametrs;
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
    if (description) {
      
      NSInteger code = kOMNMailRuErrorCodeDefault;
      if ([codeString isEqualToString:@"ERR_CARD_AMOUNT"]) {
        
        code = kOMNMailRuErrorCodeCardAmount;
        
      }
      userInfo[NSLocalizedDescriptionKey] = description;
      error = [NSError errorWithDomain:OMNMailRuErrorDomain code:code userInfo:userInfo];
      
    }
    else {
      
      error = [NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:userInfo];
      
    }
    
  }
  
  return error;
  
}

@end
