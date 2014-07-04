//
//  OMNEditTableVC.m
//  seocialtest
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEditTableVC.h"
#import <OMNStyler.h>

@interface OMNEditTableVC ()

@end

@implementation OMNEditTableVC {
  
  __weak IBOutlet UISwitch *_switch;
  __weak IBOutlet UILabel *_tableNumberLabel;
  __weak IBOutlet UILabel *_switchLabel;
  __weak IBOutlet UIImageView *_bgIV;
  __weak IBOutlet UITextField *_tableNumberTF;

  OMNStyle *_style;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _style = [[OMNStyler styler] styleForClass:self.class];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Готово", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneTap)];
  
  _bgIV.image = [UIImage imageNamed:@"background_blur"];
  
  _switch.tintColor = [UIColor redColor];
  _switch.onTintColor = [UIColor redColor];
  
  _tableNumberLabel.font = [_style fontForKey:@"tableNumberLabelFont"];
  _tableNumberLabel.text = [_style stringForKey:@"tableNumberLabelText"];
  _tableNumberLabel.textColor = [_style colorForKey:@"tableNumberLabelColor"];
  
  _tableNumberTF.font = [_style fontForKey:@"tableNumberFieldFont"];
  _tableNumberTF.textColor = [_style colorForKey:@"tableNumberFieldColor"];
  
  _switchLabel.font = [_style fontForKey:@"switchLabelFont"];
  _switchLabel.text = [_style stringForKey:@"switchLabelText"];
  _switchLabel.textColor = [_style colorForKey:@"switchLabelColor"];
  
  [self updateTableNumberField];
  
}

- (void)updateTableNumberField {
  
  _tableNumberTF.enabled = !_switch.on;
  if (NO == _switch.on) {
    [_tableNumberTF becomeFirstResponder];
  }
}

- (void)closeTap {
  [self.delegate editTableVCDidFinish:self];
}

- (void)doneTap {
  [self.delegate editTableVCDidFinish:self];
}

- (IBAction)switchChange:(UISwitch *)sender {
  
  [self updateTableNumberField];
  
}


- (void)didReceiveMemoryWarning
{
  
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
