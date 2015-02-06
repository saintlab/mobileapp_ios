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

@property (nonatomic, assign) NSInteger weight_gr; //грамм
@property (nonatomic, assign) NSInteger cooking_time_minutes; //minutes
@property (nonatomic, assign) NSInteger volume_ml; //мл
@property (nonatomic, assign) NSInteger persons;
@property (nonatomic, assign) double protein_100;
@property (nonatomic, assign) double protein_total;
@property (nonatomic, assign) double fat_100;
@property (nonatomic, assign) double fat_total;
@property (nonatomic, assign) double carbohydrate_100;
@property (nonatomic, assign) double carbohydrate_total;
@property (nonatomic, assign) double energy_100;
@property (nonatomic, assign) double energy_total;
@property (nonatomic, copy) NSString *ingredients;

- (instancetype)initWithJsonData:(id)jsonData;
- (NSString *)displayText;
- (NSString *)displayFullText;
- (NSString *)display100Text;

@end
