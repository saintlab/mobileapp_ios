//
//  OMNNavigationBarProgressView.h
//  omnom
//
//  Created by tea on 06.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNNavigationBarProgressView : UIView

- (instancetype)initWithText:(NSString *)text count:(NSInteger)count;
- (void)setPage:(NSInteger)page;

@end
