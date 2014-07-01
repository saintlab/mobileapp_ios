//
//  GRestaurantMenuVC.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMenuVC.h"
#import "OMNMenu.h"
#import "OMNOrdersVC.h"
#import "OMNOrderVCDelegate.h"
#import "OMNSearchTableVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNPaymentVC.h"
#import "OMNAssetManager.h"
#import "OMNUserInfoTransitionDelegate.h"
#import "OMNUserInfoVC.h"
#import "OMNBeaconBackgroundManager.h"
#import "OMNAuthorisation.h"
#import "OMNProductsModel.h"
#import "OMNProductDetailsVC.h"
#import "OMNTransitionFromListToProduct.h"

@interface OMNRestaurantMenuVC ()
<OMNOrdersVCDelegate,
UINavigationControllerDelegate> {
  
  __weak IBOutlet UIButton *_waiterButton;
  __weak IBOutlet UIButton *_billButton;
  __weak IBOutlet UIImageView *_backgroundIV;
  __weak IBOutlet UICollectionView *_productsView;
}



@end

@implementation OMNRestaurantMenuVC {
  OMNRestaurant *_restaurant;
  OMNTable *_table;
  OMNMenu *_menu;
  
  IBOutlet OMNProductsModel *_productsModel;
  OMNUserInfoTransitionDelegate *_transitionDelegate;
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant table:(OMNTable *)table {
  self = [super initWithNibName:@"OMNRestaurantMenuVC" bundle:nil];
  if (self) {
    _restaurant = restaurant;
    _table = table;
    _productsModel = [[OMNProductsModel alloc] init];
    
    __weak typeof(self)weakSelf = self;
    _productsModel.productSelectionBlock = ^(OMNProduct *product) {
      
      OMNProductDetailsVC *productDetailsVC = [[OMNProductDetailsVC alloc] initWithProduct:product];
      [weakSelf.navigationController pushViewController:productDetailsVC animated:YES];
      
    };
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // Set outself as the navigation controller's delegate so we're asked for a transitioning object
  self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  // Stop being the navigation controller's delegate
  if (self.navigationController.delegate == self) {
    self.navigationController.delegate = nil;
  }
}

- (void)setup {
 
  _productsView.delegate = _productsModel;
  _productsView.dataSource = _productsModel;
  _productsView.backgroundColor = [UIColor clearColor];
  
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{
     NSFontAttributeName : [OMNAssetManager manager].navBarTitleFont
     }];
  
  [self.navigationItem setHidesBackButton:YES];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset tables", nil) style:UIBarButtonItemStylePlain target:self action:@selector(resetTablesTap)];
  self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
  
  _backgroundIV.image = [UIImage imageNamed:@"background_blur"];

  UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"User", nil) style:UIBarButtonItemStylePlain target:self	action:@selector(userProfileTap)];
  userButton.tintColor = [UIColor whiteColor];
  self.navigationItem.rightBarButtonItems = @[userButton];
  
  [[OMNAuthorisation authorisation] setLogoutCallback:^{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.delegate restaurantMenuVCDidFinish:self];
    
  }];
  
}

- (void)userProfileTap {

  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] init];

  _transitionDelegate = [[OMNUserInfoTransitionDelegate alloc] init];
  __weak typeof(self)weakSelf = self;
  _transitionDelegate.didFinishBlock = ^{
    
    [weakSelf dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navVC.transitioningDelegate = _transitionDelegate;
  navVC.modalPresentationStyle = UIModalPresentationCustom;
  [self presentViewController:navVC animated:YES completion:nil];

  return;
#ifdef __IPHONE_8_0
  if (&UIApplicationOpenSettingsURLString) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
  }
#endif
  
}

- (void)resetTablesTap {
  
  [[OMNBeaconBackgroundManager manager] forgetFoundBeacons];
  
}

- (void)refreshOrders {
  
  return;

  
  __weak OMNRestaurantMenuVC *weakSelf = self;
  [_restaurant getMenu:^(OMNMenu *menu) {
    
    [weakSelf finishLoadingMenu:menu];
    
  } error:^(NSError *error) {
    
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }];
  
}

- (IBAction)callWaiterTap {
  
  __weak typeof(self)weakSelf = self;
  [self searchTableWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    [_restaurant callWaiterForTableID:decodeBeacon.tableId success:^{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Официант успешно позван", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
      });
      
    } error:^(NSError *error) {
      
      NSLog(@"error>%@", error);
      
    }];
    
    [weakSelf.navigationController popToViewController:self animated:YES];
    
  }];
  
}

- (void)searchTableWithBlock:(OMNSearchTableVCBlock)block {

  OMNSearchTableVC *searchTableVC = [[OMNSearchTableVC alloc] initWithBlock:block];
  [self.navigationController pushViewController:searchTableVC animated:YES];
  
}

- (IBAction)getOrdersTap {
  
  __weak typeof(self)weakSelf = self;
  OMNRestaurant *restaurant = _restaurant;
  [self searchTableWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    if (nil == decodeBeacon) {
      return;
    }
    
    [restaurant getOrdersForTableID:decodeBeacon.tableId orders:^(NSArray *orders) {

      [weakSelf processOrders:orders];
      
    } error:^(NSError *error) {
      
      [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      [weakSelf.navigationController popToViewController:weakSelf animated:YES];
      
    }];
    
  }];
  
  
}

- (void)processOrders:(NSArray *)orders {
  
  if (orders.count > 1) {

    [self selectOrderFromOrders:orders];
    
  }
  else if (1 == orders.count){

    [self showOrder:[orders firstObject]];
    
  }
  else {
    
    [self.navigationController popToViewController:self animated:YES];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"На этом столике нет заказов", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }
  
}

- (void)selectOrderFromOrders:(NSArray *)orders {
  
  OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithOrders:orders];
  ordersVC.delegate = self;
  ordersVC.title = @"Заказы";
  [self.navigationController omn_replaceCurrentViewControllerWithController:ordersVC animated:YES];
  
}

#pragma mark - OMNOrdersVCDelegate

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order {
  
  [self showOrder:order];
  
}

- (void)showOrder:(OMNOrder *)order {
  
  OMNPaymentVC *paymentVC = [[OMNPaymentVC alloc] initWithOrder:order];
  paymentVC.title = order.created;
  [self.navigationController omn_replaceCurrentViewControllerWithController:paymentVC animated:YES];
  
}

- (void)finishLoadingMenu:(OMNMenu *)menu {
  
  _menu = menu;
  
}

#pragma mark UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
  // Check if we're transitioning from this view controller to a DSLSecondViewController
  if (fromVC == self && [toVC isKindOfClass:[OMNProductDetailsVC class]]) {
    OMNStubProductCell *selectedCell = (OMNStubProductCell *)[_productsView cellForItemAtIndexPath:[_productsView indexPathsForSelectedItems].firstObject];
    return [[OMNTransitionFromListToProduct alloc] initWithCell:selectedCell];
  }
  else {
    return nil;
  }
}

#pragma mark

- (OMNStubProductCell *)collectionViewCellForProduct:(OMNProduct *)product {
  
  NSIndexPath *indexPath = [_productsModel indexPathForProduct:product];
  return (OMNStubProductCell *)[_productsView cellForItemAtIndexPath:indexPath];
  
}

@end
