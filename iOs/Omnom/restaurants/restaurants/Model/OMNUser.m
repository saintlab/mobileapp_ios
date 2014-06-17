//
//  OMNUser.m
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import "OMNAuthorizationManager.h"

@interface NSString (omn_validPhone)

- (BOOL)omn_isValidPhone;

@end

@implementation OMNUser

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    self.firstName = data[@"firstName"];
    self.lastName = data[@"lastName"];
    self.nickName = data[@"nickName"];
    self.email = data[@"email"];
    self.phone = data[@"phone"];
    self.password = data[@"password"];
    self.password_hash = data[@"password_hash"];
    self.status = data[@"status"];
    self.phone_validated = [data[@"phone_validated"] boolValue];
    self.email_validated = [data[@"email_validated"] boolValue];
  }
  return self;
}

+ (instancetype)userWithPhone:(NSString *)phone {
  
  OMNUser *user = [[OMNUser alloc] init];
  user.phone = phone;
  return user;
  
}

- (void)registerWithComplition:(dispatch_block_t)complition failure:(OMNErrorBlock)failureBlock {
  
  NSAssert(complition != nil, @"complition block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  if (0 == self.email.length ||
      0 == self.phone.length) {
    
    failureBlock([NSError errorWithDomain:NSStringFromClass(self.class)
                                     code:0
                                 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"Введите почту и телефон", nil)}]);
    return;
  }
  
  NSMutableDictionary *parameters =
  [@{
     @"installId" : [OMNAuthorisation authorisation].installId,
     @"email" : self.email,
     @"phone" : self.phone,
     } mutableCopy];
  
  if (self.firstName.length) {
    parameters[@"firstName"] = self.firstName;
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"responseObject>%@", responseObject);
    
    OMNUser *user = [[OMNUser alloc] initWithData:responseObject];
    complition();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

- (void)confirmPhone:(NSString *)code complition:(OMNTokenBlock)complition failure:(OMNErrorBlock)failureBlock {
  
  NSAssert(complition != nil, @"complition block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  NSDictionary *parameters =
  @{
    @"phone" : self.phone,
    @"code" : code,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/confirm/phone" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:complition failure:failureBlock];

  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

- (void)confirmPhoneResend:(dispatch_block_t)complition failure:(OMNErrorBlock)failureBlock {
  
  NSAssert(complition != nil, @"complition block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");

  NSDictionary *parameters =
  @{
    @"phone" : self.phone,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/confirm/phone/resend" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"responseObject%@", responseObject);
    complition();
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

+ (void)loginUsingPhone:(NSString *)phone code:(NSString *)code complition:(OMNTokenBlock)complition failure:(OMNErrorBlock)failureBlock {
 
  NSAssert(complition != nil, @"complition block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  if (NO == phone.omn_isValidPhone) {
    
    failureBlock([NSError errorWithDomain:NSStringFromClass(self.class)
                                     code:0
                                 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"Неправильный телефон", nil)}]);
    return;
  }
  
  NSMutableDictionary *parameters =
  [@{
     @"phone" : phone,
     } mutableCopy];
  
  if (code.length) {
    parameters[@"code"] = code;
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"/authorization" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:complition failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

@end

@implementation NSString (omn_validPhone)

- (BOOL)omn_isValidPhone {
  
  NSError *error = NULL;
  NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
  
  NSRange inputRange = NSMakeRange(0, [self length]);
  NSArray *matches = [detector matchesInString:self options:0 range:inputRange];
  
  // no match at all
  if ([matches count] == 0) {
    return NO;
  }
  
  // found match but we need to check if it matched the whole string
  NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
  
  if ([result resultType] == NSTextCheckingTypePhoneNumber &&
      result.range.location == inputRange.location &&
      result.range.length == inputRange.length) {
    // it matched the whole string
    return YES;
  }
  else {
    // it only matched partial string
    return NO;
  }
  
}

@end

