//
//  GMenuItem.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenuProduct.h"
#import "OMNImageManager.h"

@implementation OMNMenuProduct

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {
    
    self.id = data[@"id"];
    self.name = data[@"name"];
    self.price = [data[@"price"] doubleValue];
    self.Description = data[@"description"];
    self.photo = data[@"photo"];
    self.modifiers = data[@"modifiers"];
    self.recommendations = data[@"recommendations"];
    self.details = [[OMNMenuProductDetails alloc] initWithJsonData:data[@"details"]];
    
  }
  return self;
}


- (NSString *)description {
  
  return [NSString stringWithFormat:@"%@, name = %@", NSStringFromClass(self.class), self.name];
  
}

- (void)loadImage {
  
  if (0 == self.photo.length) {
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

@end
