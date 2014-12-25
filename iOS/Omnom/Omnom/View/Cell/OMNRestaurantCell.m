//
//  OMNRestaurantCell.m
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantCell.h"
#import "OMNRestaurantDetailsView.h"

@implementation OMNRestaurantCell {
  
  UIImageView *_imageView;
  OMNRestaurantDetailsView *_restaurantDetailsView;
  
}

- (void)dealloc {
  
  @try {
    NSString *keyPath = NSStringFromSelector(@selector(background_image));
    [_restaurant.decoration removeObserver:self forKeyPath:keyPath];
  }
  @catch (NSException *exception) {}
  
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
  
  _imageView = [[UIImageView alloc] init];
  _imageView.clipsToBounds = YES;
  _imageView.opaque = YES;
  _imageView.backgroundColor = [UIColor whiteColor];
  _imageView.translatesAutoresizingMaskIntoConstraints = NO;
  _imageView.contentMode = UIViewContentModeScaleAspectFill;
  [self.contentView addSubview:_imageView];

  _restaurantDetailsView = [[OMNRestaurantDetailsView alloc] init];
  _restaurantDetailsView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_restaurantDetailsView];
  
  NSDictionary *views =
  @{
    @"imageView" : _imageView,
    @"restaurantDetailsView" : _restaurantDetailsView,
    };
  
  NSDictionary *metrics =
  @{
    @"imageHeight" : @(110),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[restaurantDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(imageHeight)]-(15)-[restaurantDetailsView]" options:kNilOptions metrics:metrics views:views]];
  
}

+ (instancetype)cellForTableView:(UITableView *)tableView {
  
  static NSString *reuseIdentifier = @"OMNRestaurantCell";
  OMNRestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (nil == cell) {
    
    cell = [[OMNRestaurantCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
  }
  
  return cell;
  
}

- (NSMutableParagraphStyle *)centerParagraphStyle {
  
  NSMutableParagraphStyle *attributeStyle = [[NSMutableParagraphStyle alloc] init];
  attributeStyle.alignment = NSTextAlignmentCenter;
  return attributeStyle;
  
}

- (void)setRestaurant:(OMNRestaurant *)restaurant {

  NSString *keyPath = NSStringFromSelector(@selector(background_image));
  [_restaurant.decoration removeObserver:self forKeyPath:keyPath];
  _restaurant = restaurant;
  [_restaurant.decoration addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) context:NULL];

  [_restaurant.decoration loadBackgroundBlurred:NO completion:^(UIImage *image) {
  }];
  
  _restaurantDetailsView.restaurant = restaurant;
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([object isEqual:_restaurant.decoration] &&
      [keyPath isEqualToString:NSStringFromSelector(@selector(background_image))]) {
    
    _imageView.image = _restaurant.decoration.background_image;
    
  } else {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
  }
}

@end
