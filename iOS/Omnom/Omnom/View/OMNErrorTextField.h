//
//  OMNErrorTextField.h
//  omnom
//
//  Created by tea on 06.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNErrorTextField : UIView

@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, assign, readonly) CGFloat controlWidth;

- (instancetype)initWithWidth:(CGFloat)width;
- (instancetype)initWithWidth:(CGFloat)width textFieldClass:(Class)textFieldClass;
- (void)setError:(NSString *)text;

- (void)setText:(NSString *)text description:(NSString *)description;

@end
