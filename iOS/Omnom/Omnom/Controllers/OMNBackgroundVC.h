//
//  OMNStopRootVC.h
//  omnom
//
//  Created by tea on 25.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNInteractiveTransitioningProtocol.h"

@interface OMNBackgroundVC : UIViewController
<OMNInteractiveTransitioningProtocol>

@property (strong, nonatomic, readonly) UIImageView *backgroundView;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (strong, nonatomic, readonly) UIToolbar *bottomToolbar;

@property (nonatomic, strong) NSArray *buttonInfo;

//@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

- (void)setBackgroundImage:(UIImage *)backgroundImage animated:(BOOL)animated;
- (void)addActionBoardIfNeeded;
- (void)updateActionBoard;

@end

@interface OMNBarButtonInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) dispatch_block_t block;

+ (OMNBarButtonInfo *)infoWithTitle:(NSString *)title image:(UIImage *)image block:(dispatch_block_t)block;

@end