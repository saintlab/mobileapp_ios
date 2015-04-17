//
//  OMNViewController.m
//  OMNMailRuAcquiring
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNMailRuAcquiring.h>
#import <AFHTTPRequestOperationManager.h>

#define test_restaurant_id  @"701137"

@interface OMNViewController ()
<UIAlertViewDelegate>
@property (nonatomic, strong) OMNMailRuUser *user;
@property (nonatomic, copy) NSString *cardID;
@property (nonatomic, copy) NSString *internalCardID;

@end

@implementation OMNViewController {
  
  __weak IBOutlet UILabel *_cardIDLabel;
  
  AFHTTPRequestOperationManager *_authManager;
  AFHTTPRequestOperationManager *_operationManager;
  
  NSNumber *_heldAmount;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSString *token = @"YaqOpPO008IXxxs8FSaLX5iOHkWqMqgu";
  _heldAmount = @(1);
  
  _authManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://wicket.staging.saintlab.com"]];
  _authManager.responseSerializer = [AFJSONResponseSerializer serializer];
  _authManager.requestSerializer = [AFJSONRequestSerializer serializer];
  [_authManager.requestSerializer setValue:token forHTTPHeaderField:@"x-authentication-token"];
  
  [_authManager POST:@"/user" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    id user = responseObject[@"user"];
    self.user = [OMNMailRuUser userWithLogin:user[@"id"] phone:user[@"phone"]];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];

  _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://omnom.staging.saintlab.com"]];
  _operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
  _operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
  [_operationManager.requestSerializer setValue:token forHTTPHeaderField:@"x-authentication-token"];
  [self reloadCards];
  
  NSDictionary *config =
  @{
    @"OMNMailRuAcquiringBaseURL" : @"https://cpg.money.mail.ru/api/",
    @"OMNMailRuTestCVV" : @"",
    @"OMNMailRu_cardholder" : @"Omnom",
    @"OMNMailRu_merch_id" : @"DGIS",
    @"OMNMailRu_secret_key" : @"5FEgXKDjuaegndwVJugNVUTMov8AXR7kY6CFLdivveDpxn5XmF",
    @"OMNMailRu_vterm_id" : @"DGISMobile2S",
    };
  [OMNMailRuAcquiring setConfig:config];
  
  [self updateOrderID];
  
}

- (void)reloadCards {
  
  [_operationManager GET:@"/cards" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    id card = [responseObject[@"cards"] firstObject];
    self.cardID = card[@"external_card_id"];
    self.internalCardID = card[@"id"];
    NSLog(@"%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];
  
}

- (void)setLastOrderID:(NSString *)orderID {
  [[NSUserDefaults standardUserDefaults] setObject:orderID forKey:@"orderID"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [self updateOrderID];
}

- (void)updateOrderID {
  NSString *orderID = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderID"];
  _cardIDLabel.text = orderID;
}

- (OMNMailRuCard *)testCardInfoWithSaveCard:(BOOL)saveCard {
  
  NSString *exp_date = [OMNMailRuCard exp_dateFromMonth:1 year:16];
  OMNMailRuCard *mailRuCardInfo = [OMNMailRuCard cardWithPan:@"5213243738433281" exp_date:exp_date cvv:@"954"];
  mailRuCardInfo.add_card = saveCard;
  return mailRuCardInfo;
  
}

- (IBAction)payAndRegisterTap:(id)sender {
  
  OMNMailRuTransaction *transaction = [[OMNMailRuTransaction alloc] init];
  transaction.card = [self testCardInfoWithSaveCard:YES];
  transaction.user = self.user;
  transaction.order = [OMNMailRuOrder orderWithID:@"" amount:_heldAmount];
  
  [OMNMailRuAcquiring payWithInfo:transaction].then(^(id response, id pollResponse) {
    
    NSString *order_id = pollResponse[@"order_id"];
    [self setLastOrderID:order_id];
    [self reloadCards];

  }).catch(^(NSError *error) {
    
    NSLog(@"payAndRegisterTap>%@", error);
    
  });

}

- (IBAction)declineTap:(id)sender {
  
  NSString *orderID = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderID"];
  if (!orderID) {
    return;
  }
  
  [OMNMailRuAcquiring refundOrder:orderID].then(^{
    
    [self setLastOrderID:nil];
    
  }).catch(^(NSError *error) {
    
    NSLog(@"declineTap>%@", error);
    
  });
  
}

- (IBAction)registerTap:(id)sender {
  
  OMNMailRuTransaction *transaction = [[OMNMailRuTransaction alloc] init];
  transaction.card = [self testCardInfoWithSaveCard:NO];
  transaction.user = self.user;
  [OMNMailRuAcquiring registerCard:transaction].then(^(NSString *cardID) {
    
    NSLog(@"registerTap>%@", cardID);
    [[NSUserDefaults standardUserDefaults] setObject:cardID forKey:@"cardID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self verifyTap:nil];
    
  }).catch(^(NSError *error) {
    
    NSLog(@"registerTap>%@", error);
    
  });
 
}

- (IBAction)verifyTap:(id)sender {
  
  UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"hold amount" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
  a.alertViewStyle = UIAlertViewStylePlainTextInput;
  UITextField *tf = [a textFieldAtIndex:0];
  tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  [a show];

}

- (void)verify:(double)amount {

  NSString *cardID = [[NSUserDefaults standardUserDefaults] objectForKey:@"cardID"];
  OMNMailRuTransaction *transaction = [[OMNMailRuTransaction alloc] init];
  transaction.card = [OMNMailRuCard cardWithID:cardID];
  transaction.user = self.user;
  transaction.order = [OMNMailRuOrder orderWithID:@"" amount:@(amount)];

  [OMNMailRuAcquiring verifyCard:transaction].then(^(NSDictionary *response) {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"cardID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  }).catch(^(NSError *error) {
    
    NSLog(@"verifyTap>%@", error);
    
  });

}

- (IBAction)deleteCard:(id)sender {
  
  OMNMailRuTransaction *transaction = [[OMNMailRuTransaction alloc] init];
  transaction.card = [OMNMailRuCard cardWithID:self.cardID];
  transaction.user = self.user;

  [OMNMailRuAcquiring deleteCard:transaction].then(^(NSDictionary *response) {
    
    NSString *path = [NSString stringWithFormat:@"/cards/%@", self.internalCardID];
    [_operationManager DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      NSLog(@"deleteCard>%@", responseObject);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      NSLog(@"deleteCard>%@", error);
      
    }];
  }).catch(^(NSError *error) {
    
    NSLog(@"deleteCard>%@", error);
    
  });
  
}

- (IBAction)payWithCardID:(id)sender {
  
  OMNMailRuTransaction *transaction = [[OMNMailRuTransaction alloc] init];
  transaction.card = [OMNMailRuCard cardWithID:self.cardID];
  transaction.user = self.user;
  transaction.order = [OMNMailRuOrder orderWithID:@"1" amount:@(0.01)];
  
  [OMNMailRuAcquiring payWithInfo:transaction].then(^(id response, id pollResponse) {
    
    NSString *order_id = pollResponse[@"order_id"];
    [self setLastOrderID:order_id];
    [self reloadCards];
    NSLog(@"payWithCardID response>%@ %@", response, pollResponse);
    
  }).catch(^(NSError *error) {
    
    NSLog(@"payWithCardID error>%@", error);
    
  });
  
}

- (IBAction)payWithNewCard:(id)sender {
  
  OMNMailRuTransaction *transaction = [[OMNMailRuTransaction alloc] init];
  transaction.card = [self testCardInfoWithSaveCard:NO];
  transaction.user = self.user;
  transaction.order = [OMNMailRuOrder orderWithID:@"1" amount:@(0.01)];
  
  [OMNMailRuAcquiring payWithInfo:transaction].then(^(id response, id pollResponse) {
    
    NSString *order_id = pollResponse[@"order_id"];
    [self setLastOrderID:order_id];
    NSLog(@"payWithNewCard response>%@ %@", response, pollResponse);
    
  }).catch(^(NSError *error) {
    
    NSLog(@"payWithNewCard error>%@", error);
    
  });
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (alertView.cancelButtonIndex != buttonIndex) {
    
    UITextField *tf = [alertView textFieldAtIndex:0];
    [self verify:[tf.text doubleValue]];
    
  }
  
}

@end
