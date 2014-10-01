//
//  OMNEditTableVC.m
//  seocialtest
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEditTableVC.h"
#import <OMNStyler.h>
#import "OMNBluetoothManager.h"
#import "OMNScanQRCodeVC.h"
#import "OMNErrorTextField.h"
#import "OMNConstants.h"

@interface OMNEditTableVC ()
<OMNScanQRCodeVCDelegate,
UITextFieldDelegate>

@end

@implementation OMNEditTableVC {
  
  UISwitch *_switch;
  UILabel *_switchLabel;
  UILabel *_hintLabel;
  OMNErrorTextField *_tableNumberTF;
  
  UIButton *_qrScanButton;
  
  OMNStyle *_style;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _style = [[OMNStyler styler] styleForClass:self.class];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  
  self.navigationItem.title = NSLocalizedString(@"Номер стола", nil);
  
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];
//  
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Готово", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneTap)];
  
  [self setup];
  
  _qrScanButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
  [_qrScanButton addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
  
  _switch.hidden = YES;
  _switchLabel.hidden = YES;
  
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {

    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        _switch.hidden = NO;
        _switchLabel.hidden = NO;
        
      } break;
      default: {
        
        //        _tableNumberTF.rightView = _qrScanButton;
        
      } break;
    }
    
    [self updateTableNumberField];
    
  }];
  
}

- (void)setup {
  
  _switch = [[UISwitch alloc] init];
  _switch.on = YES;
  [_switch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
  _switch.translatesAutoresizingMaskIntoConstraints = NO;
  _switch.onTintColor = [UIColor redColor];
  [self.view addSubview:_switch];
  
  _tableNumberTF = [[OMNErrorTextField alloc] initWithWidth:125.0f];
  _tableNumberTF.textField.delegate = self;
  _tableNumberTF.textField.returnKeyType = UIReturnKeyDone;
  _tableNumberTF.textField.font = FuturaLSFOmnomLERegular(50.0f);
  _tableNumberTF.textField.textColor = colorWithHexString(@"000000");
  _tableNumberTF.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  _tableNumberTF.textField.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:_tableNumberTF];
  
  _switchLabel = [[UILabel alloc] init];
  _switchLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _switchLabel.text = NSLocalizedString(@"Определять автоматически", nil);
  _switchLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  _switchLabel.textColor = colorWithHexString(@"000000");
  [self.view addSubview:_switchLabel];

  _hintLabel = [[UILabel alloc] init];
  _hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _hintLabel.text = NSLocalizedString(@"Номер лучше уточнить у официанта", nil);
  _hintLabel.textAlignment = NSTextAlignmentCenter;
  _hintLabel.numberOfLines = 0;
  _hintLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:15.0f];
  _hintLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  [self.view addSubview:_hintLabel];
  
  NSDictionary *views =
  @{
    @"switch" : _switch,
    @"tableNumberTF" : _tableNumberTF,
    @"hintLabel" : _hintLabel,
    @"switchLabel" : _switchLabel,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tableNumberTF]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[switchLabel]-[switch]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[hintLabel]-|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[tableNumberTF]-[switch]-[hintLabel]" options:0 metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_switchLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_switch attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

- (void)scanQRCode {
  
  OMNScanQRCodeVC *scanQRCodeVC = [[OMNScanQRCodeVC alloc] init];
  scanQRCodeVC.delegate = self;
  [self.navigationController pushViewController:scanQRCodeVC animated:YES];
  
}

#pragma mark - OMNScanQRCodeVCDelegate

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code {
  
  _tableNumberTF.textField.text = code;
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC {
  [self.navigationController popToViewController:self animated:YES];
}

- (void)updateTableNumberField {
  
  BOOL enterTableNumberEnabled = (NO == _switch.on || _switch.hidden);
  
  _tableNumberTF.textField.enabled = enterTableNumberEnabled;
  if (enterTableNumberEnabled) {
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


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.delegate editTableVCDidFinish:self];
  return YES;
}

@end
