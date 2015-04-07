//
//  OMNPreorderActionCell.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNPreorderActionCellItem.h"

@interface OMNPreorderActionCell : UITableViewCell

@property (nonatomic, strong, readonly) UIButton *actionButton;
@property (nonatomic, strong, readonly) UIButton *refreshButton;
@property (nonatomic, strong, readonly) UIButton *clearButton;
@property (nonatomic, strong, readonly) UILabel *refreshLabel;
@property (nonatomic, strong, readonly) UILabel *hintLabel;

@property (nonatomic, strong) OMNPreorderActionCellItem *item;

@end

