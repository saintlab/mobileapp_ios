//
//  OMNFeedItem.m
//  omnom
//
//  Created by tea on 20.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFeedItem.h"
#import "OMNImageManager.h"

@implementation OMNFeedItem {
  id _jsonData;
  BOOL _viewEventLogged;
}

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    self.title = jsonData[@"title"];
    self.price = jsonData[@"price"];
    self.imageURL = jsonData[@"image"];
    self.Description = jsonData[@"description"];
    
    self.image = [[OMNImageManager manager] cachedImageForURL:self.imageURL];
    
  }
  return self;
}


- (void)downloadImage {
  
  __weak typeof(self)weakSelf = self;
  [[OMNImageManager manager] downloadImageWithURL:self.imageURL completion:^(UIImage *image) {
    
    weakSelf.image = image;
    
  }];
  
}

@end
