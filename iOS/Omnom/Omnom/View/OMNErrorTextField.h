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

- (instancetype)initWithWidth:(CGFloat)width;
- (void)setError:(NSString *)text animated:(BOOL)animated;

@end
