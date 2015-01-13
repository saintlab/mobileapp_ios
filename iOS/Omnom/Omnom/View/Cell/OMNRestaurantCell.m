//
//  OMNRestaurantCell.m
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantCell.h"
#import "OMNRestaurantDetailsView.h"
#import "UIView+omn_autolayout.h"
#import "UIImage+omn_helper.h"
#import <BlocksKit.h>

@implementation OMNRestaurantCell {
  
  UIButton *_restaurantIcon;
  OMNRestaurantDetailsView *_restaurantDetailsView;
  NSString *_restaurantLogoObserverIdentifier;
  
}

- (void)dealloc {
  
  [self removeRestaurantLogoObserver];
  
}

- (void)removeRestaurantLogoObserver {
  
  if (_restaurantLogoObserverIdentifier) {
    [_restaurant.decoration bk_removeObserversWithIdentifier:_restaurantLogoObserverIdentifier];
  }
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self setup];
    
  }
  
  return self;
  
}

- (void)awakeFromNib {
  
  [self setup];
  
}

- (void)setup {
  
  _restaurantIcon = [UIButton omn_autolayoutView];
  _restaurantIcon.userInteractionEnabled = NO;
  _restaurantIcon.clipsToBounds = YES;
  _restaurantIcon.contentMode = UIViewContentModeScaleAspectFill;
  [self.contentView addSubview:_restaurantIcon];

  _restaurantDetailsView = [OMNRestaurantDetailsView omn_autolayoutView];
  [self.contentView addSubview:_restaurantDetailsView];
  
  NSDictionary *views =
  @{
    @"restaurantIcon" : _restaurantIcon,
    @"restaurantDetailsView" : _restaurantDetailsView,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_restaurantIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[restaurantDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[restaurantIcon]-(15)-[restaurantDetailsView]" options:kNilOptions metrics:metrics views:views]];
  
}

+ (instancetype)cellForTableView:(UITableView *)tableView {
  
  static NSString *reuseIdentifier = @"OMNRestaurantCell";
  OMNRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (nil == cell) {
    
    cell = [[OMNRestaurantCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
  }
  
  return cell;
  
}

+ (CGFloat)height {
  
  return 268.0f;
  
}

- (void)setRestaurant:(OMNRestaurant *)restaurant {

  [self removeRestaurantLogoObserver];
  _restaurant = restaurant;
  
  __weak UIButton *restaurantIcon = _restaurantIcon;
  _restaurantLogoObserverIdentifier = [_restaurant.decoration bk_addObserverForKeyPath:NSStringFromSelector(@selector(logo)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(id obj, NSDictionary *change) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
      UIImage *circleImage = [_restaurant.decoration.logo omn_circleImageWithDiametr:150.0f];
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [restaurantIcon setImage:circleImage forState:UIControlStateNormal];
        
      });
      
    });
    
  }];

  [_restaurant.decoration loadLogo:^(UIImage *image) {}];
  
  _restaurantDetailsView.restaurant = restaurant;
  [_restaurantIcon setBackgroundImage:[[UIImage imageNamed:@"circle_restaurant_page"] omn_tintWithColor:_restaurant.decoration.background_color] forState:UIControlStateNormal];
  
}

@end
