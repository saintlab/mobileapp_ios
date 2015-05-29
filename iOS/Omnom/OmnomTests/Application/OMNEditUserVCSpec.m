//
//  OMNEditUserVCSpec.m
//  omnom
//
//  Created by tea on 28.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNEditUserVC.h"


SPEC_BEGIN(OMNEditUserVCSpec)

describe(@"OMNEditUserVC", ^{

  OMNEditUserVC *(^stubEditUserVC)() = ^OMNEditUserVC *() {
    
    OMNEditUserVC *editUserVC = [[OMNEditUserVC alloc] init];
    [editUserVC view];
    return editUserVC;
    
  };
  
  context(@"creation", ^{
    
    it(@"should create error label", ^{
      
      OMNEditUserVC *editUserVC = stubEditUserVC();
      [[editUserVC.errorLabel should] beNonNil];
      
    });
    
    it(@"number of lines of error message should be equal 0", ^{
      
      OMNEditUserVC *editUserVC = stubEditUserVC();
      [[theValue(editUserVC.errorLabel.numberOfLines) should] equal:theValue(0)];
      
    });
    
  });
  
});

SPEC_END
