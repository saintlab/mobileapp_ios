//
//  OMNMenuProductVC.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuProduct.h"
#import "OMNRestaurantMediator.h"

@interface OMNMenuProductVC : UITableViewController

@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator menuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products;

@end