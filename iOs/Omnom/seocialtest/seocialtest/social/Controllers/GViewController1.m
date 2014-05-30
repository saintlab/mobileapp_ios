//
//  GViewController1.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GViewController1.h"
#import "GAuthManager.h"

@interface GViewController1 ()

@end

@implementation GViewController1

- (id)init {
  self = [super initWithNibName:@"GViewController1" bundle:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (IBAction)tap:(id)sender {
  
//  [[GAuthManager manager] auth:kSocialMediaTypeTwitter];
  
  return;
  [self.delegate viewController1DidFinish:self];
}
- (IBAction)getUserInfoTap:(id)sender {
  
//  [[GAuthManager manager] getUserInfo:^(NSString *name) {
//    
//  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
