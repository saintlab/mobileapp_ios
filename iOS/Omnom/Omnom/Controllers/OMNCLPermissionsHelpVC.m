//
//  OMNNavigationPermissionsHelpVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCLPermissionsHelpVC.h"
#import "OMNScrollExtendView.h"
#import "OMNUtils.h"
#import "OMNConstants.h"

@interface OMNCLPermissionsHelpVC ()
<UIScrollViewDelegate>

@end

@implementation OMNCLPermissionsHelpVC {
  
  UIView *_contentView;
  UILabel *_label;
  UIPageControl *_pageControl;
  UIScrollView *_scrollView;
  NSArray *_labelTexts;

}

- (void)loadView {
  self.view = [[OMNScrollExtendView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
  
  [self setup];

  OMNScrollExtendView *scrollExtendView = (OMNScrollExtendView *)self.view;
  if ([scrollExtendView respondsToSelector:@selector(setScrollView:)]) {
    scrollExtendView.scrollView = _scrollView;
  }
  
  _label.textColor = [UIColor blackColor];
  _label.font = FuturaOSFOmnomRegular(25.0f);
  
  _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
  _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];

  _scrollView.delegate = self;
  
  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    _labelTexts =
    @[
      NSLocalizedString(@"Чтобы разрешить геолокацию, откройте список приватности:", nil),
      NSLocalizedString(@"Затем откройте\nСлужбы геолокации:", nil),
      NSLocalizedString(@"Разрешите, наконец, использовать службы геолокации для Omnom:", nil),
      ];
  } else {
    
    _labelTexts =
    @[
      NSLocalizedString(@"Чтобы разрешить геолокацию, откройте Конфиденциальность:", nil),
      NSLocalizedString(@"Затем откройте\nСлужбы геолокации:", nil),
      NSLocalizedString(@"Разрешите доступ к геопозиции:", nil),
      ];
  }

  [self setPage:0];
  
}

- (void)setup {
  
  NSInteger pagesCount = 3;
  
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.pagingEnabled = YES;
  _scrollView.bounces = NO;
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scrollView];
  
  _label = [[UILabel alloc] init];
  _label.numberOfLines = 0;
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_label];
  
  _pageControl = [[UIPageControl alloc] init];
  _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
  _pageControl.numberOfPages = pagesCount;
  [self.view addSubview:_pageControl];
  
  _contentView = [[UIView alloc] init];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scrollView addSubview:_contentView];
  
  NSMutableDictionary *views =
  [@{
    @"scrollView" : _scrollView,
    @"label" : _label,
    @"pageControl" : _pageControl,
    @"contentView" : _contentView,
    @"topLayoutGuide" : self.topLayoutGuide,
    } mutableCopy];
  
  CGSize size = CGSizeZero;
  
  for (int i = 0; i < pagesCount; i++) {
    
    UIImageView *iv = [[UIImageView alloc] init];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
      iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"navigation_help_%d-7", i + 1]];
    } else {
      iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"navigation_help_%d-8", i + 1]];
    }
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
      size = iv.image.size;
    }
    [_contentView addSubview:iv];
    views[[NSString stringWithFormat:@"iv%d", i]] = iv;
  }

  NSDictionary *metrics =
  @{
    @"height" : @(size.height),
    @"width" : @(size.width),
    };
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iv0][iv1][iv2]|" options:0 metrics:nil views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iv0]|" options:0 metrics:nil views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iv1]|" options:0 metrics:nil views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iv2]|" options:0 metrics:nil views:views]];
  
  [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:metrics views:views]];
  [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[scrollView(width)]" options:0 metrics:metrics views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=20)-[label]-(>=20)-|" options:0 metrics:metrics views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(50)-[label(100)][scrollView(height)]" options:0 metrics:metrics views:views]];
  
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  CGSize size = _scrollView.frame.size;
  size.width *= 3;
  _scrollView.contentSize = size;

  NSLog(@"%@", _pageControl);
  
}

- (void)settingsTap {
  
#ifdef __IPHONE_8_0
  if (&UIApplicationOpenSettingsURLString) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
  }
#endif
  
}

- (void)setPage:(NSInteger)page {
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:_labelTexts[page]];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.lineSpacing = 5.0f;
  style.maximumLineHeight = 20.0f;
  [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.length)];
  
  _label.attributedText = attributedText;
  _label.textAlignment = NSTextAlignmentLeft;
  _pageControl.currentPage = page;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (NO == SYSTEM_VERSION_LESS_THAN(@"8.0")) {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Перейти", nil) style:UIBarButtonItemStylePlain target:self action:@selector(settingsTap)];
  }
  
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGFloat offset = scrollView.contentOffset.x;
  CGFloat pageFloat = offset/scrollView.frame.size.width;
  NSInteger page = floorf(pageFloat + 0.5f);
  
  if (page == _pageControl.currentPage) {
    return;
  }
  
  [self setPage:page];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
