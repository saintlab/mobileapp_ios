//
//  GLoginDataSource.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GLoginDataSource.h"
#import "GAuthManager.h"
#import "GSocialCell.h"
#import "GControllerMediator.h"

@implementation GLoginDataSource {
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [GAuthManager manager].numberOfSocialNetworks;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"cellIdentifier";
  
  GSocialCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (nil == cell) {
    cell = [[GSocialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  GSocialNetwork *socialNetwork = [[GAuthManager manager] socialNetworkAtIndex:indexPath.row];
  [cell setSocialNetwork:socialNetwork];

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  GSocialNetwork *socialNetwork = [[GAuthManager manager] socialNetworkAtIndex:indexPath.row];
  
  if (socialNetwork.authorized) {
    
//    [[GControllerMediator mediator] showUserDetails:socialNetwork vc:nil];
    
  }
  else {
    
    [socialNetwork authorize:^{
      
      [tableView reloadData];
      
    }];
    
  }
  
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  
  GSocialNetwork *socialNetwork = [[GAuthManager manager] socialNetworkAtIndex:indexPath.row];
  [socialNetwork logout];
  
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 1;
}


@end
