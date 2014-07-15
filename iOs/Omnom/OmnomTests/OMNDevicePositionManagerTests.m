//
//  OMNDevicePositionManagerTests.m
//  restaurants
//
//  Created by tea on 19.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OMNDevicePositionManager.h"
#import <OCMock/OCMock.h>

@interface OMNDevicePositionManagerTests : XCTestCase

@end

@implementation OMNDevicePositionManagerTests {
  OMNDevicePositionManager *_devicePositionManager;
}

- (void)setUp
{
  [super setUp];
  _devicePositionManager = [[OMNDevicePositionManager alloc] init];
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testPositionHandle {
  
  id mockDevicePositionManager = [OCMockObject mockForClass:[OMNDevicePositionManager class]];
  
  [[[mockDevicePositionManager expect] andDo:^(NSInvocation *invocation) {
    
    dispatch_block_t completitionBlock;
    [invocation getArgument:&completitionBlock atIndex:2];
    
    completitionBlock();
    
  }] handleDeviceFaceUpPosition:[OCMArg any]];
  
  [mockDevicePositionManager handleDeviceFaceUpPosition:^{

    
    
  }];
  

}

@end
