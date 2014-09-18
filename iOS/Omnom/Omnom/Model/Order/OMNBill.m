//
//  OMNBill.m
//  omnom
//
//  Created by tea on 29.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBill.h"
#import "OMNOperationManager.h"

@implementation OMNBill

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.id = [jsonData[@"id"] description];
    self.mail_restaurant_id = jsonData[@"mail_restaurant_id"];
    self.table_id = jsonData[@"table_id"];
  }
  return self;
}

- (void)linkForAmount:(long long)amount tip:(long long)tipAmount completion:(OMNBillPayLinkBlock)completion {
  
  NSString *path = [NSString stringWithFormat:@"/link/%@/%lld/%lld", self.id, amount, tipAmount];
  
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"linkForAmount>%@", responseObject);
    completion(responseObject[@"link"]);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    NSLog(@"linkForAmount>%@", operation.responseString);
    completion(nil);
    
  }];
  
}


@end
