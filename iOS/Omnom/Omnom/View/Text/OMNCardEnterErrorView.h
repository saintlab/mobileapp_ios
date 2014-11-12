//
//  OMNCardEnterErrorView.h
//  omnom
//
//  Created by tea on 04.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNonSelectableTextView.h"

@interface OMNCardEnterErrorView : OMNNonSelectableTextView

- (void)setHelpText;
- (void)setWrongAmountError;
- (void)setErrorText:(NSString *)text;
- (void)setUnknownError;

@end
