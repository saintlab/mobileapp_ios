//
//  OMNPaymentDoneVC.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPaymentDoneVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"

@implementation OMNPaymentDoneVC {
  
  UIScrollView *_scroll;
  UIView *_scrollContentView;

}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super init];
  if (self) {
    
    _visitor = visitor;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup_internal];
  
  self.view.backgroundColor = [UIColor redColor];
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithTitle:kOMN_DONE_BUTTON_TITLE color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  
}

- (void)closeTap {
  
  if (self.didFinishBlock) {
    self.didFinishBlock();
  }
  
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGSize size = _scrollContentView.frame.size;
  size.height += 1.0f;
  _scroll.contentSize = size;
  
}

- (void)omn_setup_internal {
  
  _scroll = [UIScrollView omn_autolayoutView];
  _scroll.clipsToBounds = NO;
  [self.view addSubview:_scroll];
  
  _scrollContentView = [UIView omn_autolayoutView];
  _scrollContentView.backgroundColor = [UIColor clearColor];
  [_scroll addSubview:_scrollContentView];
  
  UIView *whiteBGView = [UIView omn_autolayoutView];
  whiteBGView.backgroundColor = [UIColor whiteColor];
  [_scrollContentView addSubview:whiteBGView];
 
  _contentView = [UIView omn_autolayoutView];
  [_scrollContentView addSubview:_contentView];
 
  UIImageView *chequeImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"zub"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
  chequeImageView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scrollContentView addSubview:chequeImageView];
  
  NSDictionary *views =
  @{
    @"whiteBGView" : whiteBGView,
    @"contentView" : _contentView,
    @"chequeImageView" : chequeImageView,
    @"scrollContentView" : _scrollContentView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scroll,
    };
  
  NSDictionary *metrics = @{};
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:kNilOptions metrics:metrics views:views]];
  
  [_scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[whiteBGView]|" options:kNilOptions metrics:metrics views:views]];
  [_scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[whiteBGView(2000)]" options:kNilOptions metrics:metrics views:views]];
  [_scrollContentView addConstraint:[NSLayoutConstraint constraintWithItem:whiteBGView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:chequeImageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  [_scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chequeImageView]|" options:kNilOptions metrics:metrics views:views]];
  [_scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  [_scrollContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]-(20)-[chequeImageView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollContentView]|" options:kNilOptions metrics:nil views:views]];
  
}

@end
