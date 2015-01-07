//
//  OMNSearchBeaconVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoadingCircleVC.h"
#import "OMNLoaderView.h"

@protocol OMNSearchRestaurantsVCDelegate;

@interface OMNSearchRestaurantsVC : OMNLoadingCircleVC

@property (nonatomic, strong) NSArray *restaurants;
@property (nonatomic, copy) NSString *qr;
@property (nonatomic, copy) NSString *hashString;
@property (nonatomic, weak) id<OMNSearchRestaurantsVCDelegate> delegate;

@end

@protocol OMNSearchRestaurantsVCDelegate <NSObject>

- (void)searchRestaurantsVC:(OMNSearchRestaurantsVC *)searchRestaurantsVC didFindRestaurants:(NSArray *)restaurants;
- (void)searchRestaurantsVCDidCancel:(OMNSearchRestaurantsVC *)searchRestaurantsVC;

@end
