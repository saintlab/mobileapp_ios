//
//  AFHTTPResponseSerializer+omn_headers.h
//  omnom
//
//  Created by tea on 30.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <AFURLRequestSerialization.h>

@interface AFHTTPRequestSerializer (omn_headers)

- (void)omn_addCustomHeaders;

@end
