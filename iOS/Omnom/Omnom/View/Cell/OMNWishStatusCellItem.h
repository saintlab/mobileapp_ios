//
//  OMNWishStatusCellItem.h
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"
#import "OMNWish.h"

@interface OMNWishStatusCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, strong) OMNWish *wish;

@end
