//
//  OMNMyOrderConfirmModel.m
//  omnom
//
//  Created by tea on 07.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMyOrderConfirmModel.h"
#import "OMNPreorderTotalCell.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNMenu+wish.h"
#import <BlocksKit+UIKit.h>

typedef NS_ENUM(NSInteger, OMNMyOrderSection) {
  kMyOrderSectionItems = 0,
  kMyOrderSectionTotal,
  kMyOrderSectionAction,
  kMyOrderSectionRecommendations,
  kMyOrderSectionMax,
};

@interface OMNMyOrderConfirmModel ()

@property (nonatomic, assign) BOOL loading;

@end

@implementation OMNMyOrderConfirmModel {
  
  NSMutableArray *_preorderedProducts;
  NSArray *_recommendationProducts;
 
  OMNPreorderTotalCellItem *_totalCellItem;
  OMNPreorderActionCellItem *_preorderActionCellItem;
  
  OMNWishMediator *_wishMediator;
  
  OMNMenu *_menu;
  OMNVisitor *_visitor;
  
  id<OMNPreorderConfirmCellDelegate> _preorderDelegate;
  
}

- (instancetype)initWithWishMediator:(OMNWishMediator *)wishMediator actionDelegate:(id<OMNPreorderActionCellDelegate>)actionDelegate preorderDelegate:(id<OMNPreorderConfirmCellDelegate>)preorderDelegate {
  self = [super init];
  if (self) {
    
    _preorderDelegate = preorderDelegate;
    _totalCellItem = [[OMNPreorderTotalCellItem alloc] init];
    _wishMediator = wishMediator;
    _preorderActionCellItem = [[OMNPreorderActionCellItem alloc] init];
    _preorderActionCellItem.actionText = [_wishMediator refreshOrdersTitle];
    _preorderActionCellItem.delegate = actionDelegate;

    _menu = _wishMediator.restaurantMediator.menu;
    _visitor = _wishMediator.restaurantMediator.visitor;
    
  }
  return self;
}

- (void)configureTableView:(UITableView *)tableView {

  tableView.delegate = self;
  tableView.dataSource = self;
  tableView.tableFooterView = [[UIView alloc] init];
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [OMNPreorderConfirmCellItem registerCellForTableView:tableView];
  [OMNPreorderTotalCellItem registerCellForTableView:tableView];
  [OMNPreorderActionCellItem registerCellForTableView:tableView];

}

- (void)setLoading:(BOOL)loading {
  
  [self willChangeValueForKey:NSStringFromSelector(@selector(loading))];
  _loading = loading;
  _preorderActionCellItem.enabled = !loading;
  [self didChangeValueForKey:NSStringFromSelector(@selector(loading))];
  
}

- (void)loadTableProductItemsWithCompletion:(dispatch_block_t)completionBlock {
  
  self.loading = YES;
  @weakify(self)
  [_visitor.restaurant getRecommendationItems:^(NSArray *productItems) {
    
    @strongify(self)
    [self didLoadTableProductItems:productItems];
    completionBlock();
    
  } error:^(OMNError *error) {
    
    completionBlock();
    @strongify(self)
    self.loading = NO;
    
  }];
  
}

- (void)didLoadTableProductItems:(NSArray *)items {
  
  NSMutableArray *tableProducts = [NSMutableArray arrayWithCapacity:items.count];
  
  [items enumerateObjectsUsingBlock:^(id tableProductId, NSUInteger idx, BOOL *stop) {
    
    OMNMenuProduct *menuProduct = _menu.products[tableProductId];
    if (menuProduct) {
      
      OMNPreorderConfirmCellItem *tableItem = [[OMNPreorderConfirmCellItem alloc] initWithMenuProduct:menuProduct];
      tableItem.hidePrice = YES;
      tableItem.delegate = _preorderDelegate;
      [tableProducts addObject:tableItem];
      
    }
    
  }];
  
  _recommendationProducts = [tableProducts copy];
  self.reloadSectionsBlock([NSIndexSet indexSetWithIndex:kMyOrderSectionRecommendations], YES);
  self.loading = NO;
  
}

- (void)updatePreorderedProductsAnimated:(BOOL)animated {
  
  NSMutableArray *preorderedProducts = [NSMutableArray array];
  
  __block long long total = 0ll;
  [_menu.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *product, BOOL *stop) {
    
    if (product.preordered) {
      
      total += product.total;
      OMNPreorderConfirmCellItem *orderedItem = [[OMNPreorderConfirmCellItem alloc] initWithMenuProduct:product];
      orderedItem.delegate = _preorderDelegate;
      [preorderedProducts addObject:orderedItem];
      
    }
    
  }];
  
  _preorderedProducts = preorderedProducts;
  _preorderActionCellItem.enabled = (preorderedProducts.count > 0);
  _totalCellItem.total = total;
  
  self.reloadSectionsBlock([NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)], animated);

}

- (void)preorderItemsWithCompletion:(OMNVisitorWishBlock)completionBlock {
  
  if (!_menu.hasPreorderedItems) {
    completionBlock(nil);
    self.loading = NO;
    return;
  }
  
  self.loading = YES;
  NSArray *wishItems = [_menu selectedWishItems];
  
  @weakify(self)
  [_wishMediator createWish:wishItems completionBlock:^(OMNVisitor *visitor) {
    
    completionBlock(visitor);
    @strongify(self)
    self.loading = NO;
    
  } wrongIDsBlock:^(NSArray *wrongIDs) {
    
    @strongify(self)
    [self didFailCreateWithWithProductIDs:wrongIDs withCompletion:completionBlock];
    
  } failureBlock:^(OMNError *error) {
    
    completionBlock(nil);
    @strongify(self)
    self.loading = NO;
    
  }];
  
}

- (void)didFailCreateWithWithProductIDs:(NSArray *)productIDs withCompletion:(OMNVisitorWishBlock)completionBlock {
  
  NSMutableArray *productList = [NSMutableArray arrayWithCapacity:productIDs.count];
  
  [productIDs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    OMNMenuProduct *menuProduct = _menu.products[obj];
    if (menuProduct.name.length) {
      [productList addObject:menuProduct.name];
    }
    
  }];
  
  NSString *subtitle = [NSString stringWithFormat:kOMN_WISH_CREATE_ERROR_SUBTITLE, [productList componentsJoinedByString:@"\n"]];
  @weakify(self)
  [UIAlertView bk_showAlertViewWithTitle:kOMN_WISH_CREATE_ERROR_TITLE message:subtitle cancelButtonTitle:NSLocalizedString(@"Отменить", @"Отменить") otherButtonTitles:@[kOMN_OK_BUTTON_TITLE] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
    
    if (alertView.cancelButtonIndex == buttonIndex) {
      
      completionBlock(nil);
      @strongify(self)
      self.loading = NO;

    }
    else {
      
      @strongify(self)
      [self deselectProductsAndReload:productIDs withCompletion:completionBlock];
      
    }
    
  }];
  
}

- (void)deselectProductsAndReload:(NSArray *)productIDs withCompletion:(OMNVisitorWishBlock)completionBlock {
  
  [_menu deselectItems:productIDs];
  [self updatePreorderedProductsAnimated:NO];
  [self preorderItemsWithCompletion:completionBlock];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kMyOrderSectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger numberOfRows = 0;
  switch ((OMNMyOrderSection)section) {
    case kMyOrderSectionItems: {
      numberOfRows = _preorderedProducts.count;
    } break;
    case kMyOrderSectionTotal: {
      numberOfRows = 1;
    } break;
    case kMyOrderSectionAction: {
      numberOfRows = 1;
    } break;
    case kMyOrderSectionRecommendations: {
      numberOfRows = _recommendationProducts.count;
    } break;
    default:
      break;
  }
  return numberOfRows;
  
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = nil;
  switch (indexPath.section) {
    case kMyOrderSectionItems: {
      item = _preorderedProducts[indexPath.row];
    } break;
    case kMyOrderSectionTotal: {
      item = _totalCellItem;
    } break;
    case kMyOrderSectionAction: {
      item = _preorderActionCellItem;
    } break;
    case kMyOrderSectionRecommendations: {
      item = _recommendationProducts[indexPath.row];
    } break;
    default:
      break;
  }
  return item;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  
  id<OMNCellItemProtocol> item = [self itemAtIndexPath:indexPath];
  
  if ([item conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
    
    cell = [item cellForTableView:tableView];
    
  }
  
  return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id<OMNCellItemProtocol> item = [self itemAtIndexPath:indexPath];
  if ([item conformsToProtocol:@protocol(OMNCellItemProtocol)]) {
    
    return [item heightForTableView:tableView];
    
  }
  return 0.0f;
  
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return (0 == indexPath.section);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.section != kMyOrderSectionItems) {
    return;
  }
  
  OMNPreorderConfirmCellItem *orderedItem = _preorderedProducts[indexPath.row];
  [orderedItem.menuProduct resetSelection];
  [_preorderedProducts removeObjectAtIndex:indexPath.row];
  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  
}

@end
