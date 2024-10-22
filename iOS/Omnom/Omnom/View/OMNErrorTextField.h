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

- (void)setErrorText:(NSString *)text;
- (void)setError:(BOOL)isError;

@end
