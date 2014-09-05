//
//  OMNRatingVC.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRatingVC.h"
#import "OMNOrder.h"
#import "OMNSocketManager.h"

@interface OMNRatingVC ()

@end

@implementation OMNRatingVC {
  
  UIButton *_chequeButton;
  UIScrollView *_scroll;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(billCallDone:) name:OMNSocketIOBillCallDoneNotification object:nil];
  
  [self setup];
  
  [_chequeButton addTarget:self action:@selector(chequeTap:) forControlEvents:UIControlEventTouchUpInside];
  [_chequeButton setImage:[UIImage imageNamed:@"bill_icon_black_small"] forState:UIControlStateNormal];
  [_chequeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_chequeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [_chequeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [_chequeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
  [_chequeButton setTitle:NSLocalizedString(@"Чек пожалуйста", nil) forState:UIControlStateNormal];
  [_chequeButton setTitle:NSLocalizedString(@"Отмена", nil) forState:UIControlStateSelected];
  [_chequeButton setTitle:NSLocalizedString(@"Отмена", nil) forState:UIControlStateSelected|UIControlStateHighlighted];
  _chequeButton.hidden = YES;
  
  if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];

}

- (void)setup {
  
  _scroll = [[UIScrollView alloc] init];
  _scroll.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scroll];

  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  contentView.backgroundColor = [UIColor whiteColor];
  [_scroll addSubview:contentView];
  
  UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon_green"]];
  logoView.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:logoView];
  
  UILabel *thankLabel = [[UILabel alloc] init];
  thankLabel.translatesAutoresizingMaskIntoConstraints = NO;
  thankLabel.textAlignment = NSTextAlignmentCenter;
  thankLabel.numberOfLines = 0;
  thankLabel.text = NSLocalizedString(@"Спасибо", nil);
  thankLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:24.0f];
  [contentView addSubview:thankLabel];
  
  UILabel *thankTextLabel = [[UILabel alloc] init];
  thankTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
  thankTextLabel.textAlignment = NSTextAlignmentCenter;
  thankTextLabel.numberOfLines = 0;
  thankTextLabel.text = NSLocalizedString(@"Оплата прошла успешно\nСчет отправлен на ваш e-mail", nil);
  thankTextLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  [contentView addSubview:thankTextLabel];

  _chequeButton = [[UIButton alloc] init];
  _chequeButton.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_chequeButton];
  
  UIImageView *chequeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bill_zubchiki"]];
  chequeImageView.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:chequeImageView];
  
  NSDictionary *views =
  @{
    @"logoView" : logoView,
    @"thankLabel" : thankLabel,
    @"thankTextLabel" : thankTextLabel,
    @"chequeButton" : _chequeButton,
    @"chequeImageView" : chequeImageView,
    @"contentView" : contentView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scroll,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:0 metrics:nil views:views]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[thankLabel]-|" options:0 metrics:nil views:views]];

  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[thankTextLabel]-|" options:0 metrics:nil views:views]];
  
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_chequeButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[logoView]-[thankLabel][thankTextLabel]-20-[chequeButton]-[chequeImageView]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
    
}

- (void)billCallDone:(NSNotification *)n {
  _chequeButton.selected = NO;
}

- (IBAction)chequeTap:(id)sender {
  
  if (_chequeButton.selected) {
    [_order billCallStop:^{
      
      _chequeButton.selected = NO;
      
    } failure:^(NSError *error) {
      
    }];
  }
  else {
    
    [_order billCall:^{
      
      _chequeButton.selected = YES;
      
    } failure:^(NSError *error) {
      
    }];
    
  }
  
}

- (void)closeTap {
  [self.delegate ratingVCDidFinish:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
