//
//  OMNViewControllerTest.m
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNViewControllerTest.h"

@interface OMNViewControllerTest ()

@end

@implementation OMNViewControllerTest

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
  UIImageView *iv = [[UIImageView alloc] initWithFrame:self.view.bounds];
  
  UIGraphicsBeginImageContext(self.view.frame.size);
  [[UIImage imageNamed:@"background_blur"] drawAtPoint:CGPointZero];
  iv.image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  [self.view addSubview:iv];
  
  self.view.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255. green:(arc4random()%255)/255. blue:(arc4random()%255)/255. alpha:1];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSLog(@"viewWillAppear>%@", self);
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  NSLog(@"viewWillDisappear>%@", self);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
