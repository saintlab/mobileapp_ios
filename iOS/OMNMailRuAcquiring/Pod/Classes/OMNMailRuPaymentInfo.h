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

@interface OMNMailRuPaymentInfo : NSObject

@property (nonatomic, strong) OMNMailRuExtra *extra;
@property (nonatomic, strong) OMNMailRuCardInfo *cardInfo;

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *user_phone;
@property (nonatomic, strong) NSNumber *order_amount;
@property (nonatomic, copy) NSString *order_message;
@property (nonatomic, copy) NSString *user_login;

@end

@interface OMNMailRuExtra : NSObject

@property (nonatomic, assign) long long tip;
@property (nonatomic, copy) NSString *restaurant_id;

- (NSString *)extra_text;

@end

@interface OMNMailRuCardInfo : NSObject

@property (nonatomic, copy) NSString *pan;
@property (nonatomic, copy) NSString *exp_date;
@property (nonatomic, copy) NSString *cvv;
@property (nonatomic, copy) NSString *card_id;
@property (nonatomic, assign) BOOL add_card;

+ (OMNMailRuCardInfo *)cardInfoWithCardId:(NSString *)card_id cvv:(NSString *)cvv;
+ (OMNMailRuCardInfo *)cardInfoWithCardPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv;

- (NSDictionary *)card_info;

@end
