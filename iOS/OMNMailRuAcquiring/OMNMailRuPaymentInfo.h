//
//  OMNMailRuPaymentInfo.h
//  Pods
//
//  Created by tea on 11.08.14.
//
//

#import <Foundation/Foundation.h>

@class OMNMailRuExtra;

@interface OMNMailRuPaymentInfo : NSObject

@property (nonatomic, strong) OMNMailRuExtra *extra;

@end

@interface OMNMailRuExtra : NSObject

@property (nonatomic, strong) NSNumber *tip;
@property (nonatomic, copy) NSString *restaurant_id;

@end

