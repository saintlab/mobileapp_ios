//
//  OMNMailRuPaymentInfo.h
//  Pods
//
//  Created by tea on 11.08.14.
//
//

#import <Foundation/Foundation.h>

@class OMNMailRuExtra;
@class OMNMailRuCard;
@class OMNMailRuConfig;
@class OMNMailRuUser;
@class OMNMailRuOrder;

@interface OMNMailRuTransaction : NSObject

@property (nonatomic, strong) OMNMailRuExtra *extra;
@property (nonatomic, strong, readonly) OMNMailRuCard *card;
@property (nonatomic, strong, readonly) OMNMailRuUser *user;
@property (nonatomic, strong, readonly) OMNMailRuOrder *order;

- (instancetype)initWithCard:(OMNMailRuCard *)card user:(OMNMailRuUser *)user order:(OMNMailRuOrder *)order extra:(OMNMailRuExtra *)extra;
- (NSDictionary *)parametersWithConfig:(OMNMailRuConfig *)config;

@end

@interface OMNMailRuPaymentTransaction : OMNMailRuTransaction
@end

@interface OMNMailRuCardDeleteTransaction : OMNMailRuTransaction
@end

@interface OMNMailRuCardRegisterTransaction : OMNMailRuTransaction
@end

@interface OMNMailRuCardVerifyTransaction : OMNMailRuTransaction

@end

@interface OMNMailRuOrder : NSObject

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, strong, readonly) NSNumber *amount;

+ (instancetype)orderWithID:(NSString *)id amount:(NSNumber *)amount;

@end

@interface OMNMailRuExtra : NSObject

@property (nonatomic, assign, readonly) long long tip;
@property (nonatomic, copy, readonly) NSString *restaurant_id;
@property (nonatomic, copy, readonly) NSString *type;

+ (instancetype)extraWithRestaurantID:(NSString *)restaurantID tipAmount:(long long)tipAmount type:(NSString *)type;
- (NSString *)text;

@end

@interface OMNMailRuCard : NSObject

@property (nonatomic, copy) NSString *pan;
@property (nonatomic, copy) NSString *exp_date;
@property (nonatomic, copy) NSString *cvv;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL add;

+ (NSString *)exp_dateFromMonth:(NSInteger)month year:(NSInteger)year;

+ (OMNMailRuCard *)cardWithID:(NSString *)card_id;
+ (OMNMailRuCard *)cardWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv;
- (BOOL)valid;
- (NSDictionary *)parameters;

@end

@interface OMNMailRuUser : NSObject

@property (nonatomic, copy, readonly) NSString *login;
@property (nonatomic, copy, readonly) NSString *phone;

+ (instancetype)userWithLogin:(NSString *)login phone:(NSString *)phone;

@end

@interface OMNMailRuConfig : NSObject

@property (nonatomic, copy, readonly) NSString *merch_id;
@property (nonatomic, copy, readonly) NSString *vterm_id;
@property (nonatomic, copy, readonly) NSString *secret_key;
@property (nonatomic, copy, readonly) NSString *cardholder;
@property (nonatomic, copy, readonly) NSString *baseURL;
@property (nonatomic, assign, readonly) BOOL use_3ds;

+ (instancetype)configWithParametrs:(NSDictionary *)parametrs;
- (BOOL)isValid;

@end

@interface NSDictionary (omn_mailRu)

- (NSString *)omn_mailRuSignatureWithSecret:(NSString *)secret_key;

@end