//
//  OMNUserInfoItem.h
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNCellItemProtocol.h"

typedef void(^OMNUserInfoItemBlock)(__weak UIViewController *vc, __weak UITableView *tv, NSIndexPath *indexPath);

@interface OMNUserInfoItem : NSObject
<OMNCellItemProtocol>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) UIControlContentHorizontalAlignment contentHorizontalAlignment;
@property (nonatomic, assign) UITableViewCellAccessoryType cellAccessoryType;
@property (nonatomic, copy) OMNUserInfoItemBlock actionBlock;

+ (instancetype)itemWithTitle:(NSString *)title actionBlock:(OMNUserInfoItemBlock)actionBlock;
- (instancetype)initWithTitle:(NSString *)title actionBlock:(OMNUserInfoItemBlock)actionBlock;

@end
