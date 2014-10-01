//
//  OMNBankCardCell.h
//  omnom
//
//  Created by tea on 01.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMNBankCard;

@interface OMNBankCardCell : UITableViewCell

- (void)setBankCard:(OMNBankCard *)bankCard selected:(BOOL)selected;

@end
