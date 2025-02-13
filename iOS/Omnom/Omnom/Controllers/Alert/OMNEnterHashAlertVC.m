//
//  OMNEnterQRAlertVC.m
//  omnom
//
//  Created by tea on 13.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNEnterHashAlertVC.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNRestaurantManager.h"

@interface OMNEnterHashAlertVC ()
<UITextFieldDelegate>

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, assign) BOOL error;
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) UIView *lineView;
@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

@implementation OMNEnterHashAlertVC {
  
  UILabel *_urlLabel;
  NSLayoutConstraint *_keyboardHeightConstraint;
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createViews];
  [self configureViews];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [_textField becomeFirstResponder];
  
}

- (void)decodeHash:(NSString *)hash {
  
  _loading = YES;
  @weakify(self)
  [OMNRestaurantManager decodeHash:hash withCompletion:^(NSArray *restaurants) {
    
    @strongify(self)
    [self finishLoadingWithRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    @strongify(self)
    [self finishLoadingWithRestaurants:nil];
    
  }];
  
}

- (void)finishLoadingWithRestaurants:(NSArray *)restaurants {
  
  self.loading = NO;
  if (restaurants.count &&
      self.didFindRestaurantsBlock) {
    
    self.didFindRestaurantsBlock(restaurants);
    
  }
  else {
    
    self.error = YES;
    
  }
  
}

- (void)setError:(BOOL)error {
  
  _error = error;
  
  [UIView transitionWithView:self.contentView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    if (error) {
      
      self.textField.textColor = [OMNStyler redColor];
      self.textLabel.textColor = [OMNStyler redColor];
      self.textLabel.text = kOMN_HASH_DECODE_ERROR_TEXT;
      self.lineView.backgroundColor = [OMNStyler redColor];
      
    }
    else {
      
      self.textField.textColor = colorWithHexString(@"000000");
      self.textLabel.text = kOMN_HASH_DECODE_HELP_TEXT;
      self.textLabel.textColor = colorWithHexString(@"737478");
      self.lineView.backgroundColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.3f];
      
    }

  } completion:nil];
  
}


- (void)keyboardWillShow:(NSNotification *)n {
  
  CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  NSTimeInterval duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [self setKeyboardHeight:CGRectGetHeight(keyboardFrame) duration:duration];
  
}

- (void)keyboardWillHide:(NSNotification *)n {
  
  NSTimeInterval duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [self setKeyboardHeight:0.0f duration:duration];
  
}

- (void)setKeyboardHeight:(CGFloat)height duration:(NSTimeInterval)duration {
  
  _keyboardHeightConstraint.constant = height;
  @weakify(self)
  [UIView animateWithDuration:duration animations:^{
  
    @strongify(self)
    [self.contentView layoutIfNeeded];;
    
  }];
  
}

- (void)configureViews {
  
  _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _textField.autocorrectionType = UITextAutocorrectionTypeNo;
  _textField.font = FuturaLSFOmnomLERegular(20.0f);
  _textField.returnKeyType = UIReturnKeyDone;
  _textField.delegate = self;
  
  _textLabel.font = FuturaLSFOmnomLERegular(20.0f);
  _textLabel.numberOfLines = 0;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  
  _urlLabel.attributedText = [[NSAttributedString alloc] initWithString:@"http://omnom.menu/" attributes:
                              @{
                                NSFontAttributeName : FuturaLSFOmnomLERegular(20.0f),
                                NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.3f]
                                }];

  self.error = NO;
  
}

- (void)createViews {
  
  self.contentView.userInteractionEnabled = YES;
  
  _textLabel = [UILabel omn_autolayoutView];
  [self.contentView addSubview:_textLabel];
  
  UIView *urlContentView = [UIView omn_autolayoutView];
  urlContentView.userInteractionEnabled = YES;
  [self.contentView addSubview:urlContentView];
  
  _urlLabel = [UILabel omn_autolayoutView];
  [urlContentView addSubview:_urlLabel];
  
  _textField = [UITextField omn_autolayoutView];
  [urlContentView addSubview:_textField];

  _lineView = [UIView omn_autolayoutView];
  [self.contentView addSubview:_lineView];
  
  UIView *keyboardView = [UIView omn_autolayoutView];
  [self.contentView addSubview:keyboardView];
  
  NSDictionary *views =
  @{
    @"keyboardView" : keyboardView,
    @"textField" : _textField,
    @"urlLabel" : _urlLabel,
    @"urlContentView" : urlContentView,
    @"textLabel" : _textLabel,
    @"lineView" : _lineView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:urlContentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  [urlContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[urlLabel][textField(>=10)]|" options:kNilOptions metrics:metrics views:views]];
  [urlContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[urlLabel]|" options:kNilOptions metrics:metrics views:views]];
  [urlContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField]|" options:kNilOptions metrics:metrics views:views]];
  
  _keyboardHeightConstraint = [NSLayoutConstraint constraintWithItem:keyboardView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
  [self.contentView addConstraint:_keyboardHeightConstraint];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:urlContentView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-2.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:urlContentView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textLabel(>=50)]-(leftOffset)-[urlContentView]-(1)-[lineView(1)]-(leftOffset)-[keyboardView]|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  if (self.loading) {
    return NO;
  }

  if (self.error) {
    self.error = NO;
  }

  NSString *finalText = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  if (finalText.length <=6) {
    
    textField.text = finalText;
    
  }
  
  return NO;
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  if (textField.text.length &&
      !self.loading) {
    
    [self decodeHash:textField.text];
    
  }

  return YES;
  
}

@end
