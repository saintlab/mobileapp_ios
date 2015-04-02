//
//  OMNRestaurantInfoItem.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfoItem.h"

@implementation OMNRestaurantInfoItem

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    self.value = jsonData[@"value"];
    self.title = jsonData[@"title"];
    self.type = typeFromString(jsonData[@"type"]);
  }
  return self;
}

RestaurantInfoItemType typeFromString(NSString *s) {
  
  static NSDictionary *types = nil;
  if (nil == types) {
    types =
    @{
      @"time" : @(kRestaurantInfoItemTypeTime),
      @"wifi" : @(kRestaurantInfoItemTypeWifi),
      @"address" : @(kRestaurantInfoItemTypeAddress),
      @"schedule" : @(kRestaurantInfoItemTypeSchedule),
      @"phone" : @(kRestaurantInfoItemTypePhone),
      @"lunch" : @(kRestaurantInfoItemTypeLunch),
      @"breakfast" : @(kRestaurantInfoItemTypeBreakfast),
      @"external_link" : @(kRestaurantInfoItemTypeExternaLink),
      };
  }
  if (0 == s.length) {
    return kRestaurantInfoItemTypeText;
  }
  
  
  return (RestaurantInfoItemType) [types[s] integerValue];
  
}

- (UIImage *)icon {
  UIImage *icon = nil;
  
  switch (self.type) {
    case kRestaurantInfoItemTypeAddress: {
      icon = [UIImage imageNamed:@"map_marker_icon"];
    } break;
    case kRestaurantInfoItemTypePhone: {
      icon = [UIImage imageNamed:@"phone_icon"];
    } break;
    case kRestaurantInfoItemTypeSchedule: {
      icon = [UIImage imageNamed:@"external_link_icon"];
    } break;
    case kRestaurantInfoItemTypeTime: {
      icon = [UIImage imageNamed:@"clock_icon"];
    } break;
    case kRestaurantInfoItemTypeWifi: {
      icon = [UIImage imageNamed:@"wifi_icon"];
    } break;
    case kRestaurantInfoItemTypeText: {
    } break;
    case kRestaurantInfoItemTypeBreakfast: {
      icon = [UIImage imageNamed:@"ic_breakfast"];
    } break;
    case kRestaurantInfoItemTypeExternaLink: {
      icon = [UIImage imageNamed:@"external_link_icon"];
    } break;
    case kRestaurantInfoItemTypeLunch: {
      icon = [UIImage imageNamed:@"ic_lunch"];
    } break;
  }
  return icon;
}

- (void)open {
  
  switch (self.type) {
    case kRestaurantInfoItemTypeAddress: {
      NSString *query = [[NSString stringWithFormat:@"http://maps.apple.com?q=%@", self.value] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:query]];
    } break;
    case kRestaurantInfoItemTypePhone: {
      
      NSString *cleanedString = [[self.value componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
      NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cleanedString];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
      
    } break;
    case kRestaurantInfoItemTypeWifi: {

      if (self.value.length) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:self.value];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_WIFI_COPY_TITILE", @"Пароль скопирован в буфер обмена") message:nil delegate:nil cancelButtonTitle:kOMN_OK_BUTTON_TITLE otherButtonTitles:nil] show];
      }
      
    } break;
    case kRestaurantInfoItemTypeSchedule:
    case kRestaurantInfoItemTypeExternaLink: {
      
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.value]];
      
    } break;
    default:
      break;
  }
  
}

@end
