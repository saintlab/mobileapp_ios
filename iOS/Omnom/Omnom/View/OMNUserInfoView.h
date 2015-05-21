//
//  OMNUserInfoView.h
//  omnom
//
//  Created by tea on 04.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNUser.h"
#import "OMNErrorTextField.h"

@protocol OMNUserInfoViewDelegate;

@interface OMNUserInfoView : UIView

@property (nonatomic, weak) id<OMNUserInfoViewDelegate> delegate;
@property (nonatomic, strong, readonly) OMNErrorTextField *nameTF;
@property (nonatomic, strong, readonly) OMNErrorTextField *phoneTF;
@property (nonatomic, strong, readonly) OMNErrorTextField *emailTF;
@property (nonatomic, strong, readonly) OMNErrorTextField *birthdayTF;

- (instancetype)initWithUser:(OMNUser *)user;

- (OMNUser *)getUser;
- (void)beginEditing;

@end

@protocol OMNUserInfoViewDelegate <NSObject>

- (void)userInfoView:(OMNUserInfoView *)userInfoView didbeginEditingTextField:(UITextField *)textField;

@end
