//
//  OMNUserProfileView.h
//  omnom
//
//  Created by tea on 14.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNUserIconView.h"

@interface OMNUserProfileView : UIView

@property (nonatomic, strong, readonly) OMNUserIconView *iconView;

- (void)omn_addObservers;

@end
