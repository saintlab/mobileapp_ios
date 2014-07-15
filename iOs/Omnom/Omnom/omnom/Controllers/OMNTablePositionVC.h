//
//  OMNTablePositionVC.h
//  restaurants
//
//  Created by tea on 03.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNTablePositionVCDelegate;

@interface OMNTablePositionVC : UIViewController

@property (nonatomic, weak) id<OMNTablePositionVCDelegate> delegate;

@end

@protocol OMNTablePositionVCDelegate <NSObject>

- (void)tablePositionVCDidPlaceOnTable:(OMNTablePositionVC *)tablePositionVC;

- (void)tablePositionVCDidCancel:(OMNTablePositionVC *)tablePositionVC;

@end