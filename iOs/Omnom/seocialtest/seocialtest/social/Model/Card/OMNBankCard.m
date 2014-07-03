//
//  OMNBankCard.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"

@implementation OMNBankCard

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super init];
  if (self) {
    self.cardNumber = [aDecoder decodeObjectForKey:@"cardNumber"];
    self.expiryMonth = [[aDecoder decodeObjectForKey:@"expiryMonth"] unsignedIntegerValue];
    self.expiryYear = [[aDecoder decodeObjectForKey:@"expiryYear"] unsignedIntegerValue];
    //    self.cvv = [aDecoder decodeObjectForKey:@"cardNumber"];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.cardNumber forKey:@"cardNumber"];
  [aCoder encodeObject:@(self.expiryMonth) forKey:@"expiryMonth"];
  [aCoder encodeObject:@(self.expiryYear) forKey:@"expiryYear"];
}

- (NSString *)redactedCardNumber{
  return self.cardNumber;
}

- (NSString *)fillFormScript {
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"fill-form" ofType:nil];
  NSString *qFormat = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  
  //  NSString *month = [NSString stringWithFormat:@"%02d", self.expiryMonth];
  //  NSString *year = [NSString stringWithFormat:@"%02d", self.expiryYear - 2000];
  NSString *cardNumber = @"9000000000000000001";
  NSString *month = @"01";
  NSString *year = @"15";
  NSString *cvv = @"123";
  
  return [NSString stringWithFormat:qFormat, @"Test", cardNumber, month, year, cvv];
}

@end
