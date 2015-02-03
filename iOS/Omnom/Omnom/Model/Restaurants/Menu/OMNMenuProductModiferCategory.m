//
//  OMNMenuProductModifer.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductModiferCategory.h"

@implementation OMNMenuProductModiferCategory {
  
  
  
}

- (instancetype)initWithJsonData:(id)jsonData allModifers:(NSDictionary *)allModifers {
  self = [super init];
  if (self) {
    
    _allModifers = allModifers;
    self.id = jsonData[@"id"];
    _type = [self modiferTypeFromString:jsonData[@"type"]];
    self.name = jsonData[@"name"];
    self.list = jsonData[@"list"];
    
  }
  return self;
}

- (OMNMenuProductModiferCategoryType)modiferTypeFromString:(NSString *)modiferTypeString {
  
  OMNMenuProductModiferCategoryType modiferType = kMenuProductModiferCategoryTypeNone;
  if ([modiferTypeString isEqualToString:@"checkbox"]) {
    modiferType = kMenuProductModiferCategoryTypeCheckbox;
  }
  else if ([modiferTypeString isEqualToString:@"select"]) {
    modiferType = kMenuProductModiferCategoryTypeSelect;
  }
  else if ([modiferTypeString isEqualToString:@"multiselect"]) {
    modiferType = kMenuProductModiferCategoryTypeMultiselect;
  }

  return modiferType;
  
}

@end
