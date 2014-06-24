//
//  OMNFuturaAssetManager.m
//  fontTest
//
//  Created by tea on 04.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFuturaAssetManager.h"
#import "OMNConstants.h"

CGFloat kFuturaDeltaFontSize = 1.0f;

@implementation OMNFuturaAssetManager

- (UIFont *)navBarTitleFont {
  return FuturaMediumFont(18.0f + kFuturaDeltaFontSize);
}

- (UIFont *)navBarButtonFont {
  return FuturaBookFont(18.0f + kFuturaDeltaFontSize);
} 

- (UIFont *)navBarSelectorDefaultFont {
  return FuturaBookFont(16.0f + kFuturaDeltaFontSize);
}

- (UIFont *)navBarSelectorSelectedFont {
  return FuturaMediumFont(16.0f + kFuturaDeltaFontSize);
}

- (UIFont *)splitCellFont {
  return FuturaBookFont(16.0f + kFuturaDeltaFontSize);
}

- (UIFont *)splitTotalFont {
  return FuturaBookFont(21.0f + kFuturaDeltaFontSize);
}

@end
