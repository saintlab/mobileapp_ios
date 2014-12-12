//
//  OMNRatingVC.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRatingVC.h"
#import "OMNOrder+network.h"
#import "OMNBorderedButton.h"
#import "TQStarRatingView.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "OMNAnalitics.h"

@interface OMNRatingVC ()

@end

@implementation OMNRatingVC {
  
  UIScrollView *_scroll;
  UIView *_contentView;
  
  UILabel *_l1;
  UILabel *_l2;
  UILabel *_l3;
  UILabel *_l4;
  
  UILabel *_ratingLabel;
  TQStarRatingView *_starRatingView;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
  
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationItem.title = NSLocalizedString(@"RATINGSCREEN_THANK_TITLE", @"Счёт");
  
  [_starRatingView setScore:0.0f withAnimation:NO];

  _l1.text = NSLocalizedString(@"RATINGSCREEN_THANK_TITLE1", @"Спасибо");
  _l1.textColor = colorWithHexString(@"000000");
  _l1.font = FuturaOSFOmnomRegular(30.0f);
  
  _l2.text = NSLocalizedString(@"RATINGSCREEN_THANK_TITLE2", @"Оплата прошла успешно");
  _l2.textColor = colorWithHexString(@"000000");
  _l2.font = FuturaOSFOmnomRegular(20.0f);
  
  _l3.text = NSLocalizedString(@"RATINGSCREEN_THANK_TITLE3", @"Счёт отправлен на почту");
  _l3.textColor = colorWithHexString(@"000000");
  _l3.font = FuturaOSFOmnomRegular(20.0f);
  
  _l4.text = NSLocalizedString(@"RATINGSCREEN_THANK_TITLE4", @"Подтверждение оплаты вы сможете найти на экране профиля в оплаченных счетах.");
  _l4.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  _l4.font = FuturaOSFOmnomRegular(15.0f);
  
  _ratingLabel.text = NSLocalizedString(@"RATINGSCREEN_RATE_CONTROL_TITLE", @"Вам здесь понравилось?");
  _ratingLabel.textColor = colorWithHexString(@"FFFFFF");
  _ratingLabel.font = FuturaOSFOmnomRegular(20.0f);
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"RATINGSCREEN_DONE_BUTTON_TITLE", @"Готово") style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];

}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGSize size = _scroll.frame.size;
  size.height += 1.0f;
  _scroll.contentSize = size;
  
}

- (UILabel *)label {
  
  UILabel *label = [[UILabel alloc] init];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.textColor = colorWithHexString(@"000000");
  label.textAlignment = NSTextAlignmentCenter;
  label.numberOfLines = 0;
  return label;
  
}

- (void)setup {
  
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
  
  UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_success_icon"]];
  logoView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:logoView];

  _l1 = [self label];
  [_contentView addSubview:_l1];
  
  _l2 = [self label];
  [_contentView addSubview:_l2];
  
  UIImageView *dividerIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_divider"]];
  dividerIV.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:dividerIV];
  
  _l3 = [self label];
  [_contentView addSubview:_l3];
  
  _l4 = [self label];
//  [_contentView addSubview:_l4];
  
  UIImageView *chequeImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"zub"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
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
    @"l1" : _l1,
    @"l2" : _l2,
    @"dividerIV" : dividerIV,
    @"l3" : _l3,
//    @"l4" : _l4,
    @"chequeImageView" : chequeImageView,
    @"contentView" : _contentView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"scroll" : _scroll,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(30.0f),
    @"labelOffset" : @(10.0f),
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:nil views:views]];
  [bottomContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomView]|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomContentView]|" options:kNilOptions metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll][bottomContentView]|" options:kNilOptions metrics:nil views:views]];

  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[whiteBGView]|" options:kNilOptions metrics:nil views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[whiteBGView(2000)]" options:kNilOptions metrics:nil views:views]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:whiteBGView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:chequeImageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];

  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[l1]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[l2]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:dividerIV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[l3]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
//  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[l4]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chequeImageView]|" options:kNilOptions metrics:nil views:views]];
  
//  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[logoView]-(25)-[l1]-(labelOffset)-[l2]-(labelOffset)-[dividerIV]-(labelOffset)-[l3]-(labelOffset)-[l4]-(20)-[chequeImageView]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[logoView]-(25)-[l1]-(labelOffset)-[l2]-(labelOffset)-[dividerIV]-(labelOffset)-[l3]-(20)-[chequeImageView]|" options:kNilOptions metrics:metrics views:views]];

  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:nil views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scroll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomContentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
  [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:_starRatingView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[ratingLabel][starRatingView(50)]|" options:kNilOptions metrics:nil views:views]];
  [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[starRatingView(225)]" options:kNilOptions metrics:nil views:views]];
  [bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[ratingLabel]|" options:kNilOptions metrics:nil views:views]];
  
}

- (IBAction)chequeTap:(id)sender {
  
  [_order billCall:^{
    
  } failure:^(NSError *error) {
    
  }];
}

- (void)closeTap {
  
  if (_starRatingView.score > 0.0f) {
    
    NSInteger score = (NSInteger)roundf(5*_starRatingView.score);
    [[OMNAnalitics analitics] logScore:score order:_order];
    
  }
  
  [self.delegate ratingVCDidFinish:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
