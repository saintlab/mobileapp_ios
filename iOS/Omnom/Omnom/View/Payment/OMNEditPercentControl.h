//
//  OMNPercentControl.h
//  omnom
//
//  Created by tea on 19.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNEditPercentControl : UIControl

@property (nonatomic, assign) double percent;

- (void)configureWithColor:(UIColor *)color antogonistColor:(UIColor *)antogonistColor;

@end
