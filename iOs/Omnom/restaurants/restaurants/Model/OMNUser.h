//
//  OMNUser.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNUser : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *password_hash;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) BOOL phone_validated;
@property (nonatomic, assign) BOOL email_validated;

- (instancetype)initWithData:(id)data;

@end
