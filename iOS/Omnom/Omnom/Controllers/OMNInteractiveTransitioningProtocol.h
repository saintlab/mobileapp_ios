//
//  OMNInteractiveTransitioningProtocol.h
//  omnom
//
//  Created by tea on 09.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNInteractiveTransitioningProtocol <NSObject>

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitioning;

@end
