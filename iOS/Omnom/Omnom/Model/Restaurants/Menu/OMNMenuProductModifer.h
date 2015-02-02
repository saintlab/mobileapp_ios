//
//  OMNMenuProductModifer.h
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMNMenuProductModiferType) {
  
  kMenuProductModiferTypeNone = 0,
  kMenuProductModiferTypeCheckbox,
  kMenuProductModiferTypeSelect,
  kMenuProductModiferTypeMultiselect,
  
};

@interface OMNMenuProductModifer : NSObject

@property (nonatomic, assign) OMNMenuProductModiferType type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithJsonData:(id)jsonData;

@end
