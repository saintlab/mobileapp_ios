//
//  GAuthManager.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthManager.h"
#import "OMNSocialNetwork.h"
#import "OMNGPlusNetwork.h"
#import "OMNVKNetwork.h"
#import "OMNOKNetwork.h"
#import "OMNFBNetwork.h"
#import "OMNTwitterNetwork.h"

@implementation OMNAuthManager {
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

- (OMNSocialNetwork *)socialNetworkAtIndex:(NSInteger)index {
  
  OMNSocialNetwork *socialNetwork = _socialNetworks[@(index)];
  
  if (nil == socialNetwork) {

    switch ((SocialMediaType)index) {
      case kSocialMediaTypeGPlus: {
        socialNetwork = [GGPlusNetwork network];
      } break;
      case kSocialMediaTypeVK: {
        socialNetwork = [OMNVKNetwork network];
      } break;
      case kSocialMediaTypeOK: {
        socialNetwork = [OMNOKNetwork network];
      } break;
      case kSocialMediaTypeFB: {
        socialNetwork = [OMNFBNetwork network];
      } break;
      case kSocialMediaTypeTwitter: {
        socialNetwork = [OMNTwitterNetwork network];
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
