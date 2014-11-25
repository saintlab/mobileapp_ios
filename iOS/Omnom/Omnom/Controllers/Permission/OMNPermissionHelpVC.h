//
//  OMNPermissionHelpVC.h
//  omnom
//
//  Created by tea on 25.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNHelpPage.h"

@interface OMNPermissionHelpVC : OMNBackgroundVC

@property (nonatomic, strong, readonly) NSArray *pages;
@property (nonatomic, assign) BOOL showSettingsButton;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithPages:(NSArray *)pages;

@end
