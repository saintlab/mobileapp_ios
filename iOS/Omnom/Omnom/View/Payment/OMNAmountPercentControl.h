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

@property (nonatomic, assign) long long currentAmount;

@property (nonatomic, assign, readonly) long long selectedAmount;

@property (nonatomic, assign, readonly) long long selectedPercent;

- (void)reset;

@end

@protocol GAmountPercentControlDelegate <NSObject>

- (long long)expectedValueForAmountPercentControl:(OMNAmountPercentControl *)amountPercentControl;

- (long long)enteredValueForAmountPercentControl:(OMNAmountPercentControl *)amountPercentControl;

@end


