//
//  OMNCalcaulcationTests.m
//  restaurants
//
//  Created by tea on 06.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OMNCalculationAmount.h"

@interface OMNCalcaulcationTests : XCTestCase

@end

@implementation OMNCalcaulcationTests {
  OMNCalculationAmount *_calculationAmount;
  NSArray *_tips;
}

- (void)setUp {
  [super setUp];
  
  //TODO: remove stub data
  OMNTip *tip1 = [[OMNTip alloc] initWithAmount:30. percent:10];
  OMNTip *tip2 = [[OMNTip alloc] initWithAmount:50. percent:15];
  OMNTip *tip3 = [[OMNTip alloc] initWithAmount:100. percent:20];
  OMNTip *tip4 = [[OMNTip alloc] initWithAmount:0. percent:0];

  _tips = @[tip1, tip2, tip3, tip4];
//  _calculationAmount = [[OMNCalculationAmount alloc] initWithTips:_tips tipsThreshold:250. total:1000.];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testInitState {

  XCTAssert(YES, @"Pass");
  XCTAssertEqual(_calculationAmount.totalValue, 1000., @"wrong total value");
  XCTAssertEqual(_calculationAmount.selectedTipIndex, -1, @"wrong selected tax value");
  XCTAssertEqual(_calculationAmount.enteredAmount, 1000., @"wrong initial amount");
  XCTAssertEqual(_calculationAmount.tips.count, 4, @"wrong tips count");
  XCTAssertEqual(_calculationAmount.expectedValue, 1000., @"wrong total value");
  
}

- (void)testDefaultTips {
  
  _calculationAmount.selectedTipIndex = 0;
  XCTAssertEqual(_calculationAmount.totalValue, 1100., @"wrong total value");
  XCTAssertEqual(_calculationAmount.enteredAmount, 1000., @"wrong initial amount");
  XCTAssertEqual(_calculationAmount.expectedValue, 1000., @"wrong total value");
  
  _calculationAmount.selectedTipIndex = 1;
  XCTAssertEqual(_calculationAmount.totalValue, 1150., @"wrong total value");

  _calculationAmount.selectedTipIndex = 2;
  XCTAssertEqual(_calculationAmount.totalValue, 1200., @"wrong total value");
  
  _calculationAmount.selectedTipIndex = 3;
  XCTAssertEqual(_calculationAmount.totalValue, 1000., @"wrong total value");
  
  
}


@end
