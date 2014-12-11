//
//  OMNEditUserVC.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEditUserVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNUserInfoView.h"
#import <OMNStyler.h>
#import "OMNAuthorization.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "OMNCameraPermission.h"
#import "OMNCameraRollPermission.h"
#import "UINavigationController+omn_replace.h"
#import "OMNCameraPermissionDescriptionVC.h"
#import "OMNCameraRollPermissionDescriptionVC.h"
#import "OMNUser+network.h"
#import "OMNUserIconView.h"
#import "OMNWebVC.h"

@interface OMNEditUserVC ()
<OMNUserInfoViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
OMNCameraPermissionDescriptionVCDelegate,
OMNCameraRollPermissionDescriptionVCDelegate>

@end

@implementation OMNEditUserVC {
  
  UIScrollView *_scroll;
  OMNUserInfoView *_userInfoView;
  OMNUserIconView *_iconButton;
  UIImage *_userImage;
  OMNUser *_user;

}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  _user = [[OMNAuthorization authorisation].user copy];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self omn_setup];
  
  _userInfoView.phoneTF.userInteractionEnabled = NO;
  
  [self.navigationItem setHidesBackButton:YES animated:NO];

  [_iconButton addTarget:self action:@selector(iconTap) forControlEvents:UIControlEventTouchUpInside];
  
  [self setLoading:NO];
  
}

- (void)viewDidLayoutSubviews {

  [super viewDidLayoutSubviews];
  [self updateUserImage];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)changePhoneTap:(__weak UIButton *)b {
  
  b.enabled = NO;
  __weak typeof(self)weakSelf = self;
  [_user recoverWithCompletion:^(NSURL *url) {
    
    [weakSelf showUrl:url];
    b.enabled = YES;

  } failure:^(NSError *error) {
    
    b.enabled = YES;

  }];
  
}

- (void)showUrl:(NSURL *)url {
  
  OMNWebVC *webVC = [[OMNWebVC alloc] init];
  webVC.url = url;
  [self.navigationController pushViewController:webVC animated:YES];
  
}

- (void)iconTap {
  
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"USER_PHOTO_CANCEL_BUTTON_TITLE", @"Отмена")
                                       destructiveButtonTitle:NSLocalizedString(@"USER_PHOTO_DELETE_BUTTON_TITLE", @"Удалить текущий снимок")
                                            otherButtonTitles:
                          NSLocalizedString(@"USER_PHOTO_SHOOT_BUTTON_TITLE", @"Сделать снимок"),
                          NSLocalizedString(@"USER_PHOTO_CHOOSE_BUTTON_TITLE", @"Выбрать из библиотеки"),
                          nil];
  sheet.delegate = self;
  [sheet showInView:self.view.window];
  
}

- (void)cameraTap {
  
  __weak typeof(self)weakSelf = self;
  [OMNCameraPermission requestPermission:^{
    
    [weakSelf showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    
  } restricted:^{
    
    [weakSelf showCameraPermissionHelp];
    
  }];
  
}

- (void)libraryTap {
  
  __weak typeof(self)weakSelf = self;
  [OMNCameraRollPermission requestPermission:^{
    
    [weakSelf showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
  } restricted:^{
    
    [weakSelf showCameraRollPermissionHelp];
    
  }];
  
}

- (void)setUserImage:(UIImage *)image {
  
  _userImage = image;
  _user.image = image;
  [self updateUserImage];

}

- (void)updateUserImage {
  
  [_iconButton updateWithImage:_user.image];
  
}

- (void)showCameraPermissionHelp {
  
  OMNCameraPermissionDescriptionVC *cameraPermissionDescriptionVC = [[OMNCameraPermissionDescriptionVC alloc] init];
  cameraPermissionDescriptionVC.text = NSLocalizedString(@"CAMERA_GET_PHOTO_PERMISSION_DESCRIPTION_TEXT", @"Для получения изображения\nнеобходимо разрешение\nна доступ к камере.");
  __weak typeof(self)weakSelf = self;
  cameraPermissionDescriptionVC.didCloseBlock = ^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  };
  cameraPermissionDescriptionVC.delegate = self;
  [self.navigationController pushViewController:cameraPermissionDescriptionVC animated:YES];
  
}

- (void)showCameraRollPermissionHelp {
  
  OMNCameraRollPermissionDescriptionVC *cameraPermissionHelpVC = [[OMNCameraRollPermissionDescriptionVC alloc] init];
  __weak typeof(self)weakSelf = self;
  cameraPermissionHelpVC.didCloseBlock = ^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  };
  [self.navigationController pushViewController:cameraPermissionHelpVC animated:YES];
  
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
  
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.sourceType = sourceType;
  imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
  imagePickerController.allowsEditing = YES;
  imagePickerController.delegate = self;
  [self presentViewController:imagePickerController animated:YES completion:nil];
  
}

- (void)doneTap {
  
  OMNUser *editUser = [_userInfoView getUser];
  
  if (nil == editUser) {
    return;
  }

  editUser.image = _userImage;

  [self setLoading:YES];
  __weak typeof(self)weakSelf = self;
  [_user updateUserInfoWithUserAndImage:editUser withCompletion:^{
    
    [weakSelf setLoading:NO];
    NSLog(@"updateUserInfoWithUserAndImage");
    
  } failure:^(NSError *error) {
    
    NSLog(@"updateUserInfoWithUserAndImage>%@", error);
    [weakSelf setLoading:NO];
    
  }];
  
}

- (void)setLoading:(BOOL)loading {
  
  if (loading) {
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
    
  }
  else {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"EDIT_USER_DONE_BUTTON_TITLE", @"Готово") style:UIBarButtonItemStylePlain target:self action:@selector(doneTap)];
    
  }
  
}

- (void)closeTap {
  
  [self.delegate editUserVCDidFinish:self];
  
}

#pragma mark - setup

- (void)omn_setup {
  
  _scroll = [[UIScrollView alloc] init];
  _scroll.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scroll];

  UIView *contentView = [[UIView alloc] init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scroll addSubview:contentView];
  
  _iconButton = [[OMNUserIconView alloc] init];
  _iconButton.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_iconButton];

  _userInfoView = [[OMNUserInfoView alloc] initWithUser:_user];
  _userInfoView.delegate = self;
  [contentView addSubview:_userInfoView];

  UIButton *userEditButton = [[UIButton alloc] init];
  userEditButton.translatesAutoresizingMaskIntoConstraints = NO;
  userEditButton.titleLabel.font = FuturaOSFOmnomRegular(20.0f);
  [userEditButton setTitleColor:colorWithHexString(@"157EFB") forState:UIControlStateNormal];
  [userEditButton setTitleColor:[colorWithHexString(@"157EFB") colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
  [userEditButton setTitle:NSLocalizedString(@"EDIT_USER_CHANGE_PHONE_BUTTON_TITLE", @"Сменить") forState:UIControlStateNormal];
  [userEditButton addTarget:self action:@selector(changePhoneTap:) forControlEvents:UIControlEventTouchUpInside];
  [_userInfoView addSubview:userEditButton];

  
  NSDictionary *views =
  @{
    @"scroll" : _scroll,
    @"userInfoView" : _userInfoView,
    @"iconButton" : _iconButton,
    @"contentView" : contentView,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"userEditButton" : userEditButton,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[iconButton]-(30)-[userInfoView]|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userInfoView]|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:metrics views:views]];

  [_userInfoView addConstraint:[NSLayoutConstraint constraintWithItem:userEditButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_userInfoView.phoneTF.textField attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [_userInfoView addConstraint:[NSLayoutConstraint constraintWithItem:userEditButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_userInfoView.phoneTF.textField attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  
}

#pragma mark - OMNUserInfoViewDelegate

- (void)userInfoView:(OMNUserInfoView *)userInfoView didbeginEditingTextField:(UITextField *)textField {
  
  CGRect textFieldFrame = [textField convertRect:textField.bounds toView:_scroll];
  [_scroll scrollRectToVisible:textFieldFrame animated:YES];
  CGPoint contentOffset = CGPointMake(0.0f, MAX(0.0f, textFieldFrame.origin.y - 20.0f));
  [UIView animateWithDuration:0.3 delay:0.1 options:0 animations:^{
    
    [_scroll setContentOffset:contentOffset];
    
  } completion:nil];
  
}

#pragma mark - keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
  
  NSDictionary* info = [notification userInfo];
  CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  kbRect = [self.view convertRect:kbRect fromView:nil];
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
  CGPoint offset = _scroll.contentOffset;
  _scroll.contentInset = contentInsets;
  _scroll.scrollIndicatorInsets = contentInsets;
  _scroll.contentOffset = offset;
  
}

- (void)keyboardWillHide:(NSNotification *)notification {
  
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  _scroll.contentInset = contentInsets;
  _scroll.scrollIndicatorInsets = contentInsets;
  
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
  
  if (actionSheet.cancelButtonIndex == buttonIndex) {
    return;
  }
  
  if (actionSheet.destructiveButtonIndex == buttonIndex) {
  
    [self setUserImage:nil];
  
  }
  else if (actionSheet.firstOtherButtonIndex == buttonIndex) {
    
    [self cameraTap];
    
  }
  else if ((actionSheet.firstOtherButtonIndex + 1) == buttonIndex) {
    
    [self libraryTap];
    
  }
  
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  __weak typeof(self)weakSelf = self;
  [self dismissViewControllerAnimated:YES completion:^{
  
    [weakSelf setUserImage:info[UIImagePickerControllerEditedImage]];
    
  }];
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - OMNCameraPermissionDescriptionVCDelegate

- (void)cameraPermissionDescriptionVCDidReceivePermission:(OMNCameraPermissionDescriptionVC *)cameraPermissionDescriptionVC {

  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
  
    [weakSelf cameraTap];
    
  }];

}

#pragma mark - OMNCameraRollPermissionDescriptionVCDelegate

- (void)cameraRollPermissionDescriptionVCDidReceivePermission:(OMNCameraRollPermissionDescriptionVC *)cameraRollPermissionDescriptionVC {

  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    [weakSelf libraryTap];
    
  }];
  
}
@end
