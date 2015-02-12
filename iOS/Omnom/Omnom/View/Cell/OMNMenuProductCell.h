//
//  OMNMenuProductCell.h
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNMenuProduct.h"
#import "OMNMenuProductCellDelegate.h"

@interface OMNMenuProductCell : UITableViewCell

@property (nonatomic, weak) id<OMNMenuProductCellDelegate> delegate;
@property (nonatomic, strong) OMNMenuProduct *menuProduct;

@end

