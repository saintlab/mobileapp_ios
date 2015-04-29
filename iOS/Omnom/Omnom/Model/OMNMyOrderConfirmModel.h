//
//  OMNMyOrderConfirmModel.h
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNWishMediator.h"
#import "OMNPreorderActionCellItem.h"
#import "OMNPreorderConfirmCellItem.h"

typedef void(^OMNReloadSectionsBlock)(NSIndexSet *indexes, BOOL animated);

@interface OMNMyOrderConfirmModel : NSObject
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, copy) OMNReloadSectionsBlock reloadSectionsBlock;
@property (nonatomic, assign) BOOL loading;

- (instancetype)initWithWishMediator:(OMNWishMediator *)wishMediator actionDelegate:(id<OMNPreorderActionCellDelegate>)actionDelegate preorderDelegate:(id<OMNPreorderConfirmCellDelegate>)preorderDelegate;
- (void)loadTableProductItemsWithCompletion:(dispatch_block_t)completionBlock;
- (void)updatePreorderedProductsAnimated:(BOOL)animated;
- (void)removeForbiddenProducts:(OMNForbiddenWishProducts *)forbiddenWishProducts;
- (void)configureTableView:(UITableView *)tableView;

@end
