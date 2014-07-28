//
//  OMNUser.m
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import "OMNAuthorizationManager.h"

@implementation OMNUser

- (instancetype)initWithData:(id)data {
  self = [super init];
  if (self) {
    self.name = [data[@"first_name"] description];
    self.email = [data[@"email"] description];
    self.phone = [data[@"phone"] description];
    self.status = [data[@"status"] description];
//    self.birthDate = data[@"birth_date"];

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
  
  if (self.name.length) {
    parameters[@"firstName"] = self.name;
    parameters[@"name"] = self.name;
  }
  
  if (self.birthDate) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:locale];
    [df setDateFormat:@"dd-MM-yyyy"];
    parameters[@"birthDate"] = [df stringFromDate:self.birthDate];
  }
  
  [[OMNAuthorizationManager sharedManager] POST:@"register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

    NSLog(@"%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    NSLog(@"registerWithComplition>%@", responseObject);
    if ([responseObject[@"status"] isEqualToString:@"registered"]) {
      complition();
    }
    else {
      failureBlock([NSError errorWithDomain:NSStringFromClass(self.class) code:0 userInfo:@{NSLocalizedDescriptionKey : [responseObject description]}]);
    }
    
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"registerWithComplition>%@", error);
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

+ (void)loginUsingData:(NSString *)data code:(NSString *)code complition:(OMNTokenBlock)complition failure:(OMNErrorBlock)failureBlock {
  
  NSAssert(complition != nil, @"complition block is nil");
  NSAssert(failureBlock != nil, @"failureBlock block is nil");
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
  if (code.length) {
    parameters[@"code"] = code;
  }
  
  if ([data omn_isValidPhone]) {
    parameters[@"phone"] = data;
  }
  else if ([data omn_isValidEmail]) {
    parameters[@"email"] = data;
  }
  else {
    
    failureBlock([NSError errorWithDomain:NSStringFromClass(self.class)
                                     code:0
                                 userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"Неправильная почта или телефон", nil)}]);
    return;
    
  }
  
  [self loginWithParameters:parameters complition:complition failure:failureBlock];
  
}

+ (void)loginWithParameters:(NSDictionary *)parameters complition:(OMNTokenBlock)complition failure:(OMNErrorBlock)failureBlock {
  
  [[OMNAuthorizationManager sharedManager] POST:@"authorization" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [responseObject decodeToken:complition failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

+ (void)userWithToken:(NSString *)token user:(OMNUserBlock)userBlock failure:(OMNErrorBlock)failureBlock {
  
  NSDictionary *parameters =
  @{
    @"token" : token,
    };
  
  [[OMNAuthorizationManager sharedManager] POST:@"/user" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
//    NSLog(@"user>>%@", responseObject);
    if ([responseObject[@"status"] isEqualToString:@"success"]) {
      
      OMNUser *user = [[OMNUser alloc] initWithData:responseObject[@"user"]];
      userBlock(user);
      
    }
    else {

      failureBlock(nil);
      
    }
    
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

- (BOOL) omn_isValidEmail {
  
  NSString *emailRegex =
  @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
  @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
  @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
  @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
  @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
  @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
  @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
  
  return [emailTest evaluateWithObject:self];
}




@end

