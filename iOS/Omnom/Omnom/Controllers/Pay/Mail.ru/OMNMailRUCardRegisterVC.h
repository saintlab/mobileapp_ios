//
//  OMNMailRUCardRegisterVC.h
//  omnom
//
//  Created by tea on 20.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLoadingCircleVC.h"
#import "OMNBankCardInfo.h"

@protocol OMNMailRUCardRegisterVCDelegate;

@interface OMNMailRUCardRegisterVC : OMNLoadingCircleVC

@property (nonatomic, weak) id<OMNMailRUCardRegisterVCDelegate> delegate;

- (instancetype)initWithBankCardInfo:(OMNBankCardInfo *)bankCardInfo;

@end

@protocol OMNMailRUCardRegisterVCDelegate <NSObject>

- (void)mailRUCardRegisterVCDidFinish:(OMNMailRUCardRegisterVC *)mailRUCardRegisterVC;
- (void)mailRUCardRegisterVCDidCancel:(OMNMailRUCardRegisterVC *)mailRUCardRegisterVC;
- (void)mailRUCardRegisterVC:(OMNMailRUCardRegisterVC *)mailRUCardRegisterVC didFinishWithError:(NSError *)error;

@end