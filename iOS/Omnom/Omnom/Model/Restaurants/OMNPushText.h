//
//  OMNPushText.h
//  omnom
//
//  Created by tea on 29.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNPushText : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *greeting;
@property (nonatomic, copy) NSString *open_action;

- (instancetype)initWithJsonData:(id)jsonData;

@end
