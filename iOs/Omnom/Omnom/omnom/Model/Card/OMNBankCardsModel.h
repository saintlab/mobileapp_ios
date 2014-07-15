//
//  OMNBankCardsModel.h
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCard.h"

typedef void(^OMNSelectCardBlock)(OMNBankCard *bankCard);

@interface OMNBankCardsModel : NSObject
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, copy) OMNSelectCardBlock didSelectCardBlock;

- (void)addBankCard:(OMNBankCard *)bankCard;

@end
