//
//  GAmountPercentControl.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol GAmountPercentControlDelegate;

@interface OMNAmountPercentControl : UIControl

@property (nonatomic, weak) id<GAmountPercentControlDelegate> delegate;

@property (nonatomic, assign) double currentAmount;

@property (nonatomic, assign, readonly) double selectedAmount;

@property (nonatomic, assign, readonly) double selectedPercent;

- (void)reset;

@end

@protocol GAmountPercentControlDelegate <NSObject>

- (double)expectedValueForAmountPercentControl:(OMNAmountPercentControl *)amountPercentControl;

- (double)enteredValueForAmountPercentControl:(OMNAmountPercentControl *)amountPercentControl;

@end


