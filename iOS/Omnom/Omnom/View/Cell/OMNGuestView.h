//
//  OMNGuestView.h
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNGuest.h"

extern NSString * const OMNGuestViewIdentifier;

@interface OMNGuestView : UITableViewHeaderFooterView

@property (nonatomic, strong) OMNGuest *guest;

@end
