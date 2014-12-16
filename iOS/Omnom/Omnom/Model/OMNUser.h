//
//  OMNUser.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConstants.h"

@class OMNUser;

typedef void(^OMNUserBlock)(OMNUser *user);

@interface OMNUser : NSObject
<NSCopying>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy, readonly) NSString *birthDateString;
@property (nonatomic, copy) NSDate *birthDate;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL phone_validated;
@property (nonatomic, assign) BOOL email_validated;

+ (instancetype)userWithPhone:(NSString *)phone;

- (instancetype)initWithJsonData:(id)data;

@end

@interface NSString (omn_validPhone)

- (BOOL)omn_isValidPhone;
- (BOOL)omn_isValidEmail;

@end

