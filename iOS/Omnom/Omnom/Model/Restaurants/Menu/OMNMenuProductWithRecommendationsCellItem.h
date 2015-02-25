//
//  OMNMenuProductWithRecommendationsCellItem.h
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuProduct.h"
#import "OMNMenuProductCell.h"
#import "OMNMenuTableCellItemProtocol.h"
#import "OMNMenuProductsDelimiterCellItem.h"

@interface OMNMenuProductWithRecommendationsCellItem : NSObject
<OMNMenuTableCellItemProtocol,
UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong, readonly) OMNMenuProduct *menuProduct;
@property (nonatomic, strong) OMNMenuProductCellItem *menuProductCellItem;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) id<OMNMenuProductCellDelegate> delegate;
@property (nonatomic, weak) OMNMenuProductsDelimiterCellItem *bottomDelimiter;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products;

+ (void)registerProductWithRecommendationsCellForTableView:(UITableView *)tableView;

@end
