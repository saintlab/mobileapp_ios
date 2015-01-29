//
//  OMNTableButton.h
//  omnom
//
//  Created by tea on 29.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNTable.h"

@interface OMNTableButton : UIButton

+ (instancetype)buttonWithColor:(UIColor *)color;
- (void)setText:(NSString *)text;

@end
