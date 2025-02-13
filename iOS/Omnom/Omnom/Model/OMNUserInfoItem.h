//
//  OMNUserInfoItem.h
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OMNUserInfoItemBlock)(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath);

@interface OMNUserInfoItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) UITableViewCellAccessoryType cellAccessoryType;
@property (nonatomic, strong) OMNUserInfoItemBlock actionBlock;

+ (instancetype)itemWithTitle:(NSString *)title actionBlock:(OMNUserInfoItemBlock)actionBlock;

- (void)configureCell:(UITableViewCell *)cell;

@end
