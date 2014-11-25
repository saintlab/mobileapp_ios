//
//  OMNPermissionHelpVC.m
//  omnom
//
//  Created by tea on 25.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPermissionHelpVC.h"
#import "OMNScrollExtendView.h"
#import "OMNConstants.h"
#import "OMNUtils.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNPermissionHelpVC ()
<UIScrollViewDelegate>

@end

@implementation OMNPermissionHelpVC {
  
  UIView *_contentView;
  UILabel *_label;
  UIPageControl *_pageControl;
  UIScrollView *_scrollView;
  
}

- (instancetype)init {
  return [self initWithPages:@[]];
}

- (instancetype)initWithPages:(NSArray *)pages {
  self = [super init];
  if (self) {
    
    _pages = pages;
    
  }
  return self;
}

- (void)loadView {
  
  self.view = [[OMNScrollExtendView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  
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
  
  //  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
  //    _labelTexts =
  //    @[
  //      NSLocalizedString(@"Чтобы разрешить геолокацию, откройте список приватности:", nil),
  //      NSLocalizedString(@"Затем откройте\nСлужбы геолокации:", nil),
  //      NSLocalizedString(@"Разрешите, наконец, использовать службы геолокации для Omnom:", nil),
  //      ];
  //  } else {
  //
  //    _labelTexts =
  //    @[
  //      NSLocalizedString(@"Чтобы разрешить геолокацию, откройте Конфиденциальность:", nil),
  //      NSLocalizedString(@"Затем откройте\nСлужбы геолокации:", nil),
  //      NSLocalizedString(@"Разрешите доступ к геопозиции:", nil),
  //      ];
  //  }
  //  if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
  //    iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"navigation_help_%d-7", i + 1]];
  //  } else {
  //    iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"navigation_help_%d-8", i + 1]];
  //  }
  
  [self setPage:0];
  
}

- (void)setup {
  
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
  _pageControl.numberOfPages = self.pages.count;
  _pageControl.hidden = (self.pages.count < 2);
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
  
  __block CGSize size = CGSizeZero;
  NSMutableArray *viewKeys = [NSMutableArray arrayWithCapacity:self.pages.count];
  
  [self.pages enumerateObjectsUsingBlock:^(OMNHelpPage *page, NSUInteger idx, BOOL *stop) {
    
    UIImageView *iv = [[UIImageView alloc] init];
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    iv.image = page.image;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
      size = iv.image.size;
    }
    [_contentView addSubview:iv];
    
    NSString *viewKey = [NSString stringWithFormat:@"iv%d", idx];
    [viewKeys addObject:viewKey];
    views[viewKey] = iv;
    
  }];
  
  NSDictionary *metrics =
  @{
    @"height" : @(287.0f),
    @"width" : @(250.0f),
    };
  
  NSMutableString *HFormat = [NSMutableString stringWithString:@"H:|"];
  [viewKeys enumerateObjectsUsingBlock:^(NSString *viewKey, NSUInteger idx, BOOL *stop) {
    
    NSString *format = [NSString stringWithFormat:@"V:|[%@(height)]|", viewKey];
    [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:kNilOptions metrics:metrics views:views]];
    [HFormat appendFormat:@"[%@(width)]", viewKey];
    
  }];
  [HFormat appendString:@"|"];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:HFormat options:kNilOptions metrics:metrics views:views]];
  
  
  [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[scrollView(width)]" options:kNilOptions metrics:metrics views:views]];
  
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
  size.width *= self.pages.count;
  _scrollView.contentSize = size;
  
}

- (void)settingsTap {
  
#ifdef __IPHONE_8_0
  if (&UIApplicationOpenSettingsURLString) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
  }
#endif
  
}

- (void)setPage:(NSInteger)page {
  
  if (page >= self.pages.count) {
    return;
  }
  
  OMNHelpPage *helpPage = self.pages[page];
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:helpPage.text];
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
  
  if (NO == SYSTEM_VERSION_LESS_THAN(@"8.0") &&
      self.showSettingsButton) {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Перейти", nil) style:UIBarButtonItemStylePlain target:self action:@selector(settingsTap)];
    
  }
  
  if (self.didCloseBlock) {
    
    self.navigationItem.titleView = [UIBarButtonItem omn_buttonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
    
  }
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
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

@end
