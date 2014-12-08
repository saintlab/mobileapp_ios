//
//  OMNUserInfoModel.h
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"
#import "OMNVisitor.h"
#import "OMNUserInfoItem.h"

typedef UIViewController *(^OMNUserInfoDidSelectBlock)(UITableView *tableView, NSIndexPath *indexPath);

@interface OMNUserInfoModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNUserInfoDidSelectBlock didSelectBlock;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor;
- (void)reloadUserInfo;

@end
