//
//  OMNPreorderActionCell.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNPreorderActionCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t didOrderBlock;
@property (nonatomic, copy) dispatch_block_t didClearBlock;
@property (nonatomic, strong, readonly) UIButton *actionButton;

@end
