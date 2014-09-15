//
//  OMNRatingVC.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRatingVC.h"
#import "OMNOrder+network.h"
#import "OMNSocketManager.h"
#import "OMNBorderedButton.h"
#import "TQStarRatingView.h"

@interface OMNRatingVC ()

@end

@implementation OMNRatingVC {
  
  OMNBorderedButton *_chequeButton;
  UIScrollView *_scroll;
  UIView *_contentView;
  UILabel *_ratingLabel;
  TQStarRatingView *_starRatingView;
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
  
  _ratingLabel.text = NSLocalizedString(@"Вам здесь понравилось?", nil);
  _ratingLabel.textColor = [UIColor whiteColor];
  _ratingLabel.font = FuturaOSFOmnomRegular(18.0f);
  
  [_chequeButton addTarget:self action:@selector(chequeTap:) forControlEvents:UIControlEventTouchUpInside];
  [_chequeButton setTitle:NSLocalizedString(@"Чек пожалуйста", nil) selectedTitle:NSLocalizedString(@"Отмена", nil) image:[UIImage imageNamed:@"bill_icon_black_small"]];
  
  if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];

}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  CGSize size = _scroll.frame.size;
  size.height += 1.0f;
  _scroll.contentSize = size;
  
}

- (void)setup {
  
  self.view.backgroundColor = [UIColor redColor];
  
  UIView *bottomContentView = [[UIView alloc] init];
  bottomContentView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:bottomContentView];
  
  UIView *bottomView = [[UIView alloc] init];
  bottomView.translatesAutoresizingMaskIntoConstraints = NO;
  [bottomContentView addSubview:bottomView];
  
  _ratingLabel = [[UILabel alloc] init];
  _ratingLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _ratingLabel.numberOfLines = 0;
  _ratingLabel.textAlignment = NSTextAlignmentCenter;
  [bottomView addSubview:_ratingLabel];
  
  _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 225.0f, 50.0f) numberOfStar:5];
  _starRatingView.translatesAutoresizingMaskIntoConstraints = NO;
  [bottomView addSubview:_starRatingView];
  
  _scroll = [[UIScrollView alloc] init];
  _scroll.clipsToBounds = NO;
  _scroll.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scroll];

  _contentView = [[UIView alloc] init];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  _contentView.backgroundColor = [UIColor clearColor];
  [_scroll addSubview:_contentView];
  
  UIView *whiteBGView = [[UIView alloc] init];
  whiteBGView.backgroundColor = [UIColor whiteColor];
  whiteBGView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:whiteBGView];
  
  UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon_green"]];
  logoView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:logoView];
  
  UILabel *thankLabel = [[UILabel alloc] init];
  thankLabel.translatesAutoresizingMaskIntoConstraints = NO;
  thankLabel.textAlignment = NSTextAlignmentCenter;
  thankLabel.numberOfLines = 0;
  thankLabel.text = NSLocalizedString(@"Спасибо", nil);
  thankLabel.font = FuturaOSFOmnomRegular(24.0f);
  [_contentView addSubview:thankLabel];
  
  UILabel *thankTextLabel = [[UILabel alloc] init];
  thankTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
  thankTextLabel.textAlignment = NSTextAlignmentCenter;
  thankTextLabel.numberOfLines = 0;
  thankTextLabel.text = NSLocalizedString(@"Оплата прошла успешно\nСчет отправлен на ваш e-mail", nil);
  thankTextLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_contentView addSubview:thankTextLabel];

  _chequeButton = [[OMNBorderedButton alloc] init];
  _chequeButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:_chequeButton];
  
  UIImageView *chequeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bill_zubchiki"]];
  chequeImageView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:chequeImageView];
  
  NSDictionary *views =
  @{
    @"whiteBGView" : whiteBGView,
    @"bottomView" : bottomView,
    @"bottomContentView" : bottomContentView,
    @"ratingLabel" : _ratingLabel,
    @"starRatingView" : _starRatingView,
    @"logoView" : logoView,
    @"thankLabel" : thankLabel,
    @"thankTextLabel" : thankTextLabel,
    @"chequeButton" : _chequeButton,
    @"chequeImageView" : chequeImageView,
    @"contentView" : _contentView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scroll,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:nil views:views]];
  [bottomContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomContentView]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll][bottomContentView]|" options:0 metrics:nil views:views]];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[thankLabel]-|" options:0 metrics:nil views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[whiteBGView]|" options:0 metrics:nil views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[whiteBGView(2000)]" options:0 metrics:nil views:views]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:whiteBGView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:chequeImageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];

  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[thankTextLabel]-|" options:0 metrics:nil views:views]];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chequeImageView]|" options:0 metrics:nil views:views]];
  
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_chequeButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[logoView]-[thankLabel][thankTextLabel]-20-[chequeButton]-[chequeImageView]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scroll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomContentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
  [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:_starRatingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[ratingLabel][starRatingView(50)]|" options:0 metrics:nil views:views]];
  [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[starRatingView(225)]" options:0 metrics:nil views:views]];
  [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[ratingLabel]|" options:0 metrics:nil views:views]];
  
  
  
}

- (void)billCallDone:(NSNotification *)n {
  _chequeButton.selected = NO;
}

- (IBAction)chequeTap:(id)sender {
  
  [_order billCall:^{
    
    _chequeButton.enabled = NO;
    
  } failure:^(NSError *error) {
    
  }];
}

- (void)closeTap {
  [self.delegate ratingVCDidFinish:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
