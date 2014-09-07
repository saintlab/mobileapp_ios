//
//  OMNFeedItem.h
//  omnom
//
//  Created by tea on 20.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNFeedItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *Description;

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithJsonData:(id)jsonData;

- (void)logClickEvent;
- (void)logViewEvent;

@end
