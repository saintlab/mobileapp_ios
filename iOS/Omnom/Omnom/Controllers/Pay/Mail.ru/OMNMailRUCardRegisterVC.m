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

#define kRegisterLoadingDiration 20.0

@interface OMNMailRUCardRegisterVC ()

@end

@implementation OMNMailRUCardRegisterVC {
  
  OMNMailRuTransaction *_transaction;
  
}

- (instancetype)initWithTransaction:(OMNMailRuTransaction *)transaction {
  
  self = [super initWithParent:nil];
  if (self) {
    
    _transaction = transaction;
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
  [OMNMailRuAcquiring pay:_transaction].then(^(NSDictionary *response) {
    
    @strongify(self)
    [[OMNAnalitics analitics] logDebugEvent:@"MAIL_CARD_REGISTER" parametrs:response];
    
    if (response[@"order_id"]) {
      [OMNMailRuAcquiring refundOrder:response[@"order_id"]];
    }
    
    [self.delegate mailRUCardRegisterVCDidFinish:self];
    
  }).catch(^(NSError *error) {
    
    NSLog(@"payAndRegisterTap>%@", error);
    
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
