//
//  GTableVC.h
//  beacon
//
//  Created by tea on 05.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNBeacon;
@protocol GTableVCDelegate;

@interface GTableVC : UIViewController

@property (nonatomic, weak) id<GTableVCDelegate> delegate;

- (instancetype)initWithBeacon:(OMNBeacon *)beacon;

@end

@protocol GTableVCDelegate <NSObject>

- (void)tableVCDidFinish:(GTableVC *)tableVC;

@end