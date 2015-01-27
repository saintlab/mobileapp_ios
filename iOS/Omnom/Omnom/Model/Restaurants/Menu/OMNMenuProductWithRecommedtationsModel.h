//
//  OMNMenuProductWithRecommedtationsModel.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuProduct.h"
#import "OMNMenuProductCell.h"

@interface OMNMenuProductWithRecommedtationsModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong, readonly) OMNMenuProduct *menuProduct;
@property (nonatomic, weak) id<OMNMenuProductCellDelegate> delegate;

+ (void)registerCellsForTableView:(UITableView *)tableView;
- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products;
- (CGFloat)totalHeightForTableView:(UITableView *)tableView;

@end
