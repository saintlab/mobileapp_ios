//
//  main.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//



#import "GAppDelegate.h"
#import "OMNTestAppDelegate.h"

int main(int argc, char * argv[])
{
  @autoreleasepool {

#if OMN_TEST
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([OMNTestAppDelegate class]));
#else
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([GAppDelegate class]));
#endif
    
  }
}
