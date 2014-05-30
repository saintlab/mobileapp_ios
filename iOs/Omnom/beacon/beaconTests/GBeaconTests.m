//
//  GBeaconTests.m
//  beacon
//
//  Created by tea on 06.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GBeacon.h"

@interface GBeaconTests : XCTestCase {
  
  GBeacon *_beacon1;
  GBeacon *_beacon2;
}

@end

@implementation GBeaconTests

- (GBeacon *)beaconWithProximity:(CLProximity)proximity {
  
  GBeacon *beacon = [[GBeacon alloc] init];
  beacon.UUIDString = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
  beacon.major = @(0);
  beacon.minor = @(0);
  beacon.proximity = proximity;
  
  return beacon;
  
}

- (void)setUp {
  [super setUp];

  _beacon1 = [self beaconWithProximity:CLProximityNear];
  _beacon2 = [self beaconWithProximity:CLProximityImmediate];
  
  
  
}

- (void)tearDown {
  
  
  [super tearDown];
}

- (void)testCreate {
  
  XCTAssertNotNil(_beacon1, @"beacon 1 is nil");
  XCTAssertNotNil(_beacon2, @"beacon 2 is nil");
  
}

- (void)testUpdate{
  
  [_beacon1 updateWithBeacon:_beacon2];
  XCTAssertEqual(_beacon1.proximity, CLProximityImmediate, @"beacon doesn't update");
  
}

@end
