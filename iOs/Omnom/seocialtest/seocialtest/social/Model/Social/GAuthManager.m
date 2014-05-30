//
//  GAuthManager.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GAuthManager.h"
#import "GSocialNetwork.h"
#import "GGPlusNetwork.h"
#import "GVKNetwork.h"
#import "GOKNetwork.h"
#import "GFBNetwork.h"
#import "GTwitterNetwork.h"

@implementation GAuthManager {
  NSMutableDictionary *_socialNetworks;
}

+ (instancetype)manager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _socialNetworks = [NSMutableDictionary dictionaryWithCapacity:self.numberOfSocialNetworks];
  }
  return self;
}

- (void)auth:(SocialMediaType)socialMediaType {
  
//  [[self socialNetworkAtIndex:socialMediaType] authorize];
  
}

- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  BOOL handle = NO;
  
  for (SocialMediaType socialMediaType = kSocialMediaTypeFirst; socialMediaType < kSocialMediaTypeMax; socialMediaType++) {
    
    handle = [[self socialNetworkAtIndex:socialMediaType] handleURL:url sourceApplication:sourceApplication annotation:annotation];
  
    NSLog(@"handleURL>%@(%d)", url, handle);
    
    if (handle) {
      break;
    }
    
  }
  
  return handle;
}

- (NSInteger)numberOfSocialNetworks {
  return kSocialMediaTypeMax;
}

- (GSocialNetwork *)socialNetworkAtIndex:(NSInteger)index {
  
  GSocialNetwork *socialNetwork = _socialNetworks[@(index)];
  
  if (nil == socialNetwork) {

    switch ((SocialMediaType)index) {
      case kSocialMediaTypeGPlus: {
        socialNetwork = [GGPlusNetwork network];
      } break;
      case kSocialMediaTypeVK: {
        socialNetwork = [GVKNetwork network];
      } break;
      case kSocialMediaTypeOK: {
        socialNetwork = [GOKNetwork network];
      } break;
      case kSocialMediaTypeFB: {
        socialNetwork = [GFBNetwork network];
      } break;
      case kSocialMediaTypeTwitter: {
        socialNetwork = [GTwitterNetwork network];
      } break;
      case kSocialMediaTypeMax: {
      } break;
    }

    if (socialNetwork) {
      _socialNetworks[@(index)] = socialNetwork;
    }

    
  }
  
  return socialNetwork;
  
}


@end
