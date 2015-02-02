//
//  OMNMenuProductModifer.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductModifer.h"

@implementation OMNMenuProductModifer

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    self.id = jsonData[@"id"];
    self.type = [self modiferTypeFromString:jsonData[@"type"]];
    self.name = jsonData[@"name"];
    self.list = jsonData[@"list"];
    
  }
  return self;
}

- (OMNMenuProductModiferType)modiferTypeFromString:(NSString *)modiferTypeString {
  
  OMNMenuProductModiferType modiferType = kMenuProductModiferTypeNone;
  if ([modiferTypeString isEqualToString:@"checkbox"]) {
    modiferType = kMenuProductModiferTypeCheckbox;
  }
  else if ([modiferTypeString isEqualToString:@"select"]) {
    modiferType = kMenuProductModiferTypeSelect;
  }
  else if ([modiferTypeString isEqualToString:@"multiselect"]) {
    modiferType = kMenuProductModiferTypeMultiselect;
  }

  return modiferType;
  
}

@end
