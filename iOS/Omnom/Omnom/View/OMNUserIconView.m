//
//  OMNUserIconView.m
//  omnom
//
//  Created by tea on 05.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserIconView.h"
#import "UIImage+omn_helper.h"

@implementation OMNUserIconView

- (instancetype)init {
  self = [super init];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self omn_setup];
  
}

- (void)omn_setup {
  
  [self setBackgroundImage:[UIImage imageNamed:@"avatar_circle"] forState:UIControlStateNormal];
  
}

- (void)updateWithImage:(UIImage *)image {
  
  UIImage *circleImage = nil;
  if (image) {
    
    circleImage = [image omn_circleImageWithDiametr:CGRectGetWidth(self.frame)];
    
  }
  else {
    
    circleImage = [UIImage imageNamed:@"ic_default_user"];
    
  }
  
  [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    [self setImage:circleImage forState:UIControlStateNormal];
    
  } completion:nil];
  
}

@end
