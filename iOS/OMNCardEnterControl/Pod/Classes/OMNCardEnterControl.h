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

@interface OMNCardEnterControl : UIView

@property (nonatomic, weak) id<OMNCardEnterControlDelegate> delegate;
@property (nonatomic, strong) NSString *pan;
@property (nonatomic, assign) BOOL saveButtonSelected;

- (void)setSaveButtonHidden:(BOOL)hidden;

@end

@protocol OMNCardEnterControlDelegate <NSObject>

- (void)cardEnterControl:(OMNCardEnterControl *)control didEnterCardData:(NSDictionary *)cardData;
- (void)cardEnterControlDidEnterFailCardData:(OMNCardEnterControl *)control;
- (void)cardEnterControlSaveButtonStateDidChange:(OMNCardEnterControl *)control;
- (void)cardEnterControlDidRequestScan:(OMNCardEnterControl *)control;

@end