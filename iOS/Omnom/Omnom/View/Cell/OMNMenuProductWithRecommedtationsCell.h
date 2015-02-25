//
//  OMNMenuProductWithRecommedtationsCell.h
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProductWithRecommendationsCellItem.h"

@protocol OMNMenuProductWithRecommedtationsCellDelegate;

@interface OMNMenuProductWithRecommedtationsCell : UITableViewCell

@property (nonatomic, weak) id<OMNMenuProductWithRecommedtationsCellDelegate> delegate;
@property (nonatomic, strong) OMNMenuProductWithRecommendationsCellItem *item;

@end

@protocol OMNMenuProductWithRecommedtationsCellDelegate <NSObject>

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell didSelectItem:(OMNMenuProductCellItem *)item;
- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell editItem:(OMNMenuProductCellItem *)item;

@end