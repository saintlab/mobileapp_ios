//
//  OMNMenuProductDetails.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductDetails.h"

@implementation OMNMenuProductDetails

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
 
    self.weight = [jsonData[@"weight"] doubleValue];
    self.energy_total = [jsonData[@"energy_total"] doubleValue];
    
  }
  return self;
}

- (NSString *)displayText {
  
  return [NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_DETAILS {ENERGY}%.0f {WEIGHT}%.0f", @"{ENERGY} ккал, {WEIGHT} гр."), self.energy_total, self.weight];
  
}

@end
