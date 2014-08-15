//
//  OMNRatingVC.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRatingVC.h"
#import "OMNRatingModel.h"
#import "OMNOrder.h"
#import "OMNSocketManager.h"

@interface OMNRatingVC ()

@end

@implementation OMNRatingVC {
  
  OMNRatingModel *_ratingModel;
  __weak IBOutlet UICollectionView *_productsView;
  __weak IBOutlet UIButton *_chequeButton;
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _ratingModel = [[OMNRatingModel alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(billCallDone:) name:OMNSocketIOBillCallDoneNotification object:nil];
  
  [_chequeButton setTitle:NSLocalizedString(@"Чек пожалуйста", nil) forState:UIControlStateNormal];
  [_chequeButton setTitle:NSLocalizedString(@"Отмена", nil) forState:UIControlStateSelected];
  [_chequeButton setTitle:NSLocalizedString(@"Отмена", nil) forState:UIControlStateSelected|UIControlStateHighlighted];
  
  if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  
  _productsView.delegate = _ratingModel;
  _productsView.dataSource = _ratingModel;
  _productsView.backgroundColor = [UIColor clearColor];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeTap)];

}

- (void)billCallDone:(NSNotification *)n {
  _chequeButton.selected = NO;
}

- (IBAction)chequeTap:(id)sender {
  
  if (_chequeButton.selected) {
    [_order billCallStop:^{
      
      _chequeButton.selected = NO;
      
    } failure:^(NSError *error) {
      
    }];
  }
  else {
    
    [_order billCall:^{
      
      _chequeButton.selected = YES;
      
    } failure:^(NSError *error) {
      
    }];
    
  }
  
}

- (void)closeTap {
  [self.delegate ratingVCDidFinish:self];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
