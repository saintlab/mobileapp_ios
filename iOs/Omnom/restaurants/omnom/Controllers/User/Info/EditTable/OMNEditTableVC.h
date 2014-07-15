//
//  OMNEditTableVC.h
//  seocialtest
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNEditTableVCDelegate;

@interface OMNEditTableVC : UIViewController

@property (nonatomic, weak) id<OMNEditTableVCDelegate> delegate;

@end

@protocol OMNEditTableVCDelegate <NSObject>

- (void)editTableVCDidFinish:(OMNEditTableVC *)editTableVC;

@end