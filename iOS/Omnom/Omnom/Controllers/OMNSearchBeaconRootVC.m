//
//  OMNSearchBeaconRootVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchBeaconRootVC.h"

@interface OMNSearchBeaconRootVC ()

@end

@implementation OMNSearchBeaconRootVC {
  UIImage *_image;
  NSString *_title;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title buttons:(NSArray *)buttons {
  self = [super initWithNibName:@"OMNSearchBeaconRootVC" bundle:nil];
  if (self) {
    _image = image;
    _title = title;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  self.button.hidden = YES;
  self.label.text = _title;
  [self.circleButton setImage:_image forState:UIControlStateNormal];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
