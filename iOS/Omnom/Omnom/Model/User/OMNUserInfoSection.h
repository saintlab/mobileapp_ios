//
//  OMNUserInfoSection.h
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNUserInfoSection : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, strong) NSArray *items;

@end
