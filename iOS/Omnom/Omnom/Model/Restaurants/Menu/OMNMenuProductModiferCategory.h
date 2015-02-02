//
//  OMNMenuProductModifer.h
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMNMenuProductModiferCategoryType) {
  
  kMenuProductModiferCategoryTypeNone = 0,
  kMenuProductModiferCategoryTypeCheckbox,
  kMenuProductModiferCategoryTypeSelect,
  kMenuProductModiferCategoryTypeMultiselect,
  
};

@interface OMNMenuProductModiferCategory : NSObject

@property (nonatomic, assign) OMNMenuProductModiferCategoryType type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong, readonly) NSDictionary *allModifers;

- (instancetype)initWithJsonData:(id)jsonData allModifers:(NSDictionary *)allModifers;

@end
