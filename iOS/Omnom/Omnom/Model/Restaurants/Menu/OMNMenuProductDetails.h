//
//  OMNMenuProductDetails.h
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

//https://github.com/saintlab/boss/issues/87

#import <Foundation/Foundation.h>

@interface OMNMenuProductDetails : NSObject

@property (nonatomic, copy) NSString *weight_gr; //грамм
@property (nonatomic, assign) NSInteger cooking_time_minutes; //minutes
@property (nonatomic, copy) NSString *volume_ml; //мл
@property (nonatomic, assign) NSInteger persons;
@property (nonatomic, copy) NSString *protein_100;
@property (nonatomic, copy) NSString *protein_total;
@property (nonatomic, copy) NSString *fat_100;
@property (nonatomic, copy) NSString *fat_total;
@property (nonatomic, copy) NSString *carbohydrate_100;
@property (nonatomic, copy) NSString *carbohydrate_total;
@property (nonatomic, copy) NSString *energy_100;
@property (nonatomic, copy) NSString *energy_total;
@property (nonatomic, copy) NSString *ingredients;

- (instancetype)initWithJsonData:(id)jsonData;
- (NSString *)displayText;
- (NSString *)displayFullText;
- (NSString *)display100Text;

@end
