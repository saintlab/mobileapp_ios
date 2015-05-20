//
//  OMNMenuProductWithRecommendationsCellItem.h
//  omnom
//
//  Created by tea on 19.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuProduct.h"
#import "OMNCellItemProtocol.h"
#import "OMNMenuProductsDelimiterCellItem.h"
#import "OMNMenuProductCellItem.h"

@protocol OMNMenuProductWithRecommedtationsCellDelegate;
@class OMNMenuProductCell;
@class OMNMenuProductWithRecommedtationsCell;

@interface OMNMenuProductWithRecommendationsCellItem : NSObject
<OMNCellItemProtocol,
UITableViewDataSource,
UITableViewDelegate,
OMNMenuProductCellDelegate>

@property (nonatomic, strong, readonly) OMNMenuProduct *menuProduct;
@property (nonatomic, strong, readonly) NSMutableArray *recommendationItems;
@property (nonatomic, weak) id<OMNMenuProductWithRecommedtationsCellDelegate> recommedtationItemDelegate;
@property (nonatomic, weak) id<OMNMenuProductCellDelegate> productItemDelegate;
@property (nonatomic, strong) OMNMenuProductCellItem *menuProductCellItem;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, weak) OMNMenuProductsDelimiterCellItem *bottomDelimiter;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products;

+ (void)registerProductWithRecommendationsCellForTableView:(UITableView *)tableView;

@end


@protocol OMNMenuProductWithRecommedtationsCellDelegate <NSObject>

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell didSelectCell:(OMNMenuProductCell *)cell;
- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell editCell:(OMNMenuProductCell *)cell;

@end
