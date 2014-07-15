//
//  OMNUserInfoModel.h
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"

@interface OMNUserInfoModel : NSObject
<UITableViewDataSource>

@property (nonatomic, strong) OMNUser *user;

- (void)controller:(UIViewController *)vc tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
