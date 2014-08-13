//
//  OMNBankCard.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"
#import "OMNOperationManager.h"
#import <OMNMailRuAcquiring.h>

@interface OMNBankCard ()

@property(nonatomic, assign) BOOL deleting;

@end

@implementation OMNBankCard

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.association = jsonData[@"association"];
    self.confirmed_by = jsonData[@"confirmed_by"];
    self.created_at = jsonData[@"created_at"];
    self.external_card_id = jsonData[@"external_card_id"];
    self.id = jsonData[@"id"];
    self.masked_pan = jsonData[@"masked_pan"];
    self.status = jsonData[@"status"];
    self.updated_at = jsonData[@"updated_at"];
    self.user_id = jsonData[@"user_id"];
    
  }
  return self;
}

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

- (NSString *)redactedCardNumber {
  
  if (self.cardNumber.length == 16) {
    return [self.cardNumber stringByReplacingCharactersInRange:NSMakeRange(2, self.cardNumber.length - 6) withString:@"** **** **** "];
  }
  else {
    return self.cardNumber;
  }

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

+ (void)getCardsWithCompletion:(void(^)(NSArray *cards))completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSAssert(completionBlock != nil, @"completionBlock is nil");
  NSAssert(failureBlock != nil, @"complitionBlock is nil");
  
  NSString *path = [NSString stringWithFormat:@"/cards"];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    [response decodeCardData:completionBlock failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
}

- (void)deleteWithCompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSAssert(completionBlock != nil, @"completionBlock is nil");
  NSAssert(failureBlock != nil, @"complitionBlock is nil");
  
  _deleting = YES;
  __weak typeof(self)weakSelf = self;
  [[OMNMailRuAcquiring acquiring] cardDelete:self.external_card_id user_login:self.user_id completion:^(id response) {
    
    if (response) {
      
      NSString *path = [NSString stringWithFormat:@"/cards/%@", self.id];
      [[OMNOperationManager sharedManager] DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        completionBlock();
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        weakSelf.deleting = NO;
        failureBlock(error);
      }];
      
    }
    else {
      weakSelf.deleting = NO;
      failureBlock(nil);
    }
    
  }];
  
}

@end

@implementation NSDictionary (omn_decodeCardData)

- (void)decodeCardData:(void(^)(NSArray *))completionBlock failure:(void(^)(NSError *))failureBlock {
  
  if ([self isKindOfClass:[NSDictionary class]]) {

    NSArray *rawCards = self[@"cards"];
    if (rawCards) {
      NSMutableArray *cards = [NSMutableArray arrayWithCapacity:rawCards.count];
      [rawCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        OMNBankCard *card = [[OMNBankCard alloc] initWithJsonData:obj];
        [cards addObject:card];
        
      }];
      completionBlock([cards copy]);
    }
    else {
      failureBlock(nil);
    }
    
  }
  else {
    failureBlock(nil);
  }
  
}

@end