//
//  OMNDenyCLPermissionVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDenyCLPermissionVC.h"

@interface OMNDenyCLPermissionVC ()

@end

@implementation OMNDenyCLPermissionVC {
  UIButton *_allowButton;
}

- (instancetype)init {
  self = [super initWithTitle:NSLocalizedString(@"Ваше разрешение на геолокацию – одно из необходимых условий работы Omnom. Без этого мы не сможем определить столик.", nil) buttons:@[]];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.circleBackground = nil;

  _allowButton = [[UIButton alloc] init];
  _allowButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  _allowButton.translatesAutoresizingMaskIntoConstraints = NO;
  _allowButton.tintColor = [UIColor blackColor];
  [_allowButton addTarget:self action:@selector(grantPermissionTap:) forControlEvents:UIControlEventTouchUpInside];
  [_allowButton setImage:[UIImage imageNamed:@"repeat_icon_small"] forState:UIControlStateNormal];
  [_allowButton setTitle:NSLocalizedString(@"Повторить", nil) forState:UIControlStateNormal];
  [_allowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _allowButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
  
  [self.view addSubview:_allowButton];
  NSDictionary *views =
  @{
    @"allowButton" : _allowButton,
    };
  
  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[allowButton]|" options:0 metrics:nil views:views];
  [self.view addConstraints:constraints];
  constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[allowButton(50)]|" options:0 metrics:nil views:views];
  [self.view addConstraints:constraints];
  
}

- (IBAction)grantPermissionTap:(id)sender {
  
  [self.delegate denyCLPermissionVCDidAskPermission:self];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
