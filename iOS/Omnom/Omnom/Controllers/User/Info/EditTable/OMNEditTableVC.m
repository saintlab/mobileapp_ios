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

@interface OMNEditTableVC ()
<OMNScanQRCodeVCDelegate>

@end

@implementation OMNEditTableVC {
  
  __weak IBOutlet UISwitch *_switch;
  __weak IBOutlet UILabel *_tableNumberLabel;
  __weak IBOutlet UILabel *_switchLabel;
  __weak IBOutlet UIImageView *_bgIV;
  __weak IBOutlet UITextField *_tableNumberTF;

  UIButton *_qrScanButton;
  
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
  _tableNumberLabel.textAlignment = NSTextAlignmentCenter;
  
  _tableNumberTF.textAlignment = NSTextAlignmentCenter;
  _tableNumberTF.font = [_style fontForKey:@"tableNumberFieldFont"];
  _tableNumberTF.textColor = [_style colorForKey:@"tableNumberFieldColor"];
  _tableNumberTF.rightViewMode = UITextFieldViewModeAlways;
  
  _switchLabel.font = [_style fontForKey:@"switchLabelFont"];
  _switchLabel.text = [_style stringForKey:@"switchLabelText"];
  _switchLabel.textColor = [_style colorForKey:@"switchLabelColor"];
  
  _qrScanButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
  [_qrScanButton addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
  _tableNumberTF.rightView = _qrScanButton;
  
  _switch.hidden = YES;
  _switchLabel.hidden = YES;
  
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {

    switch (state) {
      case CBCentralManagerStatePoweredOn: {
        
        _switch.hidden = NO;
        _switchLabel.hidden = NO;

      } break;
      default: {
  
        _tableNumberTF.rightView = _qrScanButton;
        
      } break;
    }

    [self updateTableNumberField];
    
  }];
  
}

- (void)scanQRCode {
  
  OMNScanQRCodeVC *scanQRCodeVC = [[OMNScanQRCodeVC alloc] init];
  scanQRCodeVC.delegate = self;
  [self.navigationController pushViewController:scanQRCodeVC animated:YES];
  
}

#pragma mark - OMNScanQRCodeVCDelegate

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code {

  _tableNumberTF.text = code;
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC {
  [self.navigationController popToViewController:self animated:YES];
}

- (void)updateTableNumberField {
  
  BOOL enterTableNumberEnabled = (NO == _switch.on || _switch.hidden);
  
  _tableNumberTF.enabled = enterTableNumberEnabled;
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

@end
