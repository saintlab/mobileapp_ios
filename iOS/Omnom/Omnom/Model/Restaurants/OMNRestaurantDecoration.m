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
  
    self.logoUrl = jsonData[@"logo"];
    self.background_imageUrl = jsonData[@"background_image"];
    self.background_color = [self colorFromString:jsonData[@"background_color"]];
    self.antagonist_color = (jsonData[@"antagonist_color"]) ? ([self colorFromString:jsonData[@"antagonist_color"]]) : ([UIColor whiteColor]);

  }
  return self;
}

- (UIImage *)circleBackground {
  
  return [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:self.background_color];
  
}

- (UIImage *)woodBackgroundImage {

  return [[UIImage imageNamed:@"wood_bg"] omn_blendWithColor:self.background_color blendMode:kCGBlendModeMultiply alpha:0.85f];
  
}

- (void)loadLogo:(OMNImageBlock)imageBlock {
  
  @weakify(self)
  [[OMNImageManager manager] downloadImageWithURL:self.logoUrl completion:^(UIImage *image) {
    
    @strongify(self)
    self.logo = image;
    imageBlock(image);
    
  }];
  
}

- (BOOL)hasBackgroundImage {
  
  return (self.background_imageUrl.length > 0);
  
}

- (void)loadBackground:(OMNImageBlock)imageBlock {
  
  @weakify(self)
  [[OMNImageManager manager] downloadImageWithURL:self.background_imageUrl completion:^(UIImage *image) {
    
    @strongify(self)
    self.background_image = image;
    imageBlock(image);
    
  }];
  
}

@end
