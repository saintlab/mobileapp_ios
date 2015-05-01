//
//  OMNViewController.m
//  OMNMailRuAcquiring
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "MailRuTestVC.h"
#import <OMNMailRuAcquiring.h>
#import <AFHTTPRequestOperationManager.h>

#define test_restaurant_id  @"701137"
#define kTest_pan  @"5213243738433281"
#define kTest_expire_date  ([OMNMailRuCard exp_dateFromMonth:1 year:16])
#define kTest_cvv  @"954"

@interface MailRuTestVC ()
<UIAlertViewDelegate>
@property (nonatomic, strong) OMNMailRuUser *user;
@property (nonatomic, strong) id card;

@end

@implementation MailRuTestVC {
  
  __weak IBOutlet UILabel *_cardIDLabel;
  __weak IBOutlet UILabel *_cardLabel;
  
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
    self.card = card;
    NSLog(@"%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];
  
}

- (void)setCard:(id)card {
  
  _card = card;
  _cardLabel.text = [NSString stringWithFormat:@"%@ %@", card[@"id"], card[@"external_card_id"]];
  
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

- (IBAction)payAndRegisterTap:(id)sender {

  [OMNMailRuAcquiring payAndRegisterWithPan:kTest_pan exp_date:kTest_expire_date cvv:kTest_cvv user:self.user].then(^(OMNMailRuPoll *poll) {
    
    NSLog(@"payAndRegisterTap>%@ %@", poll.request, poll.response);
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
  
  [OMNMailRuAcquiring registerCardWithPan:kTest_pan exp_date:kTest_expire_date cvv:kTest_cvv user:self.user].then(^(NSString *cardID) {
    
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
  [OMNMailRuAcquiring verifyCardWithID:cardID user:self.user amount:@(amount)].then(^(NSDictionary *response) {
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"cardID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  }).catch(^(NSError *error) {
    
    NSLog(@"verifyTap>%@", error);
    
  });

}

- (IBAction)deleteCard:(id)sender {
  
  [self deleteCardWithInfo:self.card].catch(^(NSError *error) {
    
    NSLog(@"deleteCard>%@", error);
    
  }).finally(^{

    [self reloadCards];
    
  });
  
}

- (IBAction)payWithCardID:(id)sender {

  [OMNMailRuAcquiring payWithCardID:self.card[@"external_card_id"] user:self.user order_id:@"1" order_amount:@(0.01) extra:nil].then(^(OMNMailRuPoll *poll) {
    
    [self setLastOrderID:@""];
    [self reloadCards];
    NSLog(@"payWithCardID>%@ %@", poll.request, poll.response);
    
  }).catch(^(NSError *error) {
    
    NSLog(@"payWithCardID error>%@", error);
    
  });
  
}

- (IBAction)payWithNewCard:(id)sender {
  
  [OMNMailRuAcquiring payWithWithPan:kTest_pan exp_date:kTest_expire_date cvv:kTest_cvv user:self.user order_id:@"1" order_amount:@(0.01) extra:nil].then(^(OMNMailRuPoll *poll) {
#warning TODO:order_id
//    NSString *order_id = response[@"order_id"];
//    [self setLastOrderID:order_id];
    NSLog(@"payWithNewCard>%@ %@", poll.request, poll.response);
    
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

- (PMKPromise *)deleteCardWithInfo:(id)cardInfo {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    NSString *path = [NSString stringWithFormat:@"/cards/%@", cardInfo[@"id"]];
    [_operationManager DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      NSLog(@"deleteCard>%@", responseObject);
      fulfill(nil);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject(error);
      NSLog(@"deleteCard>%@", error);
      
    }];
    
  }];
  
}

- (IBAction)magicTap:(id)sender {
  
  NSString *pan = @"4154812004292276";
  NSString *cvv = @"410";
  NSString *expire = [OMNMailRuCard exp_dateFromMonth:9 year:16];
  
  PMKPromise *pay = [OMNMailRuAcquiring payWithWithPan:pan exp_date:expire cvv:cvv user:self.user order_id:@"1" order_amount:@(0.01) extra:nil].then(^id(OMNMailRuPoll *poll) {

    NSLog(@"payWithWithPan>%@ %@", poll.request, poll.response);
//    NSString *order_id = response[@"order_id"];
    return nil;
//    if (order_id) {
//      return [OMNMailRuAcquiring refundOrder:order_id];
//    }
//    else {
//      return nil;
//    }
    
  }).then(^(OMNMailRuPoll *poll) {
    
    NSLog(@"refundOrder>%@ \n\n%@", poll.request, poll.response);
    
  }).catch(^(NSError *error) {
    
    NSLog(@"payWithWithPan error>%@", error);
    
  }).finally(^{
    
    NSLog(@"payWithWithPan finish");
    
  });

  __block NSString *tempCardID = @"";
#warning 123
  [PMKPromise when:nil].then(^(id response) {
  
    NSLog(@"did pay>%@", response);
    return  [OMNMailRuAcquiring payAndRegisterWithPan:pan exp_date:expire cvv:cvv user:self.user];
    
  }).then(^(OMNMailRuPoll *poll) {
    
    tempCardID = poll.card_id;
    NSLog(@"payAndRegisterWithPan>%@ %@", poll.request, poll.response);
    return [OMNMailRuAcquiring payWithCardID:tempCardID user:self.user order_id:@"1" order_amount:@(0.01) extra:nil];
    
  }).then(^(OMNMailRuPoll *poll) {
    
    NSLog(@"did pay>%@ %@", poll.request, poll.response);
#warning TODO:refund
//    return [OMNMailRuAcquiring refundOrder:order_id];
    return nil;
    
  }).then(^(OMNMailRuPoll *poll) {
    
    NSLog(@"pay order>%@ \n\n%@", poll.request, poll.response);
    return nil;//[OMNMailRuAcquiring deleteCardWithID:tempCardID user:self.user];
    
  }).then(^(NSDictionary *response) {
    
    NSLog(@"delete card>%@ \n\n%@", tempCardID, response);
    
    
  }).catch(^(NSError *error) {
    
    NSLog(@"registerTap>%@", error);
    
  }).finally(^{

    NSLog(@"magic finish");
    
  });

}


@end
