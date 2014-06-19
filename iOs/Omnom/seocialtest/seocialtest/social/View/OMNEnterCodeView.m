//
//  OMNEnterCodeView.m
//  seocialtest
//
//  Created by tea on 17.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEnterCodeView.h"

@implementation OMNEnterCodeView {
  NSArray *_labels;
}

- (instancetype)init {
  self = [super initWithFrame:CGRectMake(0, 0, 130.0f, 40.0f)];
  if (self) {

    [self setup];
    
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (void)setup {
  
  NSMutableArray *labels = [NSMutableArray arrayWithCapacity:4];
  
  const CGFloat labelWidth = 25.0f;
  const CGFloat labelOffset = 10.0f;
  
  for (int i = 0; i < 4; i++) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((labelWidth + labelOffset) * i, 0, labelWidth, CGRectGetHeight(self.frame))];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    [self addSubview:label];
    [labels addObject:label];
  }
  
  _labels = labels;
  
  self.code = @"";
  
}

- (void)setCode:(NSString *)code {
  
  _code = code;
  
  [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
    
    if (idx < code.length) {
    
      char ch = [code characterAtIndex:idx];
      label.text = [NSString stringWithFormat:@"%c", ch];
    }
    else {
      label.text = @"_";
    }
    
  }];
  
}


@end
