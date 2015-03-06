//
//  OMNOrder.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"
#import <BlocksKit.h>

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
    self.paid = [[OMNOrderPaid alloc] initWithJsonData:jsonData];
    
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
    NSArray *tipsValueData = tipsData[@"values"];
    NSArray *tips = [tipsValueData bk_map:^id(id tipData) {
      
      return [[OMNTip alloc] initWithJsonData:tipData thresholds:_tipsThresholds];
      
    }];
    
    if (4 == tips.count) {
      
      _customTip = tips[3];
      _customTip.percent = 10.0;
      _customTip.custom = YES;
      
    }
    _tips = tips;

    [self resetEnteredAmount];
    [self resetTip];
    
    _changedItemsIDs = [NSMutableSet set];
    
  }
  return self;
}

- (void)resetTip {
  
  if (self.totalAmount == 0 &&
      self.paid.net_amount == 0) {
    
    self.selectedTipIndex = -1;
    
  }
  else {
    
    self.selectedTipIndex = kDefaultSelectedTipIndex;
    
  }
  
}

- (void)setEnteredAmount:(long long)enteredAmount {
  
  _enteredAmount = enteredAmount;
  _enteredAmountChanged = YES;
  
}

- (long long)totalAmount {
  
  __block long long total = 0ll;
  [_guests bk_each:^(OMNGuest *guest) {
    
    total += [guest total];
    
  }];
  return total;
  
}

- (long long)selectedItemsTotal {
  
  __block long long selectedItemsTotal = 0ll;
  [_guests bk_each:^(OMNGuest *guest) {
    
    selectedItemsTotal += [guest selectedItemsTotal];
    
  }];
  return selectedItemsTotal;
  
}

- (BOOL)paymentValueIsTooHigh {
  
  return self.enteredAmount > 1.5 * self.expectedValue;
  
}

- (BOOL)hasSelectedItems {
  
  BOOL hasSelectedItems = [_guests bk_any:^BOOL(OMNGuest *guest) {
    
    return guest.hasSelectedItems;
    
  }];
  
  return hasSelectedItems;
  
}

- (BOOL)hasProducts {
  
  BOOL hasProducts = [_guests bk_any:^BOOL(OMNGuest *guest) {
    
    return guest.hasProducts;
    
  }];
  
  return hasProducts;
  
}

- (BOOL)paymentCompleted {
  
  return (self.hasProducts &&
          0ll == self.expectedValue);
  
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

- (NSMutableSet *)selectedItemsIDs {
  
  return [NSMutableSet set];
  
}

- (void)changeOrderItemSelection:(OMNOrderItem *)orderItem {
  
  orderItem.selected = !orderItem.selected;
  if (!orderItem.uid) {
    return;
  }
  
  if ([self.changedItemsIDs containsObject:orderItem.uid]) {
    
    [self.changedItemsIDs removeObject:orderItem.uid];
    
  }
  else {
    
    [self.changedItemsIDs addObject:orderItem.uid];
    
  }

}

- (void)selectionDidFinish {
  
  [self willChangeValueForKey:@"hasSelectedItems"];
  [self.changedItemsIDs removeAllObjects];
  [self didChangeValueForKey:@"hasSelectedItems"];
  
}

- (void)deselectAllItems {
  
  [self willChangeValueForKey:@"hasSelectedItems"];
  [self.changedItemsIDs removeAllObjects];
  [_guests enumerateObjectsUsingBlock:^(OMNGuest *guest, NSUInteger idx, BOOL *stop) {
    
    [guest deselectAllItems];
    
  }];
  self.splitType = kSplitTypeNone;
  [self didChangeValueForKey:@"hasSelectedItems"];
  
}

- (void)resetSelection {
  
  NSSet *changedOrderItemsIDs = [self.changedItemsIDs copy];
  [self.guests enumerateObjectsUsingBlock:^(OMNGuest *guest, NSUInteger idx, BOOL *stop) {
    
    [guest.items enumerateObjectsUsingBlock:^(OMNOrderItem *orderItem, NSUInteger idx1, BOOL *stop1) {
      
      if ([changedOrderItemsIDs containsObject:orderItem.uid]) {
        
        orderItem.selected = !orderItem.selected;
        
      }
      
    }];
    
  }];
  
  [self.changedItemsIDs removeAllObjects];
  
}

- (void)resetEnteredAmount {
  
  _enteredAmountChanged = NO;
  _enteredAmount = self.expectedValue;
  
}

- (void)setCustomTipPercent:(double)percent {
  
  self.customTip.percent = percent;
  self.selectedTipIndex = kCustomTipIndex;
  
}

- (NSDictionary *)debug_info {
  
  NSMutableArray *items = [NSMutableArray array];
  __block long long total = 0ll;
  __block long long selectedTotal = 0ll;
  [self.guests enumerateObjectsUsingBlock:^(OMNGuest *guest, NSUInteger idx, BOOL *stop) {
    
    [guest.items enumerateObjectsUsingBlock:^(OMNOrderItem *item, NSUInteger idx, BOOL *stop) {
      
      total += item.price_total;
      selectedTotal += (item.selected) ? (item.price_total) : (0ll);
      [items addObject:
       @{
         @"id" : item.id,
         @"price_total" : @(item.price_total),
         @"selected" : @(item.selected)
         }];
      
    }];
    
  }];
  
  NSDictionary *order_info =
  @{
    @"total" : @(total),
    @"selected_items_total" : @(selectedTotal),
    @"items" : items,
    @"paid_net_amount" : @(self.paid.net_amount),
    @"paid_tip_amount" : @(self.paid.tip_amount),
    };
  return order_info;
  
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