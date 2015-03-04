//
//  OMNBankCardsModel.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"

@class OMNBankCardInfo;

typedef void (^OMNSelectCardBlock)(OMNBankCard *bankCard);

@class OMNOrder;

@interface OMNBankCardsModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNSelectCardBlock didSelectCardBlock;

@property (nonatomic, assign, readonly) BOOL hasRegisterdCards;
@property (nonatomic, assign, readonly) BOOL canAddCards;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong, readonly) OMNBankCard *selectedCard;

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock;
- (void)updateCardSelection;

@end
