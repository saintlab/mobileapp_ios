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
  NSArray *_buttons;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title buttons:(NSArray *)buttons {
  self = [super initWithNibName:@"OMNSearchBeaconRootVC" bundle:nil];
  if (self) {
    _image = image;
    _title = title;
    _buttons = buttons;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];

  if (_buttons.count) {
    self.button.hidden = NO;
    [self.button setTitle:[_buttons firstObject] forState:UIControlStateNormal];
  }
  else {
    self.button.hidden = YES;
  }
  
  [self.button addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
  self.label.text = _title;
  [self.circleButton setImage:_image forState:UIControlStateNormal];
  
}

- (void)buttonTap {
  if (self.actionBlock) {
    self.actionBlock();
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
