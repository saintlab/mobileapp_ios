//
//  OMNMenuCategoriesModelSpec.m
//  omnom
//
//  Created by tea on 27.04.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNMenuCategoriesModel.h"
#import "NSString+omn_json.h"
#import "OMNMenuCategoryDelimiterCell.h"
#import "OMNMenuProductsDelimiterCell.h"
#import "NSIndexSet+omn_helper.h"
#import "NSIndexPath+omn_helper.h"

SPEC_BEGIN(OMNMenuCategoriesModelSpec)

describe(@"OMNMenuCategoriesModel", ^{

  __block OMNMenuCategoriesModel *_model;
  __block OMNMenu *_menu;
  __block UITableView *_tableView;

  beforeAll(^{
    
    id menuData = [@"menu_stub.json" omn_jsonObjectNamedForClass:self.class];
    _menu =[[OMNMenu alloc] initWithJsonData:menuData[@"menu"]];
    _model = [[OMNMenuCategoriesModel alloc] initWithMenu:_menu cellDelegate:nil headerDelegate:nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 500.0f) style:UITableViewStylePlain];
    
    [_model configureTableView:_tableView];
    [_model updateWithInitialVisibleCategories:nil completion:^(OMNTableReloadData *tableReloadData) {
      
      [_tableView reloadData];
      
    }];
    
  });
  
  it(@"should check menu and model", ^{
    
    [[_menu should] beNonNil];
    [[_model should] beNonNil];
    
  });

  it(@"should check cell creation", ^{
    
    id cell1 = [_tableView dequeueReusableCellWithIdentifier:@"OMNMenuProductWithRecommedtationsCell"];
    [[cell1 should] beKindOfClass:[OMNMenuProductWithRecommedtationsCell class]];
    
    id cell3 = [_tableView dequeueReusableCellWithIdentifier:@"OMNMenuCategoryDelimiterCell"];
    [[cell3 should] beKindOfClass:[OMNMenuCategoryDelimiterCell class]];

    id cell4 = [_tableView dequeueReusableCellWithIdentifier:@"OMNMenuProductsDelimiterCell"];
    [[cell4 should] beKindOfClass:[OMNMenuProductsDelimiterCell class]];

  });
  
  context(@"selection", ^{
    
    beforeAll(^{
      
      [_model closeAllCategoriesWithCompletion:^(OMNTableReloadData *tableReloadData) {
      }];
      
    });
    
    it(@"should check initial state", ^{

      [[_model.allCategories should] haveCountOf:13];
      [[_model.visibleCategories should] haveCountOf:4];
      
    });
    
    it(@"should select and deselect first item", ^{
      
      
      OMNMenuCategorySectionItem *firstItem = [_model.allCategories firstObject];
      
      [_model selectMenuCategoryItem:firstItem withCompletion:^(OMNTableReloadData *tableReloadData) {
        
        [[tableReloadData.insertedIndexes should] equal:[NSIndexSet omn_setWithString:@"1"]];
        [[tableReloadData.deletedIndexes should] equal:[NSIndexSet indexSet]];
        [[tableReloadData.deletedIndexPaths should] equal:[NSIndexPath omn_indexPathsWithRows:[NSIndexSet omn_setWithString:@"0"] inSection:0]];
        [[tableReloadData.insertedIndexPaths should] equal:[NSIndexPath omn_indexPathsWithRows:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 7)] inSection:0]];
        
        [[_model.allCategories should] haveCountOf:13];
        [[_model.visibleCategories should] haveCountOf:5];
        
      }];
      
      [_model selectMenuCategoryItem:firstItem withCompletion:^(OMNTableReloadData *tableReloadData) {
        
        [[tableReloadData.insertedIndexes should] equal:[NSIndexSet indexSet]];
        [[tableReloadData.deletedIndexes should] equal:[NSIndexSet omn_setWithString:@"1"]];
        [[tableReloadData.insertedIndexPaths should] equal:[NSIndexPath omn_indexPathsWithRows:[NSIndexSet omn_setWithString:@"0"] inSection:0]];
        [[tableReloadData.deletedIndexPaths should] equal:[NSIndexPath omn_indexPathsWithRows:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 7)] inSection:0]];

        [[_model.allCategories should] haveCountOf:13];
        [[_model.visibleCategories should] haveCountOf:4];

      }];
      
    });
    
    it(@"should select and deselect last item", ^{
      
      OMNMenuCategorySectionItem *last = [_model.visibleCategories lastObject];
      [_model selectMenuCategoryItem:last withCompletion:^(OMNTableReloadData *tableReloadData) {
        
        [[tableReloadData.insertedIndexes should] equal:[NSIndexSet omn_setWithString:@"4"]];
        [[tableReloadData.deletedIndexes should] equal:[NSIndexSet indexSet]];
        [[tableReloadData.deletedIndexPaths should] equal:[NSIndexPath omn_indexPathsWithRows:[NSIndexSet omn_setWithString:@"0"] inSection:3]];
        [[tableReloadData.insertedIndexPaths should] equal:[NSIndexPath omn_indexPathsWithRows:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)] inSection:3]];
        
        [[_model.allCategories should] haveCountOf:13];
        [[_model.visibleCategories should] haveCountOf:5];
        
      }];
      
      [_model selectMenuCategoryItem:last withCompletion:^(OMNTableReloadData *tableReloadData) {
        
        [[tableReloadData.insertedIndexes should] equal:[NSIndexSet indexSet]];
        [[tableReloadData.deletedIndexes should] equal:[NSIndexSet omn_setWithString:@"4"]];
        [[tableReloadData.insertedIndexPaths should] equal:[NSIndexPath omn_indexPathsWithRows:[NSIndexSet omn_setWithString:@"0"] inSection:3]];
        [[tableReloadData.deletedIndexPaths should] equal:[NSIndexPath omn_indexPathsWithRows:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)] inSection:3]];
        
        [[_model.allCategories should] haveCountOf:13];
        [[_model.visibleCategories should] haveCountOf:4];
        
      }];
      
    });
    
  });
  
});

SPEC_END
