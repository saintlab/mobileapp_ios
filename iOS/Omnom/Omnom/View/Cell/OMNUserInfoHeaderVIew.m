//
//  OMNUserInfoHeaderVIew.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoHeaderView.h"
#import <OMNStyler.h>

@implementation OMNUserInfoHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithReuseIdentifier:reuseIdentifier];
  if (self) {
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    _label = [[UILabel alloc] init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.font = FuturaOSFOmnomRegular(15.0f);
    _label.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
    [self addSubview:_label];
    
    NSDictionary *views =
    @{
      @"label" : _label,
      };
    
    NSDictionary *metrics =
    @{
      @"leftOffset" : @(OMNStyler.leftOffset),
      @"bottomOffset" : @(10.0f),
      };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-(bottomOffset)-|" options:kNilOptions metrics:metrics views:views]];
    
    UIView *downSeporator = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.frame)-0.5f, CGRectGetWidth(self.frame), 0.5f)];
    downSeporator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    downSeporator.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
    [self addSubview:downSeporator];

  }
  return self;
}

@end
