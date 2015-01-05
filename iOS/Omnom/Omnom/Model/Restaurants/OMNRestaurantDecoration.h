//
//  OMNRestaurantDecoration.h
//  omnom
//
//  Created by tea on 22.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OMNImageBlock)(UIImage *image);

@interface OMNRestaurantDecoration : NSObject

@property (nonatomic, strong) UIColor *background_color;
@property (nonatomic, strong) UIColor *antagonist_color;
@property (nonatomic, strong) UIImage *logo;
@property (nonatomic, strong) UIImage *background_image;
@property (nonatomic, strong) UIImage *blurred_background_image;

@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *background_imageUrl;
@property (nonatomic, strong, readonly) UIImage *circleBackground;

- (instancetype)initWithJsonData:(id)jsonData;
- (void)loadLogo:(OMNImageBlock)imageBlock;
- (void)loadBackground:(OMNImageBlock)imageBlock;

@end
