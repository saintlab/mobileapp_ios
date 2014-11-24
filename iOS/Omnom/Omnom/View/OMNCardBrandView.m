//
//  OMNCardBrandView.m
//  omnom
//
//  Created by tea on 15.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCardBrandView.h"

@implementation OMNCardBrandView

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (UIImageView *)addImageViewWithImageName:(NSString *)imageName {
  
  UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
  iv.translatesAutoresizingMaskIntoConstraints = NO;
  iv.contentMode = UIViewContentModeCenter;
  [self addSubview:iv];
  return iv;
  
}

- (UIView *)seporatorView {
  
  UIView *view = [[UIView alloc] init];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  view.hidden = YES;
  [self addSubview:view];
  return view;
  
}

- (void)setup {

  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  UIImageView *iv1 = [self addImageViewWithImageName:@"mail_ru_icon"];
  UIImageView *iv2 = [self addImageViewWithImageName:@"alfa_bank_icon"];
  UIImageView *iv3 = [self addImageViewWithImageName:@"verified_by_visa_icon"];
  UIImageView *iv4 = [self addImageViewWithImageName:@"master_card_secure_code_icon"];
  
  UIView *sv1 = [self seporatorView];
  UIView *sv2 = [self seporatorView];
  UIView *sv3 = [self seporatorView];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(iv1, iv2, iv3, iv4, sv1, sv2, sv3);
  NSDictionary *metrics =
  @{
    @"height" : @(70.0f)
    };
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iv1][sv1(>=0)][iv2][sv2(==sv1)][iv3][sv3(==sv1)][iv4]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iv1(height)]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iv2(height)]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iv3(height)]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iv4(height)]|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
