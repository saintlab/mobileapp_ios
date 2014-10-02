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

@interface OMNBankCardsModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNSelectCardBlock didSelectCardBlock;
@property (nonatomic, assign) BOOL canDeleteCard;
@property (nonatomic, strong, readonly) NSMutableArray *cards;
@property (nonatomic, weak) OMNBankCard *selectedCard;

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock;
- (void)updateCardSelection;
- (void)addCardFromViewController:(__weak UIViewController *)viewController;

@end
