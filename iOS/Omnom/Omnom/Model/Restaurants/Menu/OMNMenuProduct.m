//
//  GMenuItem.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenuProduct.h"
#import "OMNImageManager.h"
#import <BlocksKit.h>
#import "OMNUtils.h"
#import "OMNConstants.h"
#import <OMNStyler.h>

NSString * const OMNMenuProductDidChangeNotification = @"OMNMenuProductDidChangeNotification";

@implementation OMNMenuProduct

- (instancetype)initWithJsonData:(id)data allModifers:(NSDictionary *)allModifers {
  self = [super init];
  if (self) {
    
    _allModifers = allModifers;
    _selectedModifers = [NSMutableSet set];
    self.id = data[@"id"];
    self.name = data[@"name"];
    self.price = [data[@"price"] doubleValue]*100ll;
    self.Description = data[@"description"];
    self.photo = data[@"photo"];
    self.recommendations = data[@"recommendations"];
    self.details = [[OMNMenuProductDetails alloc] initWithJsonData:data[@"details"]];
    
    self.modifiers = [data[@"modifiers"] bk_map:^id(id modiferData) {
    
      return [[OMNMenuProductModiferCategory alloc] initWithJsonData:modiferData allModifers:allModifers];
      
    }];
    
  }
  return self;
}

- (BOOL)hasPhoto {
  
  return (self.photo.length > 0);
  
}

- (BOOL)hasRecommendations {
  
  return (self.recommendations.count > 0);
  
}

- (void)setQuantity:(double)quantity {
  
  _quantity = quantity;
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNMenuProductDidChangeNotification object:self];
  
}

- (long long)total {
  
  return (long long int) (self.price*self.quantity);
  
}

- (NSString *)description {
  
  return [NSString stringWithFormat:@"%@, name = %@", NSStringFromClass(self.class), self.name];
  
}

- (NSString *)shortDescription {
  
  NSString *description = self.Description;
  NSInteger descriptionLength = 35;
  if (description.length > descriptionLength) {
    description = [description substringToIndex:descriptionLength];
  }
  description = [description stringByAppendingString:@"..."];

  return description;
  
}

- (void)loadImage {
  
  if (!self.hasPhoto) {
    return;
  }
  
  if (self.photoImage) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [[OMNImageManager manager] downloadImageWithURL:self.photo completion:^(UIImage *image) {
    
    weakSelf.photoImage = image;
    
  }];
  
}

- (BOOL)preordered {
  
  return (_quantity > 0.0);
  
}

- (void)resetSelection {
  
  self.quantity = 0.0;
  [self.selectedModifers removeAllObjects];
  
}

- (NSAttributedString *)nameAttributedString {
  
  NSString *weightString = self.details.weighVolumeText;
  NSString *nameString = [NSString stringWithFormat:@"%@ %@", self.name, weightString];
  
  NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:nameString attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(20.0f) textColor:colorWithHexString(@"000000") textAlignment:NSTextAlignmentCenter]];
  [nameAttributedString setAttributes:
   @{
     NSFontAttributeName : FuturaLSFOmnomLERegular(12.0f),
     NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f],
     } range:[nameString rangeOfString:weightString]];
  
  return nameAttributedString;
  
}

@end
