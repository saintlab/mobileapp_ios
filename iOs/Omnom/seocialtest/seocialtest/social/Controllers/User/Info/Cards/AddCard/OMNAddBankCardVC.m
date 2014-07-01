//
//  OMNAddBankCardsVC.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAddBankCardVC.h"

@interface OMNAddBankCardVC ()

@end

@implementation OMNAddBankCardVC {
  
  __weak IBOutlet UITextField *_cardTF;
  __weak IBOutlet UIButton *_addCardButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _cardTF.keyboardType = UIKeyboardTypeDecimalPad;
  [_addCardButton setTitle:NSLocalizedString(@"Готово", nil) forState:UIControlStateNormal];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отменить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
}

- (IBAction)addCardTap:(id)sender {
  
  OMNBankCard *bankCard = [[OMNBankCard alloc] init];
  bankCard.name = _cardTF.text;
  [self.delegate addBankCardVC:self didAddCard:bankCard];
  
}

- (void)cancelTap {
  
  [self.delegate addBankCardVCDidCancel:self];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
