//
//  OMNDateSelectionVC.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNDateSelectionVC.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNDateSelectionVC ()

@end

@implementation OMNDateSelectionVC {
  
  NSArray *_dates;
  
}

- (instancetype)initWithDates:(NSArray *)dates {
  self = [super init];
  if (self) {
    
    _dates = dates;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = kOMN_RESTAURANT_DATE_SELECTION_TITLE;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    self.didCloseBlock();
  }
  
}

@end
