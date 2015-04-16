//
//  OMNMailRuPaymentInfo.h
//  Pods
//
//  Created by tea on 11.08.14.
//
//

#import <Foundation/Foundation.h>

@class OMNMailRuExtra;
@class OMNMailRuCardInfo;
@class OMNMailRuConfig;
@class OMNMailRuUser;
@class OMNMailRuOrder;

@interface OMNMailRuTransaction : NSObject

@property (nonatomic, strong) OMNMailRuExtra *extra;
@property (nonatomic, strong) OMNMailRuCardInfo *cardInfo;
@property (nonatomic, strong) OMNMailRuUser *user;
@property (nonatomic, strong) OMNMailRuOrder *order;

- (NSDictionary *)payParametersWithConfig:(OMNMailRuConfig *)config;
- (NSDictionary *)registerCardParametersWithConfig:(OMNMailRuConfig *)config;

@end

@interface OMNMailRuOrder : NSObject

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, strong, readonly) NSNumber *amount;

- (instancetype)initWithID:(NSString *)id amount:(NSNumber *)amount;
+ (instancetype)orderWithID:(NSString *)id amount:(NSNumber *)amount;

@end

@interface OMNMailRuExtra : NSObject

@property (nonatomic, assign, readonly) long long tip;
@property (nonatomic, copy, readonly) NSString *restaurant_id;
@property (nonatomic, copy, readonly) NSString *type;

- (instancetype)initWithRestaurantID:(NSString *)restaurantID tipAmount:(long long)tipAmount type:(NSString *)type;
+ (instancetype)extraWithRestaurantID:(NSString *)restaurantID tipAmount:(long long)tipAmount type:(NSString *)type;
- (NSString *)extra_text;

@end

@interface OMNMailRuCardInfo : NSObject

@property (nonatomic, copy) NSString *pan;
@property (nonatomic, copy) NSString *exp_date;
@property (nonatomic, copy) NSString *cvv;
@property (nonatomic, copy) NSString *card_id;
@property (nonatomic, assign) BOOL add_card;

@property (nonatomic, copy) NSString *user_login;
@property (nonatomic, copy) NSString *user_phone;

+ (NSString *)exp_dateFromMonth:(NSInteger)month year:(NSInteger)year;

+ (OMNMailRuCardInfo *)cardInfoWithCardId:(NSString *)card_id;
+ (OMNMailRuCardInfo *)cardInfoWithCardPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv;

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

+ (instancetype)configWithParametrs:(NSDictionary *)parametrs;
- (BOOL)isValid;

@end

@interface NSDictionary (omn_mailRu)

- (NSString *)omn_mailRuSignatureWithSecret:(NSString *)secret_key;

@end