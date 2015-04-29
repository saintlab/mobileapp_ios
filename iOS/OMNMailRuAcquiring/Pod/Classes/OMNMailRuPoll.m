//
//  OMNMailRuPollResponse.m
//  Pods
//
//  Created by tea on 19.04.15.
//
//

#import "OMNMailRuPoll.h"
#import "OMNMailRuAcquiring.h"

@implementation OMNMailRuPoll

OMNMailRuPollStatus statusFromString(NSString *string) {
 
  if (0 == string.length) {
    return kMailRuPollStatusNONE;
  }
  
  static NSDictionary *statuses = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    statuses =
    @{
      @"OK_CONTINUE" : @(kMailRuPollStatusOK_CONTINUE),
      @"OK_FINISH" : @(kMailRuPollStatusOK_FINISH),
      @"OK_REFUND_FINISH" : @(kMailRuPollStatusOK_REFUND_FINISH),
      @"ERR_FINISH" : @(kMailRuPollStatusERR_FINISH),
      };
  });
  
  return [statuses[string] integerValue];
  
}

- (instancetype)initWithRequest:(NSDictionary *)request response:(NSDictionary *)response {
  self = [super init];
  if (self) {

    _response = response;
    _request = request;
    _status = statusFromString(response[@"status"]);
    _card_id = request[@"card_id"];
    _order_id = response[@"order_id"];
    _registered = (_status == kMailRuPollStatusOK_FINISH && _card_id);
    NSDictionary *threeds_data = response[@"threeds_data"];
    NSString *acs_url = response[@"acs_url"];
    _require3ds = (_status == kMailRuPollStatusOK_FINISH && acs_url && threeds_data);
    NSString *order_status = response[@"order_status"];
    _paid = (kMailRuPollStatusOK_FINISH == _status && [order_status isEqualToString:@"PAID"]);
    
    if (_require3ds) {

      NSString *query = [OMNMailRuPoll queryStringFromParams:threeds_data];
      NSString *urlString = [NSString stringWithFormat:@"%@?%@", acs_url, query];
      _request3dsURL = [NSURL URLWithString:urlString];

    }
    
    if (kMailRuPollStatusERR_FINISH == _status) {
      
      _error = [OMNMailRuError omn_errorFromRequest:request response:response];
      
    }
    
  }
  return self;
}

+ (PMKPromise *)pollRequest:(NSDictionary *)request {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [self pollRequest:request time:0 withCompletion:^(OMNMailRuPoll *poll) {
      
      fulfill(poll);
      
    } failure:reject];
    
  }];
  
}

+ (void)pollRequest:(NSDictionary *)request time:(NSInteger)time withCompletion:(void(^)(OMNMailRuPoll *poll))completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSDictionary *error = request[@"error"];
  if (error) {
    failureBlock([OMNMailRuError omn_errorFromRequest:nil response:request]);
    return;
  }
  
  NSString *url = request[@"url"];
  if (![url isKindOfClass:[NSString class]]) {
    return;
  }
  
  [[OMNMailRuAcquiring acquiring] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    OMNMailRuPoll *poll = [[OMNMailRuPoll alloc] initWithRequest:request response:responseObject];
    if (kMailRuPollStatusOK_CONTINUE == poll.status) {

      if (time > kPollRequestsCountMax) {
        failureBlock([NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeTimeout userInfo:nil]);
      }
      else {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
          [self pollRequest:request time:(time + 1) withCompletion:completionBlock failure:failureBlock];
          
        });
        
      }

    }
    else {
      
      completionBlock(poll);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock([OMNMailRuError omn_errorWithRequest:request responseOperation:operation]);
    
  }];
  
}

static NSString *const kCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

+ (NSString *)escapeString:(NSString *)value {
  return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef) value, NULL, (__bridge CFStringRef) kCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

+ (NSString *)queryStringFromParams:(NSDictionary *)params {
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:params.count];
  for (NSString *key in params) {
    if ([params[key] isKindOfClass:[NSString class]])
      [array addObject:[NSString stringWithFormat:@"%@=%@", key, [self escapeString:params[key]]]];
    else
      [array addObject:[NSString stringWithFormat:@"%@=%@", key, params[key]]];
  }
  return [array componentsJoinedByString:@"&"];
}

@end
