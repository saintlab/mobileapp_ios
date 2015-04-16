//
//  OMNUser+omn_mailRu.m
//  omnom
//
//  Created by tea on 16.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNUser+omn_mailRu.h"

@implementation OMNUser (omn_mailRu)

- (OMNMailRuUser *)omn_mailRuUser {
  return [OMNMailRuUser userWithLogin:self.id phone:self.phone];
}

@end
