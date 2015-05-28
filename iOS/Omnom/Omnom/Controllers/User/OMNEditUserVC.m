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
#import "UIView+omn_autolayout.h"

@interface OMNEditUserVC ()
<OMNUserInfoViewDelegate,
UIScrollViewDelegate,
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
  
  _user = [[OMNAuthorization authorization].user copy];
  
  self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self omn_setup];
  
  _userInfoView.phoneTF.userInteractionEnabled = NO;
  
  [self.navigationItem setHidesBackButton:YES animated:NO];

  [_iconButton addTarget:self action:@selector(editPhotoTap) forControlEvents:UIControlEventTouchUpInside];
  
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

  if (self.editPhoto) {
    
    [self editPhotoTap];
    
  }
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)editPhotoTap {
  
  self.editPhoto = NO;
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:nil
                                            cancelButtonTitle:kOMN_CANCEL_BUTTON_TITLE
                                       destructiveButtonTitle:kOMN_USER_PHOTO_DELETE_BUTTON_TITLE
                                            otherButtonTitles:
                          kOMN_USER_PHOTO_SHOOT_BUTTON_TITLE,
                          kOMN_USER_PHOTO_CHOOSE_BUTTON_TITLE,
                          nil];
  [sheet promiseInView:self.view.window].then(^(NSNumber *index, UIActionSheet *actionSheet) {

    NSInteger buttonIndex = [index integerValue];
    if (actionSheet.destructiveButtonIndex == buttonIndex) {
      
      [self changeUserImage:nil];
      
    }
    else if (actionSheet.firstOtherButtonIndex == buttonIndex) {
      
      [self cameraTap];
      
    }
    else if ((actionSheet.firstOtherButtonIndex + 1) == buttonIndex) {
      
      [self libraryTap];
      
    }
    
  });
  
}

- (void)cameraTap {
  
  @weakify(self)
  [OMNCameraPermission requestPermission:^{
    
    @strongify(self)
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    
  } restricted:^{
    
    @strongify(self)
    [self showCameraPermissionHelp];
    
  }];
  
}

- (void)libraryTap {
  
  @weakify(self)
  [OMNCameraRollPermission requestPermission:^{
    
    @strongify(self)
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
  } restricted:^{
    
    @strongify(self)
    [self showCameraRollPermissionHelp];
    
  }];
  
}

- (void)changeUserImage:(UIImage *)image {
  
  _userImage = image;
  _user.image = image;
  if (!image) {
    _user.avatar = @"";
  }
  _user.imageDidChanged = YES;
  [self updateUserImage];

}

- (void)updateUserImage {
  
  [_iconButton updateWithImage:_user.image];
  
}

- (void)showCameraPermissionHelp {
  
  OMNCameraPermissionDescriptionVC *cameraPermissionDescriptionVC = [[OMNCameraPermissionDescriptionVC alloc] init];
  cameraPermissionDescriptionVC.text = kOMN_CAMERA_GET_PHOTO_PERMISSION_DESCRIPTION_TEXT;
  
  @weakify(self)
  cameraPermissionDescriptionVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.navigationController popToViewController:self animated:YES];
    
  };
  cameraPermissionDescriptionVC.delegate = self;
  [self.navigationController pushViewController:cameraPermissionDescriptionVC animated:YES];
  
}

- (void)showCameraRollPermissionHelp {
  
  OMNCameraRollPermissionDescriptionVC *cameraPermissionHelpVC = [[OMNCameraRollPermissionDescriptionVC alloc] init];
  @weakify(self)
  cameraPermissionHelpVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.navigationController popToViewController:self animated:YES];
    
  };
  [self.navigationController pushViewController:cameraPermissionHelpVC animated:YES];
  
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
  
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.sourceType = sourceType;
  imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
  imagePickerController.allowsEditing = YES;
  imagePickerController.delegate = self;

  if (sourceType == UIImagePickerControllerSourceTypeCamera &&
      [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
    
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
  }

  [self presentViewController:imagePickerController animated:YES completion:nil];
  
}

- (void)doneTap {
  
  [self showError:nil];
  OMNUser *editUser = [_userInfoView getUser];
  
  if (!editUser) {
    return;
  }
  editUser.avatar = _user.avatar;
  editUser.image = _userImage;
  editUser.imageDidChanged = _user.imageDidChanged;
  [self setLoading:YES];
  @weakify(self)
  [editUser updateUserInfoAndImage].then(^(OMNUser *user) {
    
    [[OMNAuthorization authorization] updateUserInfoWithUser:user];
    [self closeTap];
    
  }).catch(^(OMNError *error) {
    
    [self showError:error];
    
  }).finally(^{
    
    @strongify(self)
    [self setLoading:NO];
    
  });
  
}

- (void)showError:(OMNError *)error {
  
  [UIView transitionWithView:_errorLabel duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
  
    [_errorLabel setText:error.localizedDescription];
    
  } completion:nil];
  
}

- (void)setLoading:(BOOL)loading {
  
  if (loading) {
  
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_loadingItem];
    
  }
  else {
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kOMN_SAVE_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(doneTap)];
    
  }
  
}

- (void)closeTap {
  
  if (self.didFinishBlock) {
    self.didFinishBlock();
  }
  
}

#pragma mark - setup

- (void)omn_setup {
  
  _scroll = [UIScrollView omn_autolayoutView];
  _scroll.delegate = self;
  [self.view addSubview:_scroll];

  UIView *contentView = [UIView omn_autolayoutView];
  [_scroll addSubview:contentView];
  
  _errorLabel = [UILabel omn_autolayoutView];
  _errorLabel.font = FuturaLSFOmnomLERegular(18.0f);
  _errorLabel.textColor = [OMNStyler redColor];
  _errorLabel.numberOfLines = 0;
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  [contentView addSubview:_errorLabel];
  
  _iconButton = [[OMNUserIconView alloc] init];
  _iconButton.translatesAutoresizingMaskIntoConstraints = NO;
  [contentView addSubview:_iconButton];

  _userInfoView = [[OMNUserInfoView alloc] initWithUser:_user];
  _userInfoView.delegate = self;
  [contentView addSubview:_userInfoView];

  NSDictionary *views =
  @{
    @"scroll" : _scroll,
    @"userInfoView" : _userInfoView,
    @"iconButton" : _iconButton,
    @"contentView" : contentView,
    @"errorLabel" : _errorLabel,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" :@(OMNStyler.leftOffset),
    };
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][scroll]|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[errorLabel]-(10)-[iconButton]-(30)-[userInfoView]|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userInfoView]|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_scroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[errorLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];

}

#pragma mark - OMNUserInfoViewDelegate

- (void)userInfoView:(OMNUserInfoView *)userInfoView didbeginEditingTextField:(UITextField *)textField {
  
  CGRect textFieldFrame = [textField convertRect:textField.bounds toView:_scroll];
  [_scroll scrollRectToVisible:textFieldFrame animated:YES];
  CGPoint contentOffset = CGPointMake(0.0f, MAX(0.0f, textFieldFrame.origin.y - 20.0f));
  [UIView animateWithDuration:0.3 delay:0.1 options:kNilOptions animations:^{
    
    [_scroll setContentOffset:contentOffset];
    
  } completion:nil];
  
}

#pragma mark - keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
  
  NSDictionary* info = [notification userInfo];
  CGRect kbRect = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  @weakify(self)
  [self dismissViewControllerAnimated:YES completion:^{
  
    @strongify(self)
    [self changeUserImage:info[UIImagePickerControllerEditedImage]];
    
  }];
  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - OMNCameraPermissionDescriptionVCDelegate

- (void)cameraPermissionDescriptionVCDidReceivePermission:(OMNCameraPermissionDescriptionVC *)cameraPermissionDescriptionVC {

  @weakify(self)
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
  
    @strongify(self)
    [self cameraTap];
    
  }];

}

#pragma mark - OMNCameraRollPermissionDescriptionVCDelegate

- (void)cameraRollPermissionDescriptionVCDidReceivePermission:(OMNCameraRollPermissionDescriptionVC *)cameraRollPermissionDescriptionVC {

  @weakify(self)
  [self.navigationController omn_popToViewController:self animated:YES completion:^{
    
    @strongify(self)
    [self libraryTap];
    
  }];
  
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [self.view endEditing:YES];
}

@end
