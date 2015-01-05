//
//  OMNRestaurantDecoration.m
//  omnom
//
//  Created by tea on 22.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantDecoration.h"
#import "OMNImageManager.h"
#import "NSString+omn_color.h"
#import "UIImage+omn_helper.h"

@implementation OMNRestaurantDecoration

- (UIColor *)colorFromString:(NSString *)string {
  
  UIColor *color = nil;
  if ([string isKindOfClass:[NSString class]]) {
    
    color = [string omn_colorFormHex];
    
  }
  else {
    
    color = [UIColor blackColor];
    
  }
  
  return color;
}

- (instancetype)initWithJsonData:(id)jsonData {
  
  if ([jsonData isKindOfClass:[NSNull class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
  
//@"https://www.dropbox.com/s/lnen3lflf295fov/IMG_1353.JPG?dl=1";//
    self.logoUrl = jsonData[@"logo"];
    self.background_imageUrl = jsonData[@"background_image"];
    self.background_color = [self colorFromString:jsonData[@"background_color"]];
    self.antagonist_color = [self colorFromString:jsonData[@"antagonist_color"]];

  }
  return self;
}

- (UIImage *)circleBackground {
  
  return [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:self.background_color];
  
}

- (void)loadLogo:(OMNImageBlock)imageBlock {
  
  __weak typeof(self)weakSelf = self;
  [[OMNImageManager manager] downloadImageWithURL:self.logoUrl completion:^(UIImage *image) {
    
    weakSelf.logo = image;
    imageBlock(image);
    
  }];
  
}

- (void)loadBackground:(OMNImageBlock)imageBlock {
  
  __weak typeof(self)weakSelf = self;
  [[OMNImageManager manager] downloadImageWithURL:self.background_imageUrl completion:^(UIImage *image) {
    
    weakSelf.background_image = image;
    imageBlock(image);
    
  }];
  
}

@end
