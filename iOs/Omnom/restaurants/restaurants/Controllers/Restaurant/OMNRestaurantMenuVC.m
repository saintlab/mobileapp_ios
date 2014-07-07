//
//  GRestaurantMenuVC.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMenuVC.h"
#import "OMNSearchTableVC.h"

#import "OMNBeaconBackgroundManager.h"
#import "OMNAuthorisation.h"
#import "OMNProductsModel.h"
#import "OMNNavigationControllerDelegate.h"

#import "OMNRestaurantMenuMediator.h"

#import <OMNStyler.h>

@interface OMNRestaurantMenuVC () {
  
  __weak IBOutlet UIButton *_waiterButton;
  __weak IBOutlet UIButton *_billButton;
  __weak IBOutlet UIImageView *_backgroundIV;
  __weak IBOutlet UILabel *_recomendLabel;
  __weak IBOutlet UIView *_waiterIsCalledView;
 
  OMNNavigationControllerDelegate *_navigationControllerDelegate;
  OMNRestaurant *_restaurant;
  OMNTable *_table;
  
  OMNProductsModel *_productsModel;

}

@property (nonatomic, strong) OMNRestaurantMenuMediator *restaurantMenuMediator;

@end

@implementation OMNRestaurantMenuVC

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant table:(OMNTable *)table {
  self = [super initWithNibName:@"OMNRestaurantMenuVC" bundle:nil];
  if (self) {
    _restaurant = restaurant;
    _table = table;
    
    _productsModel = [[OMNProductsModel alloc] init];
    
    _restaurantMenuMediator = [[OMNRestaurantMenuMediator alloc] initWithRootViewController:self];
    
    _navigationControllerDelegate = [[OMNNavigationControllerDelegate alloc] init];
    
    __weak typeof(self)weakSelf = self;
    _productsModel.productSelectionBlock = ^(OMNProduct *product) {
      
      [weakSelf.restaurantMenuMediator showProductDetails:product];
      
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
  
  self.navigationController.delegate = _navigationControllerDelegate;
  
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  
}

- (void)setup {
 
  _productsView.delegate = _productsModel;
  _productsView.dataSource = _productsModel;
  _productsView.backgroundColor = [UIColor clearColor];
  
  _recomendLabel.font = FuturaBookFont(20);
  _recomendLabel.text = NSLocalizedString(@"Рекомендуем попробовать", nil);
  _recomendLabel.textColor = [UIColor whiteColor];

  OMNStyle *style = [[OMNStyler styler] styleForClass:[UINavigationBar class]];
  [self.navigationController.navigationBar setTitleTextAttributes:
   @{
     NSFontAttributeName : [style fontForKey:@"titleFont"],
     NSForegroundColorAttributeName : [style colorForKey:@"titleColor"]
     }];
  
  [self.navigationItem setHidesBackButton:YES];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset tables", nil) style:UIBarButtonItemStylePlain target:self action:@selector(resetTablesTap)];
  self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
  
  _backgroundIV.image = [UIImage imageNamed:@"background_blur"];

  _waiterIsCalledView.alpha = 0.0f;
  
  UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"User", nil) style:UIBarButtonItemStylePlain target:self	action:@selector(userProfileTap)];
  userButton.tintColor = [UIColor whiteColor];
  self.navigationItem.rightBarButtonItems = @[userButton];
  
  [[OMNAuthorisation authorisation] setLogoutCallback:^{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.delegate restaurantMenuVCDidFinish:self];
    
  }];
  
}

- (void)userProfileTap {

  [_restaurantMenuMediator showUserProfile];
  
}

- (void)resetTablesTap {
  
  [[OMNBeaconBackgroundManager manager] forgetFoundBeacons];
  
}

- (IBAction)callWaiterTap {
  
  __weak typeof(self)weakSelf = self;
  [self searchTableWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    [_restaurant callWaiterForTableID:decodeBeacon.tableId success:^{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf waiterIsCalled];
        
      });
      
    } error:^(NSError *error) {
      
      NSLog(@"error>%@", error);
      
    }];
    
    [weakSelf.navigationController popToViewController:self animated:YES];
    
  }];
  
}

- (void)waiterIsCalled {

  [UIView animateWithDuration:0.3 animations:^{
    _waiterIsCalledView.alpha = 1.0f;
  }];
  
}

- (IBAction)waiterIsCalledTap:(id)sender {
  
  [UIView animateWithDuration:0.5 animations:^{
    _waiterIsCalledView.alpha = 0.0f;
  }];
  
}

- (void)searchTableWithBlock:(OMNSearchTableVCBlock)block {

  __weak typeof(self)weakSelf = self;
  OMNSearchTableVC *searchTableVC = [[OMNSearchTableVC alloc] initWithBlock:block cancelBlock:^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  }];
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
  
  [_restaurantMenuMediator processOrders:orders];
  
}

#pragma mark

- (OMNStubProductCell *)collectionViewCellForProduct:(OMNProduct *)product {
  
  NSIndexPath *indexPath = [_productsModel indexPathForProduct:product];
  return (OMNStubProductCell *)[_productsView cellForItemAtIndexPath:indexPath];
  
}

@end
