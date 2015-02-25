//
//  OMNMenuProductsDelimiter.h
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuTableCellItemProtocol.h"

typedef NS_ENUM(NSInteger, OMNMenuProductsDelimiterType) {
  kMenuProductsDelimiterTypeNone,
  kMenuProductsDelimiterTypeGray,
};

@interface OMNMenuProductsDelimiterCellItem : NSObject
<OMNMenuTableCellItemProtocol>

@property (nonatomic, assign) OMNMenuProductsDelimiterType type;
@property (nonatomic, assign) BOOL selected;

@end
