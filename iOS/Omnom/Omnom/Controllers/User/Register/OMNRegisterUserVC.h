//
//  OMNRegisterUserVC.h
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorization.h"

@interface OMNRegisterUserVC : UIViewController

@property (nonatomic, copy) OMNAuthorizationBlock authorizationBlock;
@property (nonatomic, copy) dispatch_block_t cancelBlock;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;

@end

