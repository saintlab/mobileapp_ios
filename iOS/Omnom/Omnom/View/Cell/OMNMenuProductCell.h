//
//  OMNMenuProductCell.h
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProductSelectionItem.h"

@protocol OMNMenuProductCellDelegate;

@interface OMNMenuProductCell : UITableViewCell

@property (nonatomic, weak) id<OMNMenuProductCellDelegate> delegate;
@property (nonatomic, strong) OMNMenuProductSelectionItem *menuProductSelectionItem;

@end

@protocol OMNMenuProductCellDelegate <NSObject>

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell didSelectProduct:(OMNMenuProductSelectionItem *)menuProductSelectionItem;

@end