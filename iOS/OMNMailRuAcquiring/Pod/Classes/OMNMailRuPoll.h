//
//  OMNMailRuPollResponse.h
//  Pods
//
//  Created by tea on 19.04.15.
//
//

#import <Foundation/Foundation.h>
#import <PromiseKit.h>

#define kPollRequestsCountMax 20

typedef NS_ENUM(NSInteger, OMNMailRuPollStatus) {
  kMailRuPollStatusNONE = 0,
  kMailRuPollStatusOK_CONTINUE,
  kMailRuPollStatusOK_FINISH,
  kMailRuPollStatusOK_REFUND_FINISH,
  kMailRuPollStatusERR_FINISH,
};

@interface OMNMailRuPoll : NSObject

@property (nonatomic, assign, readonly) OMNMailRuPollStatus status;
@property (nonatomic, copy, readonly) NSString *card_id;
@property (nonatomic, copy, readonly) NSString *order_id;
@property (nonatomic, assign, readonly) BOOL require3ds;
@property (nonatomic, assign, readonly) BOOL paid;
@property (nonatomic, assign, readonly) BOOL registered;
@property (nonatomic, strong, readonly) NSURL *request3dsURL;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) NSDictionary *request;
@property (nonatomic, strong, readonly) NSDictionary *response;

- (instancetype)initWithRequest:(NSDictionary *)request response:(NSDictionary *)response;
+ (PMKPromise *)pollRequest:(NSDictionary *)request;

@end
