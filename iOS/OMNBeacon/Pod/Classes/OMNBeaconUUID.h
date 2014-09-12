//
//  OMNBeaconUUID.h
//  Pods
//
//  Created by tea on 12.09.14.
//
//

#import <Foundation/Foundation.h>

@interface OMNBeaconUUID : NSObject
<NSCopying>

@property (nonatomic, strong) NSArray *activeUUIDs;
@property (nonatomic, strong) NSArray *deprecatedUUIDs;

- (instancetype)initWithJsonData:(id)jsonData;

- (NSArray *)aciveBeaconsRegionsWithIdentifier:(NSString *)identifier;
- (NSArray *)deprecatedBeaconsRegionsWithIdentifier:(NSString *)identifier;

@end
