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

@interface OMNViewController ()

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *user_phone;

@end

@implementation OMNViewController {
  NSString *_cardId;
  NSDictionary *_cardInfo;
  
  __weak IBOutlet UILabel *_cardIDLabel;
  
  AFHTTPRequestOperationManager *_authManager;
  AFHTTPRequestOperationManager *_operationManager;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSString *token = @"YaqOpPO008IXxxs8FSaLX5iOHkWqMqgu";

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
  
  [_operationManager GET:@"/cards" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];

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
  

  _user_phone = @"89833087335";
  
//  _cardId = @"30002847034833862453";
//  _cardInfo =
//  @{
//    @"pan" : @"4111111111111111",
//    @"exp_date" : @"12.2015",
//    @"cvv" : kOMNMailRu_cvv,
//    };
  
  _cardId = @"30001197651493912571";

  _cardInfo =
  @{
//    @"pan" : @"4111111111111112",
    @"pan" : @"639002000000000003",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    };
  
//  _cardId = @"30001197651493912571";
//  _cardInfo =
//  @{
//    @"pan" : @"639002000000000003",
//    @"exp_date" : @"12.2015",
//    @"cvv" : kOMNMailRu_cvv,
//    };
  
}

- (void)setOrderID:(NSString *)orderID {
  [[NSUserDefaults standardUserDefaults] setObject:orderID forKey:@"orderID"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [self updateOrderID];
}

- (void)updateOrderID {
  NSString *orderID = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderID"];
  _cardIDLabel.text = orderID;
}

- (IBAction)payAndRegisterTap:(id)sender {
  
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  
  NSString *exp_date = [OMNMailRuCardInfo exp_dateFromMonth:1 year:16];
  OMNMailRuCardInfo *mailRuCardInfo = [OMNMailRuCardInfo cardInfoWithCardPan:@"5213243738433281" exp_date:exp_date cvv:@"954"];
  mailRuCardInfo.add_card = YES;
  paymentInfo.cardInfo = mailRuCardInfo;
  paymentInfo.user_login = self.userID;
  paymentInfo.user_phone = self.user_phone;
  paymentInfo.order_message = @"message";
  paymentInfo.extra.tip = 0;
  paymentInfo.extra.restaurant_id = @"";
  paymentInfo.extra.type = @"";
  paymentInfo.order_amount = @(1);
  paymentInfo.order_id = @"";
  
  [[OMNMailRuAcquiring acquiring] payWithInfo:paymentInfo completion:^(id response) {

    NSString *order_id = response[@"order_id"];
    [self setOrderID:order_id];
    NSLog(@"%@", response);
    
  } failure:^(NSError *mailError, NSDictionary *request, NSDictionary *response) {

    NSLog(@"%@ %@ %@", mailError, request, response);
    
  }];

}

- (IBAction)declineTap:(id)sender {
  
  NSString *orderID = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderID"];
  if (!orderID) {
    return;
  }
  
  [[OMNMailRuAcquiring acquiring] refundOrder:orderID completion:^{
    
    [self setOrderID:nil];
    
  } failure:^(NSError *error, NSDictionary *request, NSDictionary *response) {
    
    NSLog(@"%@ %@ %@", error, request, response);
    
  }];
  
}

- (IBAction)registerTap:(id)sender {
  
  NSDictionary *cardInfo =
  @{
    //    @"pan" : @"4111111111111112",
    @"pan" : @"6011000000000004",
    //    @"pan" : @"639002000000000003",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    };
  
//  [[OMNMailRuAcquiring acquiring] registerCard:cardInfo user_login:_user_login user_phone:_user_phone completion:^(id response, NSString *cardId) {
//
//    NSLog(@"%@  %@", response, cardId);
//    
//  }];

}

- (IBAction)verifyTap:(id)sender {
  
//  _cardId = @"30008685803965102459";
//  [[OMNMailRuAcquiring acquiring] cardVerify:1.02 user_login:_user_login card_id:_cardId completion:^{
//    
//  } failure:^(NSError *error, NSDictionary *debugInfo) {
//    
//  }];
}

- (IBAction)deleteCard:(id)sender {
//  [[OMNMailRuAcquiring acquiring] cardDelete:_cardId user_login:_user_login completion:^(id response) {
//    
//  }];
}

- (IBAction)payWithCardID:(id)sender {
  
//  NSDictionary *cardInfo =
//  @{
//    @"card_id" : _cardId,
//    @"cvv" : @"123",
//    };
//  [[OMNMailRuAcquiring acquiring] payWithCardInfo:cardInfo  user_login:_user_login addCard:NO];
  
}

- (IBAction)payWithNewCard:(id)sender {
  
//  [[OMNMailRuAcquiring acquiring] payWithCardInfo:_cardInfo user_login:_user_login addCard:NO];
  
}

@end
