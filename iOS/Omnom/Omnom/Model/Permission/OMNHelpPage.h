//
//  OMNHelpPage.h
//  omnom
//
//  Created by tea on 25.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNHelpPage : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *image;

+ (instancetype)pageWithText:(NSString *)text imageName:(NSString *)name;

@end
