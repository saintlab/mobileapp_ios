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

typedef UIViewController *(^OMNSelectCardBlock)(OMNBankCard *bankCard);
typedef void(^OMNBankCardInfoBlock)(OMNBankCardInfo *bankCardInfo);

@class OMNOrder;

@interface OMNBankCardsModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNSelectCardBlock didSelectCardBlock;
@property (nonatomic, assign) BOOL canDeleteCard;
@property (nonatomic, assign, readonly) BOOL hasRegisterdCards;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong, readonly) NSMutableArray *cards;
@property (nonatomic, strong, readonly) OMNBankCard *selectedCard;

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock;
- (void)updateCardSelection;
- (void)addCardFromViewController:(__weak UIViewController *)viewController forOrder:(OMNOrder *)order requestPaymentWithCard:(OMNBankCardInfoBlock)paymentWithCardBlock;

@end
