//
//  OMNNavigationPermissionsHelpVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCLPermissionsHelpVC.h"
#import "OMNUtils.h"

@implementation OMNCLPermissionsHelpVC

- (instancetype)init {
  
  NSArray *pages = nil;
  
  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    
    pages =
    @[
      [OMNHelpPage pageWithText:kOMN_LOCATION_PERMISSION_HELP_TEXT_1_7 imageName:@"navigation_help_1-7"],
      [OMNHelpPage pageWithText:kOMN_LOCATION_PERMISSION_HELP_TEXT_2_7 imageName:@"navigation_help_2-7"],
      [OMNHelpPage pageWithText:kOMN_LOCATION_PERMISSION_HELP_TEXT_3_7 imageName:@"navigation_help_3-7"],
      ];
    
  } else if (SYSTEM_VERSION_LESS_THAN(@"8.1")) {
    
    pages =
    @[
      [OMNHelpPage pageWithText:kOMN_LOCATION_PERMISSION_HELP_TEXT_1_8 imageName:@"navigation_help_1-8"],
      [OMNHelpPage pageWithText:kOMN_LOCATION_PERMISSION_HELP_TEXT_2_8 imageName:@"navigation_help_2-8"],
      [OMNHelpPage pageWithText:kOMN_LOCATION_PERMISSION_HELP_TEXT_3_8 imageName:@"navigation_help_3-8"],
      ];

  }
  else {
    
    pages =
    @[
      [OMNHelpPage pageWithText:kOMN_LOCATION_PERMISSION_HELP_TEXT_1_8_1 imageName:@"navigation_help_1-81"],
      [OMNHelpPage pageWithText:kOMN_LOCATION_PERMISSION_HELP_TEXT_2_8_1 imageName:@"navigation_help_2-81"],
      ];
    
  }

  self = [super initWithPages:pages];
  if (self) {
    self.showSettingsButton = YES;
  }
  return self;
}


@end
