//
//  OMNMenuSearchVC.m
//  omnom
//
//  Created by tea on 19.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuSearchVC.h"
#import "OMNPreorderConfirmCellItem.h"
#import <BlocksKit.h>
#import "OMNPreorderConfirmCell.h"
#import <OMNStyler.h>
#import "UINavigationBar+omn_custom.h"
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>

@interface OMNMenuSearchVC ()
<UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
OMNPreorderConfirmCellDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong) NSArray *foundItems;

@end

@implementation OMNMenuSearchVC {
  
  
  OMNMenu *_menu;
  UILabel *_hintLabel;
  NSArray *_allProducts;
  UISearchBar *_searchBar;
  NSTimer *_searchTimer;
  
}

- (instancetype)initWithMenu:(OMNMenu *)menu {
  self = [super init];
  if (self) {
    
    _menu = menu;
    
  }
  return self;
}

- (void)dealloc {
  [_searchTimer invalidate], _searchTimer = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
 
  [self omn_setup];
  
  _hintLabel.text = kOMN_SEARCH_PRODUCT_HINT_TEXT;
  
  _allProducts = [_menu.products allValues];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  _searchBar = [[UISearchBar alloc] init];
  _searchBar.delegate = self;
  self.navigationItem.titleView = _searchBar;
  
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [self.navigationController.navigationBar omn_setDefaultBackground];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
 
  [_searchBar becomeFirstResponder];
  
}


- (void)keyboardWillShow:(NSNotification *)n {
  
  CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  NSTimeInterval duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [self setKeyboardHeight:CGRectGetHeight(keyboardFrame) duration:duration];
  
}

- (void)keyboardWillHide:(NSNotification *)n {
  
  NSTimeInterval duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [self setKeyboardHeight:0.0f duration:duration];
  
}

- (void)setKeyboardHeight:(CGFloat)height duration:(NSTimeInterval)duration {
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, MAX(height, [OMNStyler styler].bottomToolbarHeight.floatValue), 0.0f);
  [UIView animateWithDuration:duration animations:^{
    
    _tableView.contentInset = insets;
    _tableView.scrollIndicatorInsets = insets;

  }];
  
}

- (void)omn_setup {
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  [OMNPreorderConfirmCellItem registerCellForTableView:_tableView];
  [self.view addSubview:_tableView];
  
  _hintLabel = [UILabel omn_autolayoutView];
  _hintLabel.hidden = YES;
  _hintLabel.numberOfLines = 0;
  _hintLabel.textAlignment = NSTextAlignmentCenter;
  _hintLabel.font = FuturaOSFOmnomRegular(18.0f);
  _hintLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  [self.view addSubview:_hintLabel];
  
  [self setKeyboardHeight:0.0f duration:0.0];
  
  NSDictionary *views =
  @{
    @"hintLabel" : _hintLabel,
    @"tableView" : _tableView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[hintLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-(50)-[hintLabel]" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][tableView]|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
  [_searchTimer invalidate];
  _searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startSearch) userInfo:nil repeats:NO];
  
}

- (void)startSearch {
  
  NSString *searchText = _searchBar.text;
  if (0 == searchText.length) {
    [self didFindProducts:nil];
    return;
  }
  
  NSArray *allProducts = _allProducts;
  @weakify(self)
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@ OR Description contains[c] %@", searchText, searchText];
    NSArray *foundProducts = [allProducts filteredArrayUsingPredicate:searchPredicate];
    
    NSArray *foundItems = [foundProducts bk_map:^id(OMNMenuProduct *menuProduct) {
      
      @strongify(self)
      OMNPreorderConfirmCellItem *cellItem = [[OMNPreorderConfirmCellItem alloc] initWithMenuProduct:menuProduct];
      cellItem.delegate = self;
      return cellItem;
      
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
      @strongify(self)
      [self didFindProducts:foundItems];
      
    });

  });
  
}

- (void)didFindProducts:(NSArray *)products {
  
  _hintLabel.hidden = (products.count > 0 ||
                       nil == products);
  self.foundItems = products;
  [self.tableView reloadData];
  
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _foundItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNPreorderConfirmCellItem *cellItem = _foundItems[indexPath.row];
  return [cellItem cellForTableView:tableView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNPreorderConfirmCellItem *cellItem = _foundItems[indexPath.row];
  return [cellItem heightForTableView:tableView];
  
}

#pragma mark - OMNPreorderConfirmCellDelegate

- (void)preorderConfirmCellDidEdit:(OMNPreorderConfirmCell *)preorderConfirmCell {
  
  @weakify(self)
  [preorderConfirmCell.item editMenuProductFromController:self withCompletion:^{
    
    @strongify(self)
    NSIndexPath *indexPath = [self.tableView indexPathForCell:preorderConfirmCell];
    if (indexPath) {
      [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
  }];
  
}

@end
