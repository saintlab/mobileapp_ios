//
//  GPaymentVCDataSource.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class GOrder;

@interface GPaymentVCDataSource : NSObject
<UITableViewDataSource,
UITableViewDelegate>

- (instancetype)initWithOrder:(GOrder *)order;

@end
