//
//  UIImage+omn_network.h
//  omnom
//
//  Created by tea on 27.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PromiseKit.h>

@interface UIImage (omn_network)

- (PMKPromise *)omn_upload;

@end
