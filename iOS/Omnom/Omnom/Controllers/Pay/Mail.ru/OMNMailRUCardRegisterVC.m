//
//  OMNMailRUCardRegisterVC.m
//  omnom
//
//  Created by tea on 20.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMailRUCardRegisterVC.h"

@interface OMNMailRUCardRegisterVC ()

@end

@implementation OMNMailRUCardRegisterVC

- (instancetype)init {
  
  self = [super initWithParent:nil];
  if (self) {
    self.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
    self.estimateAnimationDuration = 20.0f;
  }
  return self;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
