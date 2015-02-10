//
//  OMNMenuProductsDelimiter.h
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuCellItemProtocol.h"

typedef NS_ENUM(NSInteger, OMNMenuProductsDelimiterType) {
  kMenuProductsDelimiterTypeNone,
  kMenuProductsDelimiterTypeGray,
  kMenuProductsDelimiterTypeRecommendations,
};

@interface OMNMenuProductsDelimiter : NSObject
<OMNMenuCellItemProtocol>

@property (nonatomic, assign) OMNMenuProductsDelimiterType type;

@end
