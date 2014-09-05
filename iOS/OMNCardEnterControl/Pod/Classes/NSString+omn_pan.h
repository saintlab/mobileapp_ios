//
//  NSString+omn_pan.h
//  omnom
//
//  Created by tea on 04.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMM_YYSeporator;

/**
 //https://ru.wikipedia.org/wiki/Контрольное_число#.D0.9D.D0.BE.D0.BC.D0.B5.D1.80.D0.B0_.D0.B1.D0.B0.D0.BD.D0.BA.D0.BE.D0.B2.D1.81.D0.BA.D0.B8.D1.85_.D0.BA.D0.B0.D1.80.D1.82
 */
@interface NSString (omn_pan)

- (BOOL)omn_isValidPan;
- (NSString *)omn_decimalString;
- (NSString *)omn_panFormatedString;

- (BOOL)omn_isValidDate;

@end
