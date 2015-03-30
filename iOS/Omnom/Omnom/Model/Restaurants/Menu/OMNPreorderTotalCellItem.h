//
//  OMNPreorderTotalCellItem.h
//  omnom
//
//  Created by tea on 30.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"

@interface OMNPreorderTotalCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, assign) long long total;

@end
