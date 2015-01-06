//
//  OMNScanTableQRCodeVC.m
//  omnom
//
//  Created by tea on 04.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNScanTableQRCodeVC.h"
#import "OMNCircleRootVC.h"
#import "OMNRestaurantManager.h"

@interface OMNScanTableQRCodeVC ()
<OMNScanQRCodeVCDelegate>

@end

@implementation OMNScanTableQRCodeVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.delegate = self;
  
}

- (void)decodeQR:(NSString *)qr {
  
  __weak typeof(self)weakSelf = self;
  [OMNRestaurantManager decodeQR:qr withCompletion:^(NSArray *restaurants) {
    
    [weakSelf didFindRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    [weakSelf processError:error];
    
  }];
  
}

- (void)didFindRestaurants:(NSArray *)restaurants {
  
  [self.tableDelegate scanTableQRCodeVC:self didFindRestaurants:restaurants];
  
}

- (void)processError:(OMNError *)error {
  
  OMNCircleRootVC *repeatVC = [[OMNCircleRootVC alloc] initWithParent:nil];
  repeatVC.faded = YES;
  repeatVC.text = error.localizedDescription;
  repeatVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  repeatVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Проверить ещё") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf.navigationController popToViewController:weakSelf animated:YES];
      
    }]
    ];
  [self.navigationController pushViewController:repeatVC animated:YES];
  
}

#pragma mark - OMNScanQRCodeVCDelegate

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code {
  
  if (0 == code.length) {
    return;
  }
  
  [scanQRCodeVC stopScanning];
  [self decodeQR:code];
  
}

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC {
  
  [self.tableDelegate scanTableQRCodeVCDidCancel:self];
  
}

@end
