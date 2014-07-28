//
//  OMNR1VC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNR1VC.h"
#import "OMNSearchBeaconVC.h"
#import "OMNPayOrderVC.h"

const CGFloat kWaiterButtonsHeight = 50.0f;

@interface OMNR1VC ()
<OMNPayOrderVCDelegate>

@end

@implementation OMNR1VC {
  UIButton *_callWaiterButton;
  UIButton *_callOrderButton;
  OMNRestaurant *_restaurant;
  UIView *_waiterButtonsBg;
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super initWithTitle:nil buttons:@[]];
  if (self) {
    _restaurant = restaurant;
    
//    _productsModel = [[OMNProductsModel alloc] init];
//    _restaurantMenuMediator = [[OMNRestaurantMenuMediator alloc] initWithRootViewController:self];
    
  }
  return self;
}

- (instancetype)init {
  
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.backgroundView.image = [UIImage imageNamed:@"bg_pic"];
  
  _waiterButtonsBg = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - kWaiterButtonsHeight, CGRectGetWidth(self.view.bounds), kWaiterButtonsHeight)];
  _waiterButtonsBg.hidden = YES;
  _waiterButtonsBg.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  [self.view addSubview:_waiterButtonsBg];
  
  _callWaiterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_waiterButtonsBg.frame)/2.0f, CGRectGetHeight(_waiterButtonsBg.frame))];
  [_callWaiterButton setImage:[UIImage imageNamed:@"call_waiter_icon_small"] forState:UIControlStateNormal];
  [_callWaiterButton setTitle:NSLocalizedString(@"Официант", nil) forState:UIControlStateNormal];
  [_callWaiterButton setTitle:NSLocalizedString(@"Отменить вызов", nil) forState:UIControlStateSelected];
  _callWaiterButton.titleLabel.numberOfLines = 0;
  _callWaiterButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  _callWaiterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  _callWaiterButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
  
  [_callWaiterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_callWaiterButton addTarget:self action:@selector(callWaiterTap) forControlEvents:UIControlEventTouchUpInside];
  [_waiterButtonsBg addSubview:_callWaiterButton];

  _callOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_waiterButtonsBg.frame)/2.0f, 0, CGRectGetWidth(_waiterButtonsBg.frame)/2.0f, CGRectGetHeight(_waiterButtonsBg.frame))];
  [_callOrderButton setImage:[UIImage imageNamed:@"call_bill_icon_small"] forState:UIControlStateNormal];
  [_callOrderButton addTarget:self action:@selector(callBillTap) forControlEvents:UIControlEventTouchUpInside];
  _callOrderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  [_callOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_callOrderButton setTitle:NSLocalizedString(@"Счет", nil) forState:UIControlStateNormal];
  _callOrderButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 10.0f);

  [_waiterButtonsBg addSubview:_callOrderButton];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  
  _waiterButtonsBg.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kWaiterButtonsHeight, CGRectGetWidth(self.view.bounds), kWaiterButtonsHeight);
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (_waiterButtonsBg.hidden) {
    _waiterButtonsBg.transform = CGAffineTransformMakeTranslation(0, kWaiterButtonsHeight);
    _waiterButtonsBg.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
      _waiterButtonsBg.transform = CGAffineTransformIdentity;
    }];
  }
}

- (void)callWaiterTap {
  
  if (_callWaiterButton.selected) {
    [self.circleButton setImage:[UIImage imageNamed:@"ginza_logo"] forState:UIControlStateNormal];
    _callWaiterButton.selected = NO;
    return;
  }
  
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
  
    _callWaiterButton.selected = YES;
    [self.circleButton setImage:[UIImage imageNamed:@"call_waiter_icon"] forState:UIControlStateNormal];
    [self.navigationController popToViewController:self animated:YES];
    
  } cancelBlock:^{

    _callWaiterButton.selected = NO;
    [self.circleButton setImage:[UIImage imageNamed:@"ginza_logo"] forState:UIControlStateNormal];
    [self.navigationController popToViewController:self animated:YES];
    
  }];
  searchBeaconVC.estimateSearchDuration = 2.0;
  searchBeaconVC.circleIcon = [UIImage imageNamed:@"call_waiter_icon"];
  searchBeaconVC.backgroundImage = self.backgroundView.image;
  [self.navigationController pushViewController:searchBeaconVC animated:YES];
  
}

- (void)callBillTap {
  
  OMNRestaurant *restaurant = _restaurant;
  __weak typeof(self)weakSelf = self;
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    [restaurant getOrdersForTableID:decodeBeacon.tableId orders:^(NSArray *orders) {
      
      [weakSelf processOrders:orders];
      
    } error:^(NSError *error) {
      
      [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      [self.navigationController popToViewController:self animated:YES];
      
    }];
    
  } cancelBlock:^{
    
    [self.navigationController popToViewController:self animated:YES];
    
  }];
  searchBeaconVC.estimateSearchDuration = 2.0;
  searchBeaconVC.circleIcon = [UIImage imageNamed:@"call_bill_icon"];
  searchBeaconVC.backgroundImage = self.backgroundView.image;
  [self.navigationController pushViewController:searchBeaconVC animated:YES];
  
}

- (void)processOrders:(NSArray *)orders {

  OMNOrder *order = [orders firstObject];
  OMNPayOrderVC *paymentVC = [[OMNPayOrderVC alloc] initWithOrder:order];
  paymentVC.delegate = self;
  paymentVC.title = order.created;
  [self.navigationController pushViewController:paymentVC animated:YES];
  
}

#pragma mark - OMNPayOrderVCDelegate

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC {
  [self.navigationController popToViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
