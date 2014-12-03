//
//  OMNNavigationPermissionsHelpVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCLPermissionsHelpVC.h"
#import "OMNScrollExtendView.h"
#import "OMNUtils.h"
#import "OMNConstants.h"

@implementation OMNCLPermissionsHelpVC {
  
  UIView *_contentView;
  UILabel *_label;
  UIPageControl *_pageControl;
  UIScrollView *_scrollView;
  NSArray *_labelTexts;

}

- (instancetype)init {
  
  NSArray *pages = nil;
  
  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    
    pages =
    @[
      [OMNHelpPage pageWithText:NSLocalizedString(@"LOCATION_PERMISSION_HELP_TEXT_1-7", @"Чтобы разрешить геолокацию, откройте список приватности:") imageName:@"navigation_help_1-7"],
      [OMNHelpPage pageWithText:NSLocalizedString(@"LOCATION_PERMISSION_HELP_TEXT_2-7", @"Затем откройте\nСлужбы геолокации:") imageName:@"navigation_help_2-7"],
      [OMNHelpPage pageWithText:NSLocalizedString(@"LOCATION_PERMISSION_HELP_TEXT_3-7", @"Разрешите, наконец, использовать службы геолокации для Omnom:") imageName:@"navigation_help_3-7"],
      ];
    
  } else if (SYSTEM_VERSION_LESS_THAN(@"8.1")) {
    
    pages =
    @[
      [OMNHelpPage pageWithText:NSLocalizedString(@"LOCATION_PERMISSION_HELP_TEXT_1-8", @"Чтобы разрешить геолокацию, откройте Конфиденциальность:") imageName:@"navigation_help_1-8"],
      [OMNHelpPage pageWithText:NSLocalizedString(@"LOCATION_PERMISSION_HELP_TEXT_2-8", @"Затем откройте\nСлужбы геолокации:") imageName:@"navigation_help_2-8"],
      [OMNHelpPage pageWithText:NSLocalizedString(@"LOCATION_PERMISSION_HELP_TEXT_3-8", @"Разрешите доступ к геопозиции:") imageName:@"navigation_help_3-8"],
      ];

  }
  else {
    
    pages =
    @[
      [OMNHelpPage pageWithText:NSLocalizedString(@"LOCATION_PERMISSION_HELP_TEXT_1-8.1", @"Выберите меню\n«Геопозиция»:") imageName:@"navigation_help_1-81"],
      [OMNHelpPage pageWithText:NSLocalizedString(@"LOCATION_PERMISSION_HELP_TEXT_2-8.1", @"Разрешите доступ\nк геопозиции:") imageName:@"navigation_help_2-81"],
      ];
    
  }

  self = [super initWithPages:pages];
  if (self) {
    self.showSettingsButton = YES;
  }
  return self;
}


@end
