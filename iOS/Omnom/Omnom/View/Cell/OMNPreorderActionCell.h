//
//  OMNPreorderActionCell.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OMNPreorderActionCellDelegate;

@interface OMNPreorderActionCell : UITableViewCell

@property (nonatomic, weak) id <OMNPreorderActionCellDelegate> delegate;
@property (nonatomic, strong, readonly) UIButton *actionButton;

@end

@protocol OMNPreorderActionCellDelegate <NSObject>

- (void)preorderActionCellDidOrder:(OMNPreorderActionCell *)preorderActionCell;
- (void)preorderActionCellDidClear:(OMNPreorderActionCell *)preorderActionCell;

@end