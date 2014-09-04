//
//  OMNDeletedTextField.h
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNDeletedTextField : UITextField

@property (nonatomic, strong) UIColor *errorColor;
@property (nonatomic, assign) BOOL error;

@end