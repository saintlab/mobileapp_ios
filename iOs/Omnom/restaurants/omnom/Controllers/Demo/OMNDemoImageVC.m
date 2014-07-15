//
//  OMNDemoImageVC.m
//  restaurants
//
//  Created by tea on 11.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDemoImageVC.h"

@implementation OMNDemoImageVC {
  NSString *_text;
}

- (instancetype)initWithText:(NSString *)text {
  self = [super init];
  if (self) {
    _text = text;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
  label.backgroundColor = [UIColor whiteColor];
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont boldSystemFontOfSize:50.0f];
  label.text = _text;
  [self.view addSubview:label];
  
}

@end
