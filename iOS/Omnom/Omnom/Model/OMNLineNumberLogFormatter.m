//
//  OMNLineNumberLogFormatter.m
//  omnom
//
//  Created by tea on 12.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLineNumberLogFormatter.h"
#import <libkern/OSAtomic.h>

@implementation OMNLineNumberLogFormatter {
  
  int _atomicLoggerCount;
  NSDateFormatter *_threadUnsafeDateFormatter;
  
}

- (NSDateFormatter *)dateFormatter {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
  [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
  return dateFormatter;
  
}

- (NSString *)stringFromDate:(NSDate *)date {
  int32_t loggerCount = OSAtomicAdd32(0, &_atomicLoggerCount);
  
  if (loggerCount <= 1) {
    // Single-threaded mode.
    
    if (!_threadUnsafeDateFormatter) {
      
      _threadUnsafeDateFormatter = [self dateFormatter];
      
    }
    
    return [_threadUnsafeDateFormatter stringFromDate:date];
  }
  else {
    // Multi-threaded mode.
    // NSDateFormatter is NOT thread-safe.
    
    NSString *key = @"MyCustomFormatter_NSDateFormatter";
    
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
    
    if (!dateFormatter) {
      
      dateFormatter = [self dateFormatter];
      [threadDictionary setObject:dateFormatter forKey:key];
      
    }
    
    return [dateFormatter stringFromDate:date];
  }
  
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {

  return [NSString stringWithFormat:@"[%@] %@:%lu %@",[self stringFromDate:logMessage->_timestamp], logMessage.fileName, (unsigned long)logMessage->_line, logMessage->_message];
  
}

@end
