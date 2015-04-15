//
//  OMNUserInfoCell.h
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNUserInfoItem.h"

@interface OMNUserInfoCell : UITableViewCell

@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, strong) OMNUserInfoItem *item;

@end
