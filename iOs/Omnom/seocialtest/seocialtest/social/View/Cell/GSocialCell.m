//
//  GSocialCell.m
//  seocialtest
//
//  Created by tea on 08.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GSocialCell.h"

static void * GSocialCellContext = &GSocialCellContext;

@implementation GSocialCell {
  GSocialNetwork *_socialNetwork;
}

- (void)dealloc {
  
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.indentationWidth = 100.0f;
  }
  return self;
}

- (void)awakeFromNib
{
  // Initialization code
}

- (void)setSocialNetwork:(GSocialNetwork *)socialNetwork {
  
  [_socialNetwork removeObserver:self forKeyPath:NSStringFromSelector(@selector(authorized))];
  
  _socialNetwork = socialNetwork;
  
  [_socialNetwork addObserver:self forKeyPath:NSStringFromSelector(@selector(authorized)) options:NSKeyValueObservingOptionNew context:GSocialCellContext];
  
  [self updateState];
  
}

- (void)updateState {
  
  self.textLabel.text = _socialNetwork.name;
  
  if (_socialNetwork.authorized) {
    
    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
  }
  else {
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
  }
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (context == GSocialCellContext) {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(authorized))]) {
      [self updateState];
    }
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
