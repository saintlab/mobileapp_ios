//
//  OMNBankCardsModel.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNBankCard;
@class OMNBankCardInfo;
@class OMNBankCardMediator;

typedef UIViewController *(^OMNSelectCardBlock)(OMNBankCard *bankCard);

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
@property (nonatomic, strong) OMNBankCardMediator *bankCardMediator;

- (instancetype)init __attribute__((unavailable("init not available")));
- (instancetype)initWithRootVC:(UIViewController *)vc;
- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock;
- (void)updateCardSelection;

- (void)payForOrder:(OMNOrder *)order cardInfo:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *debugInfo))failureBlock;

@end
