//
//  OMNWith.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWith.h"
#import "OMNOperationManager.h"

@implementation OMNWith

+ (void)createWishWithRestaurantID:(NSString *)restaurantID {
  
//  NSString *path = [NSString stringWithFormat:@"/restaurants/%@/wishes", restaurantID];
//  [[OMNOperationManager sharedManager] POST:path parameters:<#(id)#> constructingBodyWithBlock:<#^(id<AFMultipartFormData> formData)block#> success:<#^(AFHTTPRequestOperation *operation, id responseObject)success#> failure:<#^(AFHTTPRequestOperation *operation, NSError *error)failure#>]
 
//  {
//    "internal_table_id":"2",
//    "items":[
//             {"id":"15ecf053-feea-46ae-ac94-9a4087a724a8-in-saintlab-iiko",
//               "quantity":"1",
//               "modifiers": [
//                             {"id":"69c53de0-be11-4843-9628-fb1e01c9437e-in-saintlab-iiko",
//                               "quantity":"1"}
//                             ]
//             }]
//  }
  
  
}


@end

//curl -X POST  -H 'X-Authentication-Token: Ga7Rc1lBabcEIOoqd8MsSejzsroI01En' -H "Content-Type: application/json" -d '{ "internal_table_id":"2", "items":[{"id":"15ecf053-feea-46ae-ac94-9a4087a724a8-in-saintlab-iiko","quantity":"1", "modifiers": [{"id":"69c53de0-be11-4843-9628-fb1e01c9437e-in-saintlab-iiko","quantity":"1"}  ] }]}' http://omnom.laaaab.com/restaurants/saintlab-iiko/wishes