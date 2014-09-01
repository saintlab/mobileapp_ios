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

@interface OMNCLPermissionsHelpVC ()
<UIScrollViewDelegate>

@end

@implementation OMNCLPermissionsHelpVC {
  
  __weak IBOutlet UILabel *_label;
  __weak IBOutlet UIPageControl *_pageControl;
  __weak IBOutlet UIScrollView *_scrollView;
  NSArray *_labelTexts;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
//    self.buttonInfo =
//    @[
//      @{
//        @"title" : NSLocalizedString(@"Повторить", nil),
//        @"image" : [UIImage imageNamed:@"repeat_icon_small"],
//        @"block" : ^{
//          
//          [weakSelf.navigationController popToViewController:weakSelf animated:YES];
//          
//        },
//        }
//      ];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  OMNScrollExtendView *scrollExtendView = (OMNScrollExtendView *)self.view;
  if ([scrollExtendView respondsToSelector:@selector(setScrollView:)]) {
    scrollExtendView.scrollView = _scrollView;
  }
  
  _label.textColor = [UIColor blackColor];
  _label.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:25.0f];
  
  NSInteger pagesCount = 3;

  _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
  _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];

  _scrollView.delegate = self;
  
  _labelTexts =
  @[
    NSLocalizedString(@"Чтобы разрешить геолокацию, откройте список приватности:", nil),
    NSLocalizedString(@"Затем откройте службы геолокации:", nil),
    NSLocalizedString(@"Разрешите, наконец, использовать службы геолокации для Omnom:", nil),
    ];
  
  CGRect frame = _scrollView.bounds;
  CGSize contentSize = CGSizeMake(frame.size.width*pagesCount, frame.size.height);
  _scrollView.contentSize = contentSize;
  
  for (int i = 0; i < pagesCount; i++) {
    
    frame.origin.x = frame.size.width*i;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
      iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"navigation_help_%d-7", i + 1]];
    } else {
      iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"navigation_help_%d-8", i + 1]];
    }
    [_scrollView addSubview:iv];
    
  }

  [self setPage:0];
  
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
