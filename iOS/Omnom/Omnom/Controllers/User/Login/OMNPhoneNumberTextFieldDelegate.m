//
//  OMNPhoneNumberTextFieldDelegate.m
//  restaurants
//
//  Created by tea on 17.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPhoneNumberTextFieldDelegate.h"

@implementation OMNPhoneNumberTextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  NSString *decimalString = [components componentsJoinedByString:@""];
  
  NSUInteger length = decimalString.length;
  
  if (length <= 1) {
    textField.text = decimalString;
    return NO;
  }
  
  if (length > 11) {
    return NO;
  }

    char leadingCharacter;
    leadingCharacter = [newString characterAtIndex:0];
  
  NSUInteger index = 0;
  NSMutableString *formattedString = [NSMutableString string];
  
  [formattedString appendFormat:@"%c ", leadingCharacter];
  index += 1;
  
  if (length - index > 3) {
    NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
    [formattedString appendFormat:@"(%@) ",areaCode];
    index += 3;
  }
  
  if (length - index > 3) {
    NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
    [formattedString appendFormat:@"%@-",prefix];
    index += 3;
  }
  
  NSString *remainder = [decimalString substringFromIndex:index];
  [formattedString appendString:remainder];
  
  textField.text = formattedString;
  
  return NO;
}


@end
