//
//  OMNOrderToolbarButton.h
//  omnom
//
//  Created by tea on 17.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNOrderToolbarButton : UIButton

- (instancetype)initWithTotalAmount:(long long)totalAmount  target:(id)target action:(SEL)action;

@end
