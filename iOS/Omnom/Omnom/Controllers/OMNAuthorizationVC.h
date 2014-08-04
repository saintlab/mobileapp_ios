//
//  OMNStartVC.h
//  restaurants
//
//  Created by tea on 20.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWizardVC.h"

@protocol OMNAuthorizationVCDelegate;

@interface OMNAuthorizationVC : OMNWizardVC

@property (nonatomic, weak) id<OMNAuthorizationVCDelegate> delegate;

@end

@protocol OMNAuthorizationVCDelegate <NSObject>

- (void)authorizationVCDidReceiveToken:(OMNAuthorizationVC *)startVC;

@end
