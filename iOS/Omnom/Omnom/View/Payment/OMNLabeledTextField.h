//
//  OMNLabeledTextField.h
//  omnom
//
//  Created by tea on 26.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNLabeledTextField : UITextField

@property (nonatomic, copy) NSString *detailedText;

- (void)setDetailedText:(NSString *)text;

@end
