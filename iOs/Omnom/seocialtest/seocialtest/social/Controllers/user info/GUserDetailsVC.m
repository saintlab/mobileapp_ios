//
//  GUserDetailsVC.m
//  seocialtest
//
//  Created by tea on 12.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GUserDetailsVC.h"
#import "GSocialNetwork.h"

@interface GUserDetailsVC () {
  GSocialNetwork *_socialNetwork;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GUserDetailsVC

- (instancetype)initWithSocialNetwork:(GSocialNetwork *)socialNetwork {
  self = [super initWithNibName:@"GUserDetailsVC" bundle:nil];
  if (self) {
    _socialNetwork = socialNetwork;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  __weak typeof(self)weakSelf = self;
  [_socialNetwork getProfileImage:^(UIImage *image) {
    
    weakSelf.imageView.image = image;
    
  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  _imageView.image = nil;
}

@end
