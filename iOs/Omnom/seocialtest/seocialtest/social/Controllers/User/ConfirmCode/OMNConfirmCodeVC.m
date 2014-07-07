//
//  OMNConfirmCodeVC.m
//  restaurants
//
//  Created by tea on 17.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNConfirmCodeVC.h"
#import "OMNEnterCodeView.h"
#import "OMNUser.h"

@interface OMNConfirmCodeVC ()

@end

@implementation OMNConfirmCodeVC {

  __weak IBOutlet OMNEnterCodeView *_codeView;
  __weak IBOutlet UILabel *_helpLabel;
  
  IBOutletCollection(UIButton) NSArray *_buttons;
  
  NSMutableString *_code;
  
  NSString *_phone;
}

- (instancetype)initWithPhone:(NSString *)phone {
  self = [super initWithNibName:@"OMNConfirmCodeVC" bundle:nil];
  if (self) {
    _phone = phone;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _code = [NSMutableString stringWithString:@""];
  
  [_buttons enumerateObjectsUsingBlock:^(UIButton *b, NSUInteger idx, BOOL *stop) {
    
    [b addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    
  }];

}

- (void)resetAnimated:(BOOL)animated {
  
  [_code setString:@""];
  
  
  
  if (animated) {
    
    const CGFloat offset = 5.0f;
    _codeView.transform = CGAffineTransformMakeTranslation(-offset, 0.0f);
    [UIView animateWithDuration:0.1 delay:0. options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
      [UIView setAnimationRepeatCount:2];
      
      _codeView.transform = CGAffineTransformMakeTranslation(offset, 0.0f);
      
    } completion:^(BOOL finished) {
      
      _codeView.transform = CGAffineTransformIdentity;
      
    }];
  }
  
  _codeView.code = @"";
  
}

- (void)tap:(UIButton *)b {
  
  if (_code.length >= 4) {
    return;
  }
  
  if (b.tag == -1) {
    
    if (_code.length) {
      [_code deleteCharactersInRange:NSMakeRange(_code.length - 1, 1)];
    }
    
  }
  else {
    
    [_code appendFormat:@"%ld", (long)b.tag];
    
  }
  
  _codeView.code = _code;
  
  if (4 == _code.length) {
    
    [self submitCodeTap];
    
  }
  
}

- (void)submitCodeTap {
  
  [self.delegate confirmCodeVC:self didEnterCode:[_code copy]];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
