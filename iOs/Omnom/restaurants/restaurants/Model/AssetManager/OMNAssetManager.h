//
//  OMNAssetManager.h
//  fontTest
//
//  Created by tea on 04.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNAssetManager : NSObject

+ (instancetype)manager;

+ (void)updateWithManager:(OMNAssetManager *)manager;

- (UIFont *)navBarTitleFont;

- (UIFont *)navBarButtonFont;

- (UIFont *)navBarSelectorDefaultFont;

- (UIFont *)navBarSelectorSelectedFont;

- (UIFont *)splitCellFont;

- (UIFont *)splitTotalFont;

@end
