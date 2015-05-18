//
//  OMNVisitor+omn_network.h
//  omnom
//
//  Created by tea on 18.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNVisitor.h"
#import "OMNWish.h"

@interface OMNVisitor (omn_network)

/**
 @code
 *  curl -X POST  -H 'X-Authentication-Token: Ga7Rc1lBabcEIOoqd8MsSejzsroI01En' -H "Content-Type: application/json" -d '{ "internal_table_id":"2", "items":[{"id":"15ecf053-feea-46ae-ac94-9a4087a724a8-in-saintlab-iiko","quantity":"1", "modifiers": [{"id":"69c53de0-be11-4843-9628-fb1e01c9437e-in-saintlab-iiko","quantity":"1"}  ] }]}' http://omnom.laaaab.com/restaurants/saintlab-iiko/wishes
 @endcode
 *  @see https://github.com/saintlab/backend/issues/1402
 *  @param wishItems     list of {"id":"", "quantity":"1", "modifiers":[{"id":"", "quantity":"1"}]} objects
 *  @returns [OMNError errorWithDomain:OMNErrorDomain code:kOMNErrorForbittenWishProducts userInfo:@{OMNForbiddenWishProductsKey : forbiddenWishProducts}] in case of forbidden products in list
 */
- (PMKPromise *)createWish:(NSArray *)wishItems;

- (void)getMenuWithCompletion:(OMNMenuBlock)completion;

@end
