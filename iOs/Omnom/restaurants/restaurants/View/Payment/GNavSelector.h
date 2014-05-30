//
//  GNavSelector.h
//  seocialtest
//
//  Created by tea on 21.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNavSelector : UIControl

@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initTitles:(NSArray *)titles;

@end
