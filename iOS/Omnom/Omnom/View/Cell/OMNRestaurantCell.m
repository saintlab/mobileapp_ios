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

const CGFloat kRestaurantCellIconSize = 150.0f;

@implementation OMNRestaurantCell {
  
  OMNRestaurantView *_restaurantView;
  
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
  
  _restaurantView = [OMNRestaurantView omn_autolayoutView];
  [self.contentView addSubview:_restaurantView];
  
  NSDictionary *views =
  @{
    @"restaurantView" : _restaurantView,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[restaurantView]|" options:kNilOptions metrics:nil views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[restaurantView]" options:kNilOptions metrics:nil views:views]];
  
}

- (void)setItem:(OMNRestaurantCellItem *)item {

  _item = item;
  _restaurantView.restaurant = item.restaurant;
  
}

@end

@implementation OMNRestaurantView {
  
  UIButton *_restaurantIcon;
  OMNRestaurantDetailsView *_restaurantDetailsView;
  NSString *_restaurantLogoObserverIdentifier;
  
}

- (void)dealloc {
  [self removeRestaurantLogoObserver];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self setup];
    
  }
  return self;
}

- (void)setup {
  
  _restaurantIcon = [UIButton omn_autolayoutView];
  _restaurantIcon.userInteractionEnabled = NO;
  _restaurantIcon.clipsToBounds = YES;
  _restaurantIcon.contentMode = UIViewContentModeScaleAspectFill;
  [self addSubview:_restaurantIcon];
  
  _restaurantDetailsView = [OMNRestaurantDetailsView omn_autolayoutView];
  [self addSubview:_restaurantDetailsView];
  
  NSDictionary *views =
  @{
    @"restaurantIcon" : _restaurantIcon,
    @"restaurantDetailsView" : _restaurantDetailsView,
    };
  
  NSDictionary *metrics =
  @{
    @"kRestaurantCellIconSize" : @(kRestaurantCellIconSize)
    };
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_restaurantIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[restaurantDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[restaurantIcon(kRestaurantCellIconSize)]-(15)-[restaurantDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)removeRestaurantLogoObserver {
  
  if (_restaurantLogoObserverIdentifier) {
    [_restaurant.decoration bk_removeObserversWithIdentifier:_restaurantLogoObserverIdentifier];
  }
  
}

- (void)setRestaurant:(OMNRestaurant *)restaurant {
  
  [self removeRestaurantLogoObserver];
  _restaurant = restaurant;
  
  __weak UIButton *restaurantIcon = _restaurantIcon;
  [_restaurantIcon setBackgroundImage:[[UIImage imageNamed:@"circle_restaurant_page"] omn_tintWithColor:_restaurant.decoration.background_color] forState:UIControlStateNormal];

  _restaurantLogoObserverIdentifier = [_restaurant.decoration bk_addObserverForKeyPath:NSStringFromSelector(@selector(logo)) options:(NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
      UIImage *circleImage = [_restaurant.decoration.logo omn_circleImageWithDiametr:kRestaurantCellIconSize];
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView transitionWithView:restaurantIcon duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
          [restaurantIcon setImage:circleImage forState:UIControlStateNormal];
          
        } completion:nil];
        
      });
      
    });
    
  }];
  
  if (self.superview) {
    [_restaurant.decoration loadLogo:^(UIImage *image) {}];
  }  
  _restaurantDetailsView.restaurant = restaurant;
  
}

@end
