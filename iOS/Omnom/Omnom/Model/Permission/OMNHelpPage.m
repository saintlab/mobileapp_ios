//
//  OMNHelpPage.m
//  omnom
//
//  Created by tea on 25.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNHelpPage.h"

@implementation OMNHelpPage

+ (instancetype)pageWithText:(NSString *)text imageName:(NSString *)imageName {
  
  OMNHelpPage *helpPage = [[OMNHelpPage alloc] init];
  helpPage.text = text;
  helpPage.image = [UIImage imageNamed:imageName];
  return helpPage;
  
}

@end
