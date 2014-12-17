//
//  GAmountPercentControl.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAmountPercentValue.h"

@interface OMNAmountPercentControl : UIControl

@property (nonatomic, strong) OMNAmountPercentValue *amountPercentValue;
@property (nonatomic, assign, readonly) BOOL percentEditing;

- (void)beginPercentEditing;
- (void)configureWithColor:(UIColor *)color antogonistColor:(UIColor *)antogonistColor;

@end



