//
//  GTip.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNTip : NSObject

@property (nonatomic, assign) double amount;
@property (nonatomic, assign) double percent;
//@property (nonatomic, assign) double calculationValue;
@property (nonatomic, assign) BOOL selected;

+ (instancetype)tipWithPercent:(double)percent;

- (instancetype)initWithAmount:(double)amount percent:(double)percent;

//- (NSString *)title;
//- (NSString *)selectedTitle;

@end
