//
//  NSArray+omn_tableHelperSpec.m
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSArray+omn_tableHelper.h"


SPEC_BEGIN(NSArray_omn_tableHelperSpec)

describe(@"NSArray+omn_tableHelper", ^{

  it(@"should check deletion", ^{
    
    NSArray *a = @[@"0", @"1", @"2"];
    NSArray *b = @[@"1", @"2"];
    
    [a omn_compareToArray:b withCompletion:^(OMNTableReloadData *tableReloadData) {
      
      [[tableReloadData.deletedIndexes should] equal:[NSIndexSet indexSetWithIndex:0]];
      [[tableReloadData.insertedIndexes should] beEmpty];
      [[tableReloadData.reloadIndexes should] equal:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];

    }];
    
  });
  
  it(@"should check equal", ^{
    
    NSArray *a = @[@"0", @"1", @"2"];
    NSArray *b = @[@"0", @"1", @"2"];
    
    [a omn_compareToArray:b withCompletion:^(OMNTableReloadData *tableReloadData) {
      
      [[tableReloadData.deletedIndexes should] beEmpty];
      [[tableReloadData.insertedIndexes should] beEmpty];
      [[tableReloadData.reloadIndexes should] equal:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
      
    }];
    
  });
  
  it(@"should check insertion", ^{
    
    NSArray *a = @[@"0"];
    NSArray *b = @[@"0", @"1", @"2"];
    
    [a omn_compareToArray:b withCompletion:^(OMNTableReloadData *tableReloadData) {
      
      [[tableReloadData.deletedIndexes should] beEmpty];
      [[tableReloadData.insertedIndexes should] equal:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
      [[tableReloadData.reloadIndexes should] equal:[NSIndexSet indexSetWithIndex:0]];

    }];
    
  });
  
  
  it(@"should check insertion + deletion", ^{
    
    NSArray *a = @[@"0", @"1", @"2"];
    NSArray *b = @[@"0", @"5"];
    
    [a omn_compareToArray:b withCompletion:^(OMNTableReloadData *tableReloadData) {
      
      [[tableReloadData.deletedIndexes should] equal:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
      [[tableReloadData.insertedIndexes should] equal:[NSIndexSet indexSetWithIndex:1]];
      [[tableReloadData.reloadIndexes should] equal:[NSIndexSet indexSetWithIndex:0]];

    }];
    
  });
  
});

SPEC_END
