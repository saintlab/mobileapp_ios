//
//  OMNUser.m
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"

@implementation OMNUser

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    self.id = [data[@"id"] omn_stringValueSafe];
    self.name = [data[@"name"] omn_stringValueSafe];
    self.email = [data[@"email"] omn_stringValueSafe];
    self.phone = [data[@"phone"] omn_stringValueSafe];
    self.status = [data[@"status"] omn_stringValueSafe];
    self.created_at = [data[@"created_at"] omn_stringValueSafe];
    self.avatar = [data[@"avatar"] omn_stringValueSafe];
    
    NSString *birth_date = [data[@"birth_date"] omn_stringValueSafe];
    if (birth_date.length) {
      
      self.birthDate = [[self birthDateFormatter] dateFromString:birth_date];
      
    }

  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  
  OMNUser *user = [[[self class] allocWithZone:zone] init];
  user.id = [self.id copyWithZone:zone];
  user.name = [self.name copyWithZone:zone];
  user.email = [self.email copyWithZone:zone];
  user.phone = [self.phone copyWithZone:zone];
  user.status = [self.status copyWithZone:zone];
  user.created_at = [self.created_at copyWithZone:zone];
  user.birthDate = [self.birthDate copyWithZone:zone];
  user.avatar = [self.avatar copyWithZone:zone];
  user.image = self.image;
  return user;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.id = [aDecoder decodeObjectForKey:@"id"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
    self.status = [aDecoder decodeObjectForKey:@"status"];
    self.birthDate = [aDecoder decodeObjectForKey:@"birthDate"];
    self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  
  [aCoder encodeObject:self.id forKey:@"id"];
  [aCoder encodeObject:self.name forKey:@"name"];
  [aCoder encodeObject:self.email forKey:@"email"];
  [aCoder encodeObject:self.phone forKey:@"phone"];
  [aCoder encodeObject:self.status forKey:@"status"];
  [aCoder encodeObject:self.birthDate forKey:@"birthDate"];
  [aCoder encodeObject:self.avatar forKey:@"avatar"];
  
}

- (NSDateFormatter *)birthDateFormatter {
  
  static NSDateFormatter *dateFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
  });
  
  return dateFormatter;
  
}

- (NSString *)birthDateString {
  
  if (self.birthDate) {
    
    return [[self birthDateFormatter] stringFromDate:self.birthDate];
    
  }
  else {
    
    return @"";
    
  }
  
}

+ (instancetype)userWithPhone:(NSString *)phone {
  
  OMNUser *user = [[OMNUser alloc] init];
  user.phone = phone;
  return user;
  
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
  NSTextCheckingResult *result = (NSTextCheckingResult *) [matches firstObject];
  
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

