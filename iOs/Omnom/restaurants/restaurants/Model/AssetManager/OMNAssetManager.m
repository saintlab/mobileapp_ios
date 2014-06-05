//
//  OMNAssetManager.m
//  fontTest
//
//  Created by tea on 04.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAssetManager.h"

static OMNAssetManager *_manager = nil;

@implementation OMNAssetManager

+ (instancetype)manager {
  return _manager;
}

+ (void)updateWithManager:(OMNAssetManager *)manager {
  _manager = manager;
}

- (UIFont *)navBarTitleFont {
  return nil;
}

- (UIFont *)navBarButtonFont {
  return nil;
}

- (UIFont *)navBarSelectorDefaultFont {
  return nil;
}

- (UIFont *)navBarSelectorSelectedFont {
  return nil;
}

- (UIFont *)splitCellFont {
  return nil;
}

- (UIFont *)splitTotalFont {
  return nil;
}

@end
