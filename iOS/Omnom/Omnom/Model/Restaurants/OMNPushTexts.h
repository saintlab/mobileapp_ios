//
//  OMNPushTexts.h
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPushText.h"

@interface OMNPushTexts : NSObject

@property (nonatomic, strong) OMNPushText *at_entrance;
@property (nonatomic, strong) OMNPushText *before_cheque;

- (instancetype)initWithJsonData:(id)jsonData;

@end
