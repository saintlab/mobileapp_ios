//
//  restaurantsTests.m
//  restaurantsTests
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "OMNRestaurant.h"

@interface restaurantsTests : XCTestCase

@end

@implementation restaurantsTests

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

- (void)testExample
{
  
  id mockResaurant = [OCMockObject mockForClass:[OMNRestaurant class]];
  
  [[[mockResaurant expect] andDo:^(NSInvocation *invocation) {
    
    GMenuBlock menuBlock;
    [invocation getArgument:&menuBlock atIndex:2];
    
    GMenu *menu = [[GMenu alloc] initWithData:nil];
    menuBlock(menu);
    
    void(^errorBlock)(NSError *error) = nil;
    [invocation getArgument:&errorBlock atIndex:3];
    
    errorBlock(nil);
    
  }] getMenu:[OCMArg any] error:[OCMArg any]];
  
  [mockResaurant getMenu:^(GMenu *menu) {
    
    XCTAssertNotNil(menu, @"menu shold be nil");
    NSLog(@"%@", menu);
    
  } error:^(NSError *error) {
    
    XCTAssertNil(error, @"erro shold be nil");
    
  }];
  
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
