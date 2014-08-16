//
//  OMNBankCardsModel.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"
#import "OMNBankCardInfo.h"
#import <OMNMailRuPaymentInfo.h>

typedef void(^OMNSelectCardBlock)(OMNBankCard *bankCard);

@interface OMNBankCardsModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNSelectCardBlock didSelectCardBlock;
@property (nonatomic, assign) BOOL canDeleteCard;
//@property (nonatomic, strong, readonly) OMNBankCard *selectedCard;
@property (nonatomic, strong, readonly) OMNMailRuPaymentInfo *selectedCardPaymentInfo;

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock;

@end
