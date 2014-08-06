//
//  OMNCardEnterControl.h
//  cardEnterControl
//
//  Created by tea on 07.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OMNCardEnterControlDelegate;

extern NSString * const OMNCardEnterControlPanString;
extern NSString * const OMNCardEnterControlMonthString;
extern NSString * const OMNCardEnterControlYearString;
extern NSString * const OMNCardEnterControlCVVString;

@interface OMNDeletedTextField : UITextField

@end

@interface OMNCardEnterControl : UIView

@property (nonatomic, weak) id<OMNCardEnterControlDelegate> delegate;
@property (nonatomic, strong) NSString *pan;
@property (nonatomic, assign, readonly) BOOL saveButtonSelected;

@end

@protocol OMNCardEnterControlDelegate <NSObject>

- (void)cardEnterControl:(OMNCardEnterControl *)control didEnterCardData:(NSDictionary *)cardData;
- (void)cardEnterControlDidRequestScan:(OMNCardEnterControl *)control;

@end