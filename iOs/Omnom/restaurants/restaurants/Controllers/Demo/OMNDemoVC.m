//
//  OMNDemoVC.m
//  restaurants
//
//  Created by tea on 11.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDemoVC.h"
#import "GAppDelegate.h"
#import "OMNDemoImageVC.h"
#import "OMNDemoBlueToothVC.h"
#import "OMNBluetoothManager.h"

typedef NS_ENUM(NSUInteger, DemoController) {
  kDemoController1 = 0,
  kDemoController2,
  kDemoController3,
  kDemoController4,
};

@interface OMNDemoVC ()
<UIPageViewControllerDataSource,
UIPageViewControllerDelegate>

@end

@implementation OMNDemoVC {
  
  NSArray *_demoViewControllers;
  
}

- (void)dealloc {
  
}

- (instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options {
  self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
  if (self) {
    
    
    
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.dataSource = self;
  self.delegate = self;
  
  __weak typeof(self)weakSelf = self;
  [[OMNBluetoothManager manager] getBluetoothState:^(CBCentralManagerState state) {
    
    [weakSelf updateBluetoothState:state];
    
  }];
  
  GAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate showSplash];
  
  _demoViewControllers =
  @[
    [self controllerAtIndex:0],
    [self controllerAtIndex:1],
    [self controllerAtIndex:2],
    [self controllerAtIndex:3],
    ];
  
  [self setViewControllers:@[_demoViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
    [appDelegate hideSplash];
  }];
  
}

- (UIViewController *)controllerAtIndex:(NSInteger)index {
  
  UIViewController *vc = nil;
  
  switch (index) {
    case 0: {
      vc = [[OMNDemoBlueToothVC alloc] init];
    } break;
    case 1: {
      vc = [[OMNDemoImageVC alloc] initWithText:@"2"];
    } break;
    case 2: {
      vc = [[OMNDemoImageVC alloc] initWithText:@"3"];
    } break;
    case 3: {
      vc = [[OMNDemoImageVC alloc] initWithText:@"1"];
    } break;
      
  }
  
  return vc;
  
}

- (void)updateBluetoothState:(CBCentralManagerState)state {
  
  BOOL beaconEnabled = NO;
  
  switch (state) {
    case CBCentralManagerStatePoweredOn: {
      beaconEnabled = YES;
    } break;
    case CBCentralManagerStateUnauthorized:
    case CBCentralManagerStatePoweredOff: {
      NSLog(@"The app is not authorized to use Bluetooth Low Energy.");
    } break;
    case CBCentralManagerStateUnsupported: {
      NSLog(@"The platform doesn't support Bluetooth Low Energy.");
    } break;
    case CBCentralManagerStateResetting:
    case CBCentralManagerStateUnknown: {
    } break;
  }
  
  OMNDemoBlueToothVC *demoBlueToothVC = _demoViewControllers[0];
  demoBlueToothVC.beaconEnabled = beaconEnabled;
  
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  if ([_demoViewControllers containsObject:viewController]) {
    NSInteger index = [_demoViewControllers indexOfObject:viewController];
    if (index < [_demoViewControllers count] && index > 0) {
      return [_demoViewControllers objectAtIndex:(index - 1)];
    }
  }
  return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  if ([_demoViewControllers containsObject:viewController]) {
    NSInteger index = [_demoViewControllers indexOfObject:viewController];
    if (index < [_demoViewControllers count] - 1) {
      return [_demoViewControllers objectAtIndex:(index + 1)];
    }
  }
  return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  // The number of items reflected in the page indicator.
  return _demoViewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  // The selected item reflected in the page indicator.
  return 0;
}


@end
