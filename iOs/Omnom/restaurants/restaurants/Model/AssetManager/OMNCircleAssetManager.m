//
//  OMNCircleAssetManager.m
//  fontTest
//
//  Created by tea on 04.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleAssetManager.h"
#import "OMNConstants.h"

CGFloat kDeltaFontSize = 1.0f;

@implementation OMNCircleAssetManager

- (UIFont *)navBarTitleFont {
  return CirceRegularFont(17.0f + kDeltaFontSize);
}

- (UIFont *)navBarButtonFont {
  return CirceLightFont(17.0f + kDeltaFontSize);
}

- (UIFont *)navBarSelectorDefaultFont {
  return CirceLightFont(17.0f + kDeltaFontSize);
}

- (UIFont *)navBarSelectorSelectedFont {
  return CirceRegularFont(17.0f + kDeltaFontSize);
}

- (UIFont *)splitCellFont {
  return CirceRegularFont(15.0f + kDeltaFontSize);
}

- (UIFont *)splitTotalFont {
  return CirceRegularFont(20.0f + kDeltaFontSize);
}

@end
