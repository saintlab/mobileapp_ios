//
//  OMNError.m
//  omnom
//
//  Created by tea on 10.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNError.h"
#import <OMNMailRuAcquiring.h>

NSString * const OMNErrorDomain = @"OMNErrorDomain";
NSString * const OMNUserErrorDomain = @"OMNUserErrorDomain";

@implementation OMNError

+ (OMNError *)omnnomErrorFromError:(NSError *)error {
  
  OMNError *omnomError = nil;
  
  if ([error.domain isEqualToString:NSURLErrorDomain]) {
    
    switch (error.code) {
      case NSURLErrorTimedOut: {
        omnomError = [OMNError omnomErrorFromCode:kOMNErrorCodeTimedOut];
      } break;
      case NSURLErrorNotConnectedToInternet: {
        omnomError = [OMNError omnomErrorFromCode:kOMNErrorCodeNotConnectedToInternet];
      } break;
      default: {
        omnomError = [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun];
      } break;
    }
    
  }
  else if ([error.domain isEqualToString:OMNMailRuErrorDomain]) {
    
    if (kOMNMailRuErrorCodeCardAmount == error.code) {
      
      omnomError = [self omnomErrorFromCode:OMNErrorWrongAmount];
      
    }
    else if (kOMNMailRuErrorCodeDefault == error.code) {
      
      omnomError = [OMNError errorWithDomain:OMNErrorDomain code:error.code userInfo:error.userInfo];
      
    }
    else {

      omnomError = [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun];
      
    }
    
  }
  else {
    
    omnomError = [self omnomErrorFromCode:error.code];
    
  }
  
  return omnomError;
  
}

+ (OMNError *)omnomErrorFromCode:(NSInteger)code {
  
  NSString *description = @"";
  switch (code) {
    case kOMNErrorCodeNotConnectedToInternet: {
      description = NSLocalizedString(@"ERROR_MESSAGE_NO_INTERNET", @"Нет доступа в интернет");
    } break;
    case kOMNErrorCodeTimedOut: {
      description = NSLocalizedString(@"ERROR_MESSAGE_NO_CONNECTION", @"Помехи на линии.");
    } break;
    case OMNErrorOrderClosed: {
      description = NSLocalizedString(@"ERROR_MESSAGE_ORDER_CLOSED", @"Оплата по счёту невозможна - стол уже закрыт. Попробуйте запросить счёт заново или позовите официанта.");
    } break;
    case kOMNErrorCodeQrDecode: {
      description = NSLocalizedString(@"ERROR_MESSAGE_QR_DECODE", @"Неверный QR-код,\nнайдите Omnom");
    } break;
    case OMNErrorWrongAmount: {
      description = NSLocalizedString(@"ERROR_MESSAGE_PAYMENT_ERROR", @"Ваш банк отклонил платёж.\nПовторите попытку,\nдобавьте другую карту\nили оплатите наличными.");
    } break;
    case kOMNErrorCodeUnknoun:
    default: {
      description = NSLocalizedString(@"ERROR_MESSAGE_UNKNOWN_ERROR", @"Что-то пошло не так. Повторите попытку.");
    } break;
  }
  
  return [OMNError errorWithDomain:OMNErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : description}];
  
}

+ (OMNError *)userErrorFromCode:(OMNUserErrorCode)code {
  
  NSString *description = nil;
  
  switch (code) {
    case kOMNUserErrorCodeNoEmailAndPhone: {
      description = NSLocalizedString(@"Введите почту и телефон", nil);
    } break;
    default:
      break;
  }
  
  NSDictionary *userInfo = nil;
  if (description) {
    userInfo = @{NSLocalizedDescriptionKey : description};
  }
  
  return [OMNError errorWithDomain:OMNUserErrorDomain code:code userInfo:userInfo];
  
}

- (UIImage *)circleImage {
  
  UIImage *circleImage = nil;
  
  switch (self.code) {
    case kOMNErrorCodeTimedOut: {
      circleImage = [UIImage imageNamed:@"noise_icon_big"];
    } break;
    case kOMNErrorCodeNotConnectedToInternet: {
      circleImage = [UIImage imageNamed:@"unlinked_icon_big"];
    } break;
    case kOMNErrorCodeQrDecode: {
      circleImage = [UIImage imageNamed:@"error_icon_big"];
    } break;
    case kOMNErrorCodeUnknoun: {
      circleImage = [UIImage imageNamed:@"error_icon_big"];
    } break;
  }
  
  return circleImage;
  
}

@end

@implementation NSObject (omn_userError)

- (OMNError *)omn_userError {

  OMNError *error = [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun];

  if (NO == [self isKindOfClass:[NSDictionary class]]) {
    return error;
  }

  NSDictionary *dictionary = (NSDictionary *)self;
  NSString *message = dictionary[@"error"][@"message"];
  if (message) {

    error = [OMNError errorWithDomain:OMNUserErrorDomain
                                code:[dictionary[@"error"][@"code"] integerValue]
                            userInfo:@{NSLocalizedDescriptionKey : message}];

  }

  return error;

}

@end

@implementation NSError (omn_internetError)

- (OMNError *)omn_internetError {
  
  return [OMNError omnnomErrorFromError:self];
  
}

@end
