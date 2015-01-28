//
//  OMNMenuProductWithRecommedtationsCell.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProductWithRecommedtationsModel.h"

@protocol OMNMenuProductWithRecommedtationsCellDelegate;

@interface OMNMenuProductWithRecommedtationsCell : UITableViewCell

@property (nonatomic, weak) id<OMNMenuProductWithRecommedtationsCellDelegate> delegate;
@property (nonatomic, strong) OMNMenuProductWithRecommedtationsModel *model;

@end

@protocol OMNMenuProductWithRecommedtationsCellDelegate <NSObject>

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell didSelectMenuProduct:(OMNMenuProduct *)menuProduct;
- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell editMenuProduct:(OMNMenuProduct *)menuProduct;

@end