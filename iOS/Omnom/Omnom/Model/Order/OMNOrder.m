//
//  OMNOrder.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

inline NSString *stringFromTipType(TipType tipType) {
  
  NSString *string = @"";
  switch (tipType) {
    case kTipTypeCustom: {
      string = @"bill_screen";
    } break;
    case kTipTypeCustomAmount: {
      string = @"manual_sum";
    } break;
    case kTipTypeCustomPercent: {
      string = @"manual_percentages";
    } break;
    default: {
      string = @"default";
    } break;
  }
  return string;
}

inline NSString *stringFromSplitType(SplitType splitType) {
  NSString *string = @"";
  switch (splitType) {
    case kSplitTypePercent: {
      string = @"by_percentages";
    } break;
    case kSplitTypeNumberOfGuests: {
      string = @"by_guests";
    } break;
    case kSplitTypeOrders: {
      string = @"by_positions";
    } break;
    default: {
      string = @"wasnt_used";
    } break;
  }
  return string;
}

NSInteger const kDefaultSelectedTipIndex = 1;
NSInteger const kCustomTipIndex = 3;

NSString * const OMNOrderDidChangeNotification = @"OMNOrderDidChangeNotification";
NSString * const OMNOrderDidCloseNotification = @"OMNOrderDidCloseNotification";
NSString * const OMNOrderKey = @"OMNOrderKey";

@implementation OMNOrder {
  
  id _data;
  NSString *_callBillOrderId;
  NSArray *_tipsThresholds;
  
}

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    _data = jsonData;
    self.id = [jsonData[@"id"] description];
    self.created = jsonData[@"created"];
    self.Description = jsonData[@"description"];
    self.notes = jsonData[@"notes"];
    self.status = jsonData[@"status"];
    self.openTime = jsonData[@"open_time"];
    self.modifiedTime = jsonData[@"modified_time"];
    self.restaurant_id = jsonData[@"restaurant_id"];
    self.table_id = jsonData[@"table_id"];
    
    if (jsonData[@"paid_amount"]) {
      self.paid = [[OMNOrderPaid alloc] initWithTotal:[jsonData[@"paid_amount"] longLongValue] tip:[jsonData[@"paid_tip"] longLongValue]];
    }
    
    NSArray *itemsData = jsonData[@"items"];
    NSMutableDictionary *orderItemIDs = [NSMutableDictionary dictionary];

    NSMutableDictionary *guestsInfo = [NSMutableDictionary dictionary];
    [itemsData enumerateObjectsUsingBlock:^(id itemData, NSUInteger idx, BOOL *stop) {
      
      OMNOrderItem *orderItem = [[OMNOrderItem alloc] initWithJsonData:itemData];
      NSString *orderItemGuestID = [NSString stringWithFormat:@"%@+%@", orderItem.id, orderItem.guest_id];
      orderItemIDs[orderItemGuestID] = @([orderItemIDs[orderItemGuestID] integerValue] + 1);
      orderItem.uid = [NSString stringWithFormat:@"%@+%@+%@", orderItem.id, orderItem.guest_id, orderItemIDs[orderItemGuestID]];
      
      NSMutableArray *guestItems = guestsInfo[orderItem.guest_id];
      if (nil == guestItems) {
        guestItems = [NSMutableArray array];
        guestsInfo[orderItem.guest_id] = guestItems;
      }
      
      [guestItems addObject:orderItem];
      
    }];

    NSArray *guestIDs = [guestsInfo.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *guests = [NSMutableArray arrayWithCapacity:guestIDs.count];
    [guestIDs enumerateObjectsUsingBlock:^(NSString *guestID, NSUInteger idx, BOOL *stop) {
      
      OMNGuest *guest = [[OMNGuest alloc] initWithID:guestID index:idx orderItems:guestsInfo[guestID]];
      [guests addObject:guest];
      
    }];
    
    _guests = [guests copy];
    
    NSDictionary *tipsData = jsonData[@"tips"];

    if (!tipsData) {
      
      NSString *path = [[NSBundle mainBundle] pathForResource:@"tips" ofType:@"json"];
      tipsData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
      
    }
    
    _tipsThresholds = tipsData[@"thresholds"];
    _percentTipsThreshold = [[_tipsThresholds lastObject] longLongValue];
    NSMutableArray *tips = [NSMutableArray arrayWithCapacity:4];

    for (id tipData in tipsData[@"values"]) {

      OMNTip *tip = [[OMNTip alloc] initWithJsonData:tipData thresholds:_tipsThresholds];
      [tips addObject:tip];
      
    }
    
    if (4 == tips.count) {
      
      _customTip = tips[3];
      _customTip.percent = 10.0;
      _customTip.custom = YES;
      
    }
    _tips = tips;
    
    if (self.totalAmount == 0 &&
        self.paid.net_amount == 0) {
      
      self.selectedTipIndex = -1;
      
    }
    else {
      
      self.selectedTipIndex = kDefaultSelectedTipIndex;
      
    }
    _selectedOrderItemsIDs = [NSMutableSet set];
    [self resetEnteredAmount];
    
  }
  return self;
}

- (void)updateWithOrder:(OMNOrder *)order {
  
  _guests = order.guests;
  
  if (order.paid) {
    
    self.paid = order.paid;
    
  }

  if (!_enteredAmountChanged) {
    
    _enteredAmount = MAX(0ll, self.expectedValue);
    
  }
  
}

- (void)setEnteredAmount:(long long)enteredAmount {
  
  _enteredAmount = enteredAmount;
  _enteredAmountChanged = YES;
  
}

- (long long)totalAmount {
  
  return [self totalForAllItems:YES];
  
}

- (long long)selectedItemsTotal {
  
  return [self totalForAllItems:NO];
  
}

- (long long)totalForAllItems:(BOOL)allItems {
  
  __block long long total = 0ll;
  [_guests enumerateObjectsUsingBlock:^(OMNGuest *guest, NSUInteger idx, BOOL *stop) {
    
    if (allItems) {
      total += [guest total];
    }
    else {
      total += [guest selectedItemsTotal];
    }
    
  }];
  
  return total;
  
}

- (BOOL)paymentValueIsTooHigh {
  
  return self.enteredAmount > 1.5 * self.expectedValue;
  
}

- (BOOL)hasSelectedItems {
  
  __block BOOL hasSelectedItems = NO;
  [_guests enumerateObjectsUsingBlock:^(OMNGuest *guest, NSUInteger idx, BOOL *stop) {

    if (guest.hasSelectedItems) {
      hasSelectedItems = YES;
      *stop = YES;
    }
    
  }];
  
  return hasSelectedItems;
  
}

- (long long)expectedValue {
  
  long long expectedValue = MAX(0ll, self.totalAmount - self.paid.net_amount);
  return expectedValue;
  
}

- (long long)enteredAmountWithTips {
  
  return (self.enteredAmount + self.tipAmount);
  
}

- (long long)tipAmount {
  
  OMNTip *selectedTip = self.selectedTip;
  
  long long selectedTipAmount = [selectedTip amountForValue:self.enteredAmount];
  long long roundedTipAmount = 100ll*round(selectedTipAmount*0.01);
  
  return roundedTipAmount;
  
}

- (void)setSelectedTipIndex:(NSInteger)selectedTipIndex {
  
  [self willChangeValueForKey:@"selectedTipIndex"];
  _selectedTipIndex = selectedTipIndex;
  [self.tips enumerateObjectsUsingBlock:^(OMNTip *tip, NSUInteger idx, BOOL *stop) {
    
    tip.selected = (selectedTipIndex == idx);
    
  }];
  
  switch (selectedTipIndex) {
    case kDefaultSelectedTipIndex: {
      
      self.tipType = kTipTypeDefault;
      
    } break;
    case kCustomTipIndex: {
      
      self.tipType = kTipTypeCustomPercent;
      
    } break;
    default: {
      
      self.tipType = kTipTypeCustom;
      
    } break;
  }
  [self didChangeValueForKey:@"selectedTipIndex"];

}

- (OMNTip *)selectedTip {
  
  if (kCustomTipIndex == self.selectedTipIndex) {
    
    return _customTip;
    
  }
  if (self.selectedTipIndex < kCustomTipIndex &&
      self.selectedTipIndex >= 0) {
    
    return self.tips[self.selectedTipIndex];
    
  }
  else {
    
    return nil;
    
  }
  
}

- (void)changeOrderItemSelection:(OMNOrderItem *)orderItem {
  
  orderItem.selected = !orderItem.selected;
  
  if (orderItem.selected) {
    
    [self.selectedOrderItemsIDs addObject:orderItem.uid];
    
  }
  else {
    
    [self.selectedOrderItemsIDs removeObject:orderItem.uid];
    
  }

}

- (void)selectionDidChange {
  
  [self willChangeValueForKey:@"hasSelectedItems"];
  [self didChangeValueForKey:@"hasSelectedItems"];
  
}

- (void)deselectAllItems {
  
  [self willChangeValueForKey:@"hasSelectedItems"];
  [_guests enumerateObjectsUsingBlock:^(OMNGuest *guest, NSUInteger idx, BOOL *stop) {
    
    [guest deselectAllItems];
    
  }];
  [self didChangeValueForKey:@"hasSelectedItems"];
  
}

- (void)resetEnteredAmount {
  
  _enteredAmountChanged = NO;
  _enteredAmount = self.expectedValue;
  
}

- (void)setCustomTipPercent:(double)percent {
  
  self.customTip.percent = percent;
  self.selectedTipIndex = kCustomTipIndex;
  
}

@end

@implementation NSObject (omn_orders)

- (NSArray *)omn_orders {
  
  if (![self isKindOfClass:[NSArray class]]) {
    return @[];
  }
  
  NSArray *ordersData = (NSArray *)self;
  NSMutableArray *orders = [NSMutableArray arrayWithCapacity:ordersData.count];
  [ordersData enumerateObjectsUsingBlock:^(id orderData, NSUInteger idx, BOOL *stop) {
    
    OMNOrder *order = [[OMNOrder alloc] initWithJsonData:orderData];
    [orders addObject:order];
    
  }];
  
  return [orders copy];
  
}

@end