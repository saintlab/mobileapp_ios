//
//  GMenuItem.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNMenuProductDetails.h"
#import "OMNMenuModifer.h"
#import "OMNMenuProductModiferCategory.h"

extern NSString * const OMNMenuProductDidChangeNotification;

@interface OMNMenuProduct : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long long price;
@property (nonatomic, assign) double quantity;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, strong) NSArray *modifiers;
@property (nonatomic, strong) NSArray *recommendations;
@property (nonatomic, strong) OMNMenuProductDetails *details;
@property (nonatomic, strong, readonly) NSDictionary *allModifers;
@property (nonatomic, strong, readonly) NSMutableSet *selectedModifers;

@property (nonatomic, assign, readonly) long long total;

- (instancetype)initWithJsonData:(id)data allModifers:(NSDictionary *)allModifers;
- (BOOL)hasRecommendations;
- (BOOL)showRecommendations;
- (BOOL)hasPhoto;
- (BOOL)preordered;
- (void)loadImage;
- (void)resetSelection;

- (NSString *)preorderedText;

- (NSAttributedString *)shortDescription;
- (NSAttributedString *)nameAttributedString;

@end
