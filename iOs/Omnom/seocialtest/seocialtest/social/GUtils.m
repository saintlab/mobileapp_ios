//
//  GUtils.m
//  seocialtest
//
//  Created by tea on 19.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GUtils.h"



@implementation GUtils


UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve) {
  switch (curve) {
    case UIViewAnimationCurveEaseInOut:
      return UIViewAnimationOptionCurveEaseInOut;
    case UIViewAnimationCurveEaseIn:
      return UIViewAnimationOptionCurveEaseIn;
    case UIViewAnimationCurveEaseOut:
      return UIViewAnimationOptionCurveEaseOut;
    case UIViewAnimationCurveLinear:
      return UIViewAnimationOptionCurveLinear;
  }
}

@end
