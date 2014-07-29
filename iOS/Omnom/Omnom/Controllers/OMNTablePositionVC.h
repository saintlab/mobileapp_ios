//
//  OMNTablePositionVC.h
//  restaurants
//
//  Created by tea on 03.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@protocol OMNTablePositionVCDelegate;

@interface OMNTablePositionVC : OMNCircleRootVC

@property (nonatomic, weak) id<OMNTablePositionVCDelegate> tablePositionDelegate;

@end

@protocol OMNTablePositionVCDelegate <NSObject>

- (void)tablePositionVCDidPlaceOnTable:(OMNTablePositionVC *)tablePositionVC;

- (void)tablePositionVCDidCancel:(OMNTablePositionVC *)tablePositionVC;

@end