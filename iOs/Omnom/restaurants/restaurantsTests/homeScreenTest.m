//
//  homeScreenTest.m
//  restaurants
//
//  Created by tea on 02.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <KIF.h>

@interface homeScreenTest : KIFTestCase

@end

@implementation homeScreenTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
  [tester tapViewWithAccessibilityLabel:@"order_button"];
}

@end
