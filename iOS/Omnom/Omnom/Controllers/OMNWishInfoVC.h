//
//  OMNWishInfoVC.h
//  omnom
//
//  Created by tea on 27.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNWishInfoVC : UITableViewController

- (instancetype)initWithWishID:(NSString *)wishID;
- (void)show:(UIViewController *)presentingVC;

@end
