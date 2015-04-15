//
//  OMNVersionUserInfoItem.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVersionUserInfoItem.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"

@implementation OMNVersionUserInfoItem

- (CGFloat)heightForTableView:(UITableView *)tableView {
  return 100.0f;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {

  NSString *reuseIdentifier = NSStringFromClass(self.class);
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (nil == cell) {
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImageView *logoView = [UIImageView omn_autolayoutView];
    logoView.image = [UIImage imageNamed:@"fork_n_knife_icon"];
    [cell.contentView addSubview:logoView];

    UILabel *label = [UILabel omn_autolayoutView];
    label.text = [NSString stringWithFormat:@"version %@ build %@", CURRENT_VERSION, CURRENT_BUILD];
    label.font = FuturaOSFOmnomRegular(15.0f);
    label.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    
    NSDictionary *views =
    @{
      @"logoView" : logoView,
      @"label" : label,
      };

    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[logoView]-(15)-[label]" options:kNilOptions metrics:nil views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|" options:kNilOptions metrics:nil views:views]];
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
  }
  
  return cell;
  
}

@end
