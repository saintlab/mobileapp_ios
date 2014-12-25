//
//  OMNRestaurantCell.m
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantCell.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIButton+omn_helper.h"

@implementation OMNRestaurantCell {
  
  UIImageView *_imageView;
  UIButton *_workdayButton;
  UILabel *_restaurantInfoLabelName;
  UILabel *_restaurantInfoLabelAddress;
  
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

  _restaurantInfoLabelName = [[UILabel alloc] init];
  _restaurantInfoLabelName.translatesAutoresizingMaskIntoConstraints = NO;
  _restaurantInfoLabelName.numberOfLines = 1;
  _restaurantInfoLabelName.textAlignment = NSTextAlignmentCenter;
  _restaurantInfoLabelName.font = FuturaOSFOmnomRegular(30.0f);
  _restaurantInfoLabelName.adjustsFontSizeToFitWidth = YES;
  _restaurantInfoLabelName.textColor = colorWithHexString(@"000000");
  [self.contentView addSubview:_restaurantInfoLabelName];
  
  _restaurantInfoLabelAddress = [[UILabel alloc] init];
  _restaurantInfoLabelAddress.translatesAutoresizingMaskIntoConstraints = NO;
  _restaurantInfoLabelAddress.numberOfLines = 1;
  _restaurantInfoLabelAddress.textAlignment = NSTextAlignmentCenter;
  _restaurantInfoLabelAddress.font = FuturaOSFOmnomRegular(18.0f);
  _restaurantInfoLabelAddress.adjustsFontSizeToFitWidth = YES;
  _restaurantInfoLabelAddress.textColor = colorWithHexString(@"000000");
  [self.contentView addSubview:_restaurantInfoLabelAddress];
  
  _workdayButton = [[UIButton alloc] init];
  _workdayButton.userInteractionEnabled = NO;
  _workdayButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_workdayButton omn_centerButtonAndImageWithSpacing:8.0f];
  _workdayButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_workdayButton setTitleColor:colorWithHexString(@"000000") forState:UIControlStateNormal];
  [_workdayButton setImage:[UIImage imageNamed:@"clock_icon"] forState:UIControlStateNormal];
  [self.contentView addSubview:_workdayButton];
  
  NSDictionary *views =
  @{
    @"imageView" : _imageView,
    @"restaurantInfoLabelName" : _restaurantInfoLabelName,
    @"restaurantInfoLabelAddress" : _restaurantInfoLabelAddress,
    @"workdayButton" : _workdayButton,
    };
  
  NSDictionary *metrics =
  @{
    @"imageHeight" : @(110),
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[restaurantInfoLabelName]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[restaurantInfoLabelAddress]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[workdayButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(imageHeight)]-(15)-[restaurantInfoLabelName]-[restaurantInfoLabelAddress]-(10)-[workdayButton]" options:kNilOptions metrics:metrics views:views]];
  
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
  
  _restaurantInfoLabelName.text = _restaurant.title;
  _restaurantInfoLabelAddress.text = _restaurant.address.street;
  
  [_workdayButton setTitle:_restaurant.schedules.work.fromToText forState:UIControlStateNormal];
  
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
