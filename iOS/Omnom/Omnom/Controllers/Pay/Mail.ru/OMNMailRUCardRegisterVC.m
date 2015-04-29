//
//  OMNMailRUCardRegisterVC.m
//  omnom
//
//  Created by tea on 20.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMailRUCardRegisterVC.h"
#import "OMNAnalitics.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "OMNBankCardInfo+omn_mailRuBankCardInfo.h"
#import "OMNUser+omn_mailRu.h"
#import <OMNMailRuAcquiring.h>
#import "OMNAuthorization.h"

#define kRegisterLoadingDiration 20.0

@interface OMNMailRUCardRegisterVC ()

@end

@implementation OMNMailRUCardRegisterVC {
  
  OMNBankCardInfo *_bankCardInfo;
  
}

- (instancetype)initWithBankCardInfo:(OMNBankCardInfo *)bankCardInfo {
  
  self = [super initWithParent:nil];
  if (self) {
    
    _bankCardInfo = bankCardInfo;
    self.circleIcon = [UIImage imageNamed:@"flying_credit_card_icon"];
    self.estimateAnimationDuration = kRegisterLoadingDiration;
    UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"000000")];
    self.circleBackground = circleBackground;
    
  }
  return self;
  
}

- (void)startLoading {
  
  [self.loaderView setLoaderColor:[UIColor colorWithWhite:0.0f alpha:0.1f]];
  [self.loaderView startAnimating:kRegisterLoadingDiration];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  @weakify(self)
  OMNMailRuUser *user = [[OMNAuthorization authorisation].user omn_mailRuUser];
  [OMNMailRuAcquiring payAndRegisterWithPan:_bankCardInfo.pan exp_date:[OMNMailRuCard exp_dateFromMonth:_bankCardInfo.expiryMonth year:_bankCardInfo.expiryYear] cvv:_bankCardInfo.cvv user:user].then(^(OMNMailRuPoll *poll) {
    
    @strongify(self)
    [[OMNAnalitics analitics] logDebugEvent:@"MAIL_CARD_REGISTER" parametrs:poll.response];

#warning TODO:order_id
//    if (response[@"order_id"]) {
//      [OMNMailRuAcquiring refundOrder:response[@"order_id"]];
//    }
    
    [self.delegate mailRUCardRegisterVCDidFinish:self];
    
  }).catch(^(NSError *error) {
    
    NSLog(@"payAndRegisterTap>%@", error);
    
    [[OMNAnalitics analitics] logMailEvent:@"ERROR_CARD_REGISTER" cardInfo:_bankCardInfo error:error];
    
    @strongify(self)
    if (kOMNMailRuErrorCodeCancel == error.code) {
      [self.delegate mailRUCardRegisterVCDidCancel:self];
    }
    else {
      
      [self finishLoading:^{
        
        @strongify(self)
        [self setText:error.localizedDescription];
        self.buttonInfo =
        @[
          [OMNBarButtonInfo infoWithTitle:kOMN_OK_BUTTON_TITLE image:nil block:^{
            
            [self.delegate mailRUCardRegisterVC:self didFinishWithError:error];
            
          }]
          ];
        [self updateActionBoard];
        [self.view layoutIfNeeded];
        
      }];
      
      
    }
    
  });
  
  [self startLoading];
  
}

@end
