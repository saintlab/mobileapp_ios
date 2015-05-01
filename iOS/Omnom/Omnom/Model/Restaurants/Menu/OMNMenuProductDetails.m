//
//  OMNMenuProductDetails.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductDetails.h"
#import "NSObject+omn_safe_creation.h"

@implementation OMNMenuProductDetails

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
 
    self.weight_gr = [jsonData[@"weight"] omn_stringValueSafe];
    self.volume_ml = [jsonData[@"volume"] omn_stringValueSafe];
    self.persons = [jsonData[@"persons"] omn_integerValueSafe];
    self.cooking_time_minutes = [jsonData[@"cooking_time"] omn_integerValueSafe];
    self.energy_100 = [jsonData[@"energy_100"] omn_stringValueSafe];
    self.energy_total = [jsonData[@"energy_total"] omn_stringValueSafe];
    self.protein_100 = [jsonData[@"protein_100"] omn_stringValueSafe];
    self.protein_total = [jsonData[@"protein_total"] omn_stringValueSafe];
    self.fat_100 = [jsonData[@"fat_100"] omn_stringValueSafe];
    self.fat_total = [jsonData[@"fat_total"] omn_stringValueSafe];
    self.carbohydrate_100 = [jsonData[@"carbohydrate_100"] omn_stringValueSafe];
    self.carbohydrate_total = [jsonData[@"carbohydrate_total"] omn_stringValueSafe];
    self.ingredients = [jsonData[@"ingredients"] omn_stringValueSafe];
    
  }
  return self;
}

- (NSString *)weighVolumeText {
  
  NSString *displayText = @"";
  
  if (self.volume_ml.length) {

    displayText = [NSString stringWithFormat:kOMN_MENU_PRODUCT_VOLUME_FORMAT, self.volume_ml];
    
  }
  else if (self.weight_gr.length) {
    
    displayText = [NSString stringWithFormat:kOMN_MENU_PRODUCT_WEIGHT_FORMAT, self.weight_gr];
    
  }
  
  return displayText;
  
}

- (NSString *)displayFullText {
  
  NSMutableArray *displayItems = [NSMutableArray arrayWithCapacity:2];
  
  switch (self.persons) {
    case 0: {
    } break;
    case 1: {
      [displayItems addObject:kOMN_MENU_PRODUCT_PERSON_1];
    } break;
    case 2: {
      [displayItems addObject:kOMN_MENU_PRODUCT_PERSON_2];
    } break;
    case 3: {
      [displayItems addObject:kOMN_MENU_PRODUCT_PERSON_3];
    } break;
    case 4: {
      [displayItems addObject:kOMN_MENU_PRODUCT_PERSON_4];
    } break;
    case 5: {
      [displayItems addObject:kOMN_MENU_PRODUCT_PERSON_5];
    } break;
    default: {
      [displayItems addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_PERSON_N_FORMAT, self.persons]];
    } break;
  }
  
  if (self.cooking_time_minutes > 0) {
    
    NSMutableArray *timeComponents = [NSMutableArray arrayWithCapacity:2];
    const NSInteger kMinutesInHour = 60;
    if (self.cooking_time_minutes > kMinutesInHour) {
      
      [timeComponents addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_COOKING_TIME_HOUR_FORMAT, self.cooking_time_minutes/kMinutesInHour]];
      
    }
    
    [timeComponents addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_COOKING_TIME_MINUTES_FORMAT, self.cooking_time_minutes%kMinutesInHour]];
    
    NSString *cookinTime = [NSString stringWithFormat:kOMN_MENU_PRODUCT_COOKING_TIME_FORMAT, [timeComponents componentsJoinedByString:@" "]];
    [displayItems addObject:cookinTime];
    
  }

  NSString *displayFullText = [displayItems componentsJoinedByString:@"\n"];
  
  return displayFullText;
  
  
}

- (NSString *)compositionText {
  
  NSMutableArray *compositionItems = [NSMutableArray arrayWithCapacity:2];
  
  NSMutableArray *display100Items = [NSMutableArray arrayWithCapacity:4];
  
  if (self.energy_100.length) {
    [display100Items addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_ENERGY_FORMAT, self.energy_100]];
  }
  if (self.protein_100.length) {
    [display100Items addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_PROTEIN_FORMAT, self.protein_100]];
  }
  if (self.fat_100.length) {
    [display100Items addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_FAT_FORMAT, self.fat_100]];
  }
  if (self.carbohydrate_100.length) {
    [display100Items addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_CARBOHYDRATE_FORMAT, self.carbohydrate_100]];
  }
  
  NSString *componentsSeporator = @" \u00B7 ";
  
  if (display100Items.count) {
    
    NSString *display100Text = [NSString stringWithFormat:kOMN_MENU_PRODUCT_100_DISPLAY_FORMAT, [display100Items componentsJoinedByString:componentsSeporator]];
    [compositionItems addObject:display100Text];
    
  }

  NSMutableArray *displayTotalItems = [NSMutableArray arrayWithCapacity:4];
  if (self.energy_total.length) {
    [displayTotalItems addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_ENERGY_FORMAT, self.energy_total]];
  }
  if (self.protein_total.length) {
    [displayTotalItems addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_PROTEIN_FORMAT, self.protein_total]];
  }
  if (self.fat_total.length) {
    [displayTotalItems addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_FAT_FORMAT, self.fat_total]];
  }
  if (self.carbohydrate_total.length) {
    [displayTotalItems addObject:[NSString stringWithFormat:kOMN_MENU_PRODUCT_CARBOHYDRATE_FORMAT, self.carbohydrate_total]];
  }
  
  if (displayTotalItems.count) {
    
    NSString *displayTotalText = [NSString stringWithFormat:kOMN_MENU_PRODUCT_TOTAL_DISPLAY_FORMAT, [displayTotalItems componentsJoinedByString:componentsSeporator]];
    [compositionItems addObject:displayTotalText];
    
  }

  return [compositionItems componentsJoinedByString:@"\n\n"];
  
}

@end
