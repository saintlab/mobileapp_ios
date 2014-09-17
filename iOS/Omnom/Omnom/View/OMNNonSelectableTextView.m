//
//  OMNNonSelectableTextView.m
//  omnom
//
//  Created by tea on 17.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNonSelectableTextView.h"

@implementation OMNNonSelectableTextView

- (instancetype)init {
  self = [super init];
  if (self) {
    self.scrollEnabled = NO;
    self.editable = NO;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.autocorrectionType = UITextAutocorrectionTypeNo;
  }
  return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  
  [UIMenuController sharedMenuController].menuVisible = NO;
  self.selectedRange = NSMakeRange(0, 0);
  return NO;
  
}

@end
