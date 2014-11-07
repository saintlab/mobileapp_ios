//
//  OMNChangePhoneVC.m
//  omnom
//
//  Created by tea on 13.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNChangePhoneVC.h"
#import "OMNErrorTextField.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNUser.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNResetPasswordVC.h"

@implementation OMNChangePhoneVC {
  OMNErrorTextField *_phoneTF;
  UILabel *_hintLabel;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  _phoneTF.textField.placeholder = NSLocalizedString(@"Номер телефона", nil);
  _phoneTF.textField.keyboardType = UIKeyboardTypePhonePad;
  _hintLabel.text = NSLocalizedString(@"CHANGE_PHONE_HINT", @"Укажите Ваш предыдущий номер телефона");
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = NSLocalizedString(@"CHANGE_PHONE_TITLE", @"Изменение номера");
  [self setLoading:NO];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_phoneTF becomeFirstResponder];
  if (0 == _phoneTF.textField.text.length) {
    _phoneTF.textField.text = @"+7";
  }
  
}

- (void)setLoading:(BOOL)loading {
  
  if (loading) {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
  }
  else {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CHANGE_PHONE_NEXT_BUTTON_TITLE", @"Далее") style:UIBarButtonItemStylePlain target:self action:@selector(nextTap)];
  }
  
}

- (void)nextTap {
  
  [self setLoading:YES];
  
  __weak typeof(self)weakSelf = self;
  [OMNUser recoverUsingData:_phoneTF.textField.text completion:^{
    
    [weakSelf didResetPhone];
    
  } failure:^(NSError *error) {
    
    [weakSelf handleError:error];
    
  }];
  
}

- (void)didResetPhone {
  
  OMNResetPasswordVC *resetPasswordVC = [[OMNResetPasswordVC alloc] init];
  __weak typeof(self)weakSelf = self;
  resetPasswordVC.completionBlock = ^{
    [weakSelf didFinishReset];
  };
  [self.navigationController pushViewController:resetPasswordVC animated:YES];
  
}

- (void)didFinishReset {
  
  [self.delegate changePhoneVCDidFinish:self];
  
}

- (void)handleError:(NSError *)error {
  
  [self setLoading:NO];
  [_phoneTF setErrorText:error.localizedDescription];
  
}

- (void)omn_setup {
  
  _hintLabel = [[UILabel alloc] init];
  _hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _hintLabel.numberOfLines = 0;
  _hintLabel.textAlignment = NSTextAlignmentCenter;
  _hintLabel.textColor = colorWithHexString(@"787878");
  _hintLabel.font = FuturaOSFOmnomRegular(20.0f);
  [self.view addSubview:_hintLabel];

  _phoneTF = [[OMNErrorTextField alloc] init];
  [self.view addSubview:_phoneTF];
  
  NSDictionary *views =
  @{
    @"phoneTF" : _phoneTF,
    @"hintLabel" : _hintLabel,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[hintLabel]-|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[phoneTF]-|" options:0 metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-(20)-[hintLabel]-[phoneTF]" options:0 metrics:nil views:views]];
  
}

@end