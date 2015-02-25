//
//  OMNMenuCategoryHeaderView.h
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMNMenuCategorySectionItem;
@protocol OMNMenuCategoryHeaderViewDelegate;

@interface OMNMenuCategoryHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<OMNMenuCategoryHeaderViewDelegate> delegate;
@property (nonatomic, strong) OMNMenuCategorySectionItem *menuCategorySectionItem;

@end

@protocol OMNMenuCategoryHeaderViewDelegate <NSObject>

- (void)menuCategoryHeaderViewDidSelect:(OMNMenuCategoryHeaderView *)menuCategoryHeaderView;

@end