//
//  OMNPreorderActionCellItem.h
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"

@protocol OMNPreorderActionCellDelegate;
@class OMNPreorderActionCell;

@interface OMNPreorderActionCellItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, copy) NSString *actionText;
@property (nonatomic, copy) NSString *hintText;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, weak) id<OMNPreorderActionCellDelegate> delegate;

@end


@protocol OMNPreorderActionCellDelegate <NSObject>

- (void)preorderActionCellDidOrder:(OMNPreorderActionCell *)preorderActionCell;
- (void)preorderActionCellDidClear:(OMNPreorderActionCell *)preorderActionCell;
- (void)preorderActionCellDidRefresh:(OMNPreorderActionCell *)preorderActionCell;

@end