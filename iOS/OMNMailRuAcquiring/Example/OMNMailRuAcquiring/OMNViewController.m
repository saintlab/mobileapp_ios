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

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *user_phone;
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
    self.userID = user[@"id"];
    self.user_phone = user[@"phone"];
    
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

- (OMNMailRuCardInfo *)testCardInfoWithSaveCard:(BOOL)saveCard {
  
  NSString *exp_date = [OMNMailRuCardInfo exp_dateFromMonth:1 year:16];
  OMNMailRuCardInfo *mailRuCardInfo = [OMNMailRuCardInfo cardInfoWithCardPan:@"5213243738433281" exp_date:exp_date cvv:@"954"];
  mailRuCardInfo.add_card = saveCard;
  return mailRuCardInfo;
  
}

- (IBAction)payAndRegisterTap:(id)sender {
  
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  paymentInfo.cardInfo = [self testCardInfoWithSaveCard:YES];
  paymentInfo.user_login = self.userID;
  paymentInfo.user_phone = self.user_phone;
  paymentInfo.order_message = @"message";
  paymentInfo.extra.tip = 0;
  paymentInfo.extra.restaurant_id = @"";
  paymentInfo.extra.type = @"";
  paymentInfo.order_amount = _heldAmount;
  paymentInfo.order_id = @"";
  
  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {

    NSString *order_id = response[@"order_id"];
    [self setLastOrderID:order_id];
    [self reloadCards];
    NSLog(@"payAndRegisterTap>%@", response);
    
  } failure:^(NSError *mailError, NSDictionary *request, NSDictionary *response) {

    NSLog(@"payAndRegisterTap>%@ %@ %@", mailError, request, response);
    
  }];

}

- (IBAction)declineTap:(id)sender {
  
  NSString *orderID = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderID"];
  if (!orderID) {
    return;
  }
  
  [[OMNMailRuAcquiring acquiring] refundOrder:orderID completion:^{
    
    [self setLastOrderID:nil];
    
  } failure:^(NSError *error, NSDictionary *request, NSDictionary *response) {
    
    NSLog(@"declineTap>%@ %@ %@", error, request, response);
    
  }];
  
}

- (IBAction)registerTap:(id)sender {
  
 
}

- (IBAction)verifyTap:(id)sender {
//  [[OMNMailRuAcquiring acquiring] cardVerify:1.02 user_login:_user_login card_id:_cardId completion:^{
//    
//  } failure:^(NSError *error, NSDictionary *debugInfo) {
//    
//  }];
}

- (IBAction)deleteCard:(id)sender {
  
  [[OMNMailRuAcquiring acquiring] deleteCard:self.cardID user_login:self.userID сompletion:^{
    
    NSString *path = [NSString stringWithFormat:@"/cards/%@", self.internalCardID];
    [_operationManager DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      NSLog(@"deleteCard>%@", responseObject);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

      NSLog(@"deleteCard>%@", error);
      
    }];
    
  } failure:^(NSError *error, NSDictionary *request, NSDictionary *response) {
    
    NSLog(@"deleteCard>%@ %@ %@", error, request, response);
    
  }];

}

- (IBAction)payWithCardID:(id)sender {
  
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  OMNMailRuCardInfo *mailRuCardInfo = [OMNMailRuCardInfo cardInfoWithCardId:self.cardID];
  paymentInfo.cardInfo = mailRuCardInfo;
  paymentInfo.user_login = self.userID;
  paymentInfo.user_phone = self.user_phone;
  paymentInfo.order_message = @"message";
  paymentInfo.extra.tip = 0;
  paymentInfo.extra.restaurant_id = test_restaurant_id;
  paymentInfo.extra.type = @"order";
  paymentInfo.order_amount = @(0.01);
  paymentInfo.order_id = @"1";
  
  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
    
    NSLog(@"payWithCardID response>%@", response);
    
  } failure:^(NSError *error, NSDictionary *request, NSDictionary *response) {
    
    NSLog(@"payWithCardID error>%@", response);
    
  }];
  
}

- (IBAction)payWithNewCard:(id)sender {
  
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  paymentInfo.cardInfo = [self testCardInfoWithSaveCard:NO];
  paymentInfo.user_login = self.userID;
  paymentInfo.user_phone = self.user_phone;
  paymentInfo.order_message = @"message";
  paymentInfo.extra.tip = 0;
  paymentInfo.extra.restaurant_id = test_restaurant_id;
  paymentInfo.extra.type = @"";
  paymentInfo.order_amount = _heldAmount;
  paymentInfo.order_id = @"";
  
  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {
    
    NSString *order_id = response[@"order_id"];
    [self setLastOrderID:order_id];
    NSLog(@"payWithNewCard response>%@", response);
    
  } failure:^(NSError *mailError, NSDictionary *request, NSDictionary *response) {
    
    NSLog(@"payWithNewCard error>%@ %@ %@", mailError, request, response);
    
  }];
  
}

@end
