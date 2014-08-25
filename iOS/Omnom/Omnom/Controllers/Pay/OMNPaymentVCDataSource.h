//
//  GPaymentVCDataSource.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNOrder;

@interface OMNPaymentVCDataSource : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, assign) BOOL showTotalView;

- (instancetype)initWithOrder:(OMNOrder *)order;

@end
