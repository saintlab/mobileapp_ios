//
//  OMNRestaurantAddressSelectionVC.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantAddressSelectionVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurant+omn_network.h"
#import <OMNStyler.h>
#import "OMNRestaurantAddressCell.h"
#import <BlocksKit.h>
#import <TTTAttributedLabel.h>
#import "OMNUtils.h"
#import <BlocksKit+MessageUI.h>

@interface OMNRestaurantAddressSelectionVC ()
<UITableViewDataSource,
UITableViewDelegate,
TTTAttributedLabelDelegate>

@property (nonatomic, strong) NSArray *addresses;

@end

@implementation OMNRestaurantAddressSelectionVC {
  
  OMNRestaurant *_restaurant;
  UITableView *_tableView;
  OMNRestaurantAddressCellItem *_selectedItem;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = kOMN_RESTAURANT_ADDRESS_SELECTION_TITLE;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];

  @weakify(self)
  [_restaurant getDeliveryAddressesWithCompletion:^(NSArray *addresses) {
    
    @strongify(self)
    [self didLoadAddresses:addresses];
    
  } failure:^(OMNError *error) {
    
  }];
  
}

- (void)didLoadAddresses:(NSArray *)addresses {
  
  self.addresses = [addresses bk_map:^id(id obj) {
    
    return [[OMNRestaurantAddressCellItem alloc] initWithRestaurantAddress:obj];
    
  }];
  [_tableView reloadData];
  
}

- (void)closeTap {
  
  self.didCloseBlock();
  
}

- (void)omn_setup {
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [OMNRestaurantAddressCellItem registerCellForTableView:_tableView];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_tableView];
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view layoutIfNeeded];
  
  TTTAttributedLabel *actionLabel = [[TTTAttributedLabel alloc] init];
  actionLabel.numberOfLines = 0;
  actionLabel.textAlignment = NSTextAlignmentCenter;
  actionLabel.delegate = self;
  actionLabel.linkAttributes =
  @{
    NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
    NSForegroundColorAttributeName : [OMNStyler blueColor],
    NSFontAttributeName : FuturaOSFOmnomRegular(22.0f),
    };
  actionLabel.activeLinkAttributes =
  @{
    NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
    NSForegroundColorAttributeName : [[OMNStyler blueColor] colorWithAlphaComponent:0.5f],
    NSFontAttributeName : FuturaOSFOmnomRegular(22.0f),
    };
  
  NSString *text = [NSString stringWithFormat:kOMN_RESTAURANT_ADDRESSES_ADD_TEXT, kOMN_RESTAURANT_ADDRESSES_ADD_ACTION_TEXT];
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(20.0f) textColor:colorWithHexString(@"000000") textAlignment:NSTextAlignmentCenter]];
  actionLabel.text = attributedText;
  [actionLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[text rangeOfString:kOMN_RESTAURANT_ADDRESSES_ADD_ACTION_TEXT]];
  CGFloat height = [actionLabel sizeThatFits:CGSizeMake(CGRectGetWidth(_tableView.frame), 9999.0f)].height;
  actionLabel.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(_tableView.frame), height + 100.0f);
  _tableView.tableFooterView = actionLabel;
  
}

- (OMNRestaurantAddress *)selectedAddress {
  return _selectedItem.address;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  OMNRestaurantAddressCellItem *item = _addresses[indexPath.row];
  return [item cellForTableView:tableView];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNRestaurantAddressCellItem *item = _addresses[indexPath.row];
  return [item heightForTableView:tableView];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  _selectedItem.selected = NO;
  OMNRestaurantAddressCellItem *item = _addresses[indexPath.row];
  _selectedItem = item;
  _selectedItem.selected = YES;

  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
  if (self.didSelectRestaurantAddressBlock) {
    
    self.didSelectRestaurantAddressBlock(item.address);
    
  }
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
  [composeViewController setToRecipients:@[@"team@omnom.menu"]];
  [composeViewController setSubject:kOMN_FEEDBACK_MAIL_SUBJECT_RESTAURANTS_ADDRESSES];
  
  [composeViewController bk_setCompletionBlock:^(MFMailComposeViewController *mailComposeViewController, MFMailComposeResult result, NSError *error) {
    
    [mailComposeViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
  }];
  [self presentViewController:composeViewController animated:YES completion:nil];
  
}

@end
