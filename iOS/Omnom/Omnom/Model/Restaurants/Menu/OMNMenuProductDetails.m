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
 
    self.weight_gr = jsonData[@"weight"];
    self.volume_ml = jsonData[@"volume"];
    self.persons = [jsonData[@"persons"] integerValue];
    self.cooking_time_minutes = [jsonData[@"cooking_time"] integerValue];
    self.energy_100 = jsonData[@"energy_100"];
    self.energy_total = jsonData[@"energy_total"];
    self.protein_100 = jsonData[@"protein_100"];
    self.protein_total = jsonData[@"protein_total"];
    self.fat_100 = jsonData[@"fat_100"];
    self.fat_total = jsonData[@"fat_total"];
    self.carbohydrate_100 = jsonData[@"carbohydrate_100"];
    self.carbohydrate_total = jsonData[@"carbohydrate_total"];
    self.ingredients = jsonData[@"ingredients"];
    
  }
  return self;
}

- (NSString *)displayText {
  
  NSMutableArray *displayItems = [NSMutableArray arrayWithCapacity:2];
  
  if (self.energy_total.length) {
    
    [displayItems addObject:[NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_ENERGY %@", @"{ENERGY} ккал"), self.energy_total]];
    
  }
  
  if (self.weight_gr.length) {
    
    [displayItems addObject:[NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_WEIGHT %@", @"{WEIGHT} гр."), self.weight_gr]];
    
  }
  
  return [displayItems componentsJoinedByString:@", "];
  
}

- (NSString *)displayFullText {
  
  NSMutableArray *displayItems = [NSMutableArray arrayWithCapacity:3];
  
  NSString *displayText = self.displayText;
  if (displayText.length) {
    
    [displayItems addObject:displayText];
    
  }
  
  switch (self.persons) {
    case 0: {
    } break;
    case 1: {
      [displayItems addObject:NSLocalizedString(@"MENU_PRODUCT_PERSON_1", @"Порция на одного")];
    } break;
    case 2: {
      [displayItems addObject:NSLocalizedString(@"MENU_PRODUCT_PERSON_2", @"Порция на двоих")];
    } break;
    case 3: {
      [displayItems addObject:NSLocalizedString(@"MENU_PRODUCT_PERSON_3", @"Порция на троих")];
    } break;
    case 4: {
      [displayItems addObject:NSLocalizedString(@"MENU_PRODUCT_PERSON_4", @"Порция на четверых")];
    } break;
    case 5: {
      [displayItems addObject:NSLocalizedString(@"MENU_PRODUCT_PERSON_5", @"Порция на пятерых")];
    } break;
    default: {
      [displayItems addObject:[NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_PERSON_N %d", @"Порция на {PERSON_COUNT} человек"), self.persons]];
    } break;
  }
  
  if (self.cooking_time_minutes > 0) {
    
    NSMutableArray *timeComponents = [NSMutableArray arrayWithCapacity:2];
    const NSInteger kMinutesInHour = 60;
    if (self.cooking_time_minutes > kMinutesInHour) {
      
      [timeComponents addObject:[NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_COOKING_TIME_HOUR %d", @"{HOUR} ч."), self.cooking_time_minutes/kMinutesInHour]];
      
    }
    
    [timeComponents addObject:[NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_COOKING_TIME_MINUTES %d", @"{MINUTES} минут"), self.cooking_time_minutes%kMinutesInHour]];
    
    NSString *cookinTime = [NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_COOKING_TIME %@", @"время приготовления {DURATION}"), [timeComponents componentsJoinedByString:@" "]];
    [displayItems addObject:cookinTime];
    
  }
  
  NSString *displayFullText = [displayItems componentsJoinedByString:@"\n"];
  
  return displayFullText;
  
  
}

- (NSString *)display100Text {
  
  NSMutableArray *displayItems = [NSMutableArray arrayWithCapacity:3];
  
  if (self.protein_100.length) {
    
    [displayItems addObject:[NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_PROTEIN %@", @"Белки {PROTEIN}"), self.protein_100]];
    
  }
  
  if (self.fat_100.length) {
    
    [displayItems addObject:[NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_FAT %@", @"Жиры {FAT}"), self.fat_100]];
    
  }
  
  if (self.carbohydrate_100.length) {
    
    [displayItems addObject:[NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_CARBOHYDRATE %@", @"Углеводы {CARBOHYDRATE}"), self.carbohydrate_100]];
    
  }
  
  NSString *display100Text = @"";
  
  if (displayItems.count) {
    
    display100Text = [NSString stringWithFormat:NSLocalizedString(@"MENU_PRODUCT_100_DISPLAY_TEXT %@", @"На 100 гр. – {DISPLAY_TEXT}"), [displayItems componentsJoinedByString:@"|"]];
    
  }

  return display100Text;
  
}

@end
