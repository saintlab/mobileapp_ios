//
//  OMNScanTableQRCodeVC.m
//  omnom
//
//  Created by tea on 04.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNScanTableQRCodeVC.h"
#import "OMNCircleRootVC.h"
#import "OMNRestaurantManager.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UINavigationBar+omn_custom.h"
#import <AVFoundation/AVFoundation.h>
#import <TTTAttributedLabel.h>
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "UIView+omn_autolayout.h"
#import "OMNQRHelpAlertVC.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "OMNToolbarButton.h"
#import "UIView+frame.h"
#import "OMNCameraPermission.h"
#import "OMNCameraPermissionDescriptionVC.h"
#import <BlocksKit+UIKit.h>

@interface OMNScanTableQRCodeVC ()
<AVCaptureMetadataOutputObjectsDelegate,
TTTAttributedLabelDelegate,
OMNCameraPermissionDescriptionVCDelegate>

@end

@implementation OMNScanTableQRCodeVC {
  
  AVCaptureSession *_captureSession;
  AVCaptureVideoPreviewLayer *_videoPreviewLayer;
  TTTAttributedLabel *_textLabel;
  UIImageView *_qrFrame;
  UIImageView *_qrIcon;
  UILabel *_titleLabel;
  UIButton *_flashButton;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createViews];
  [self configureViews];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [self.navigationController.navigationBar omn_setTransparentBackground];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  __weak typeof(self)weakSelf = self;
  [OMNCameraPermission requestPermission:^{
    
    [weakSelf startScanning];
    
  } restricted:^{
    
    [weakSelf showCameraPermissionHelp];
    
  }];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [self stopScanning];
  
}

- (void)showCameraPermissionHelp {
  
  OMNCameraPermissionDescriptionVC *cameraPermissionDescriptionVC = [[OMNCameraPermissionDescriptionVC alloc] init];
  cameraPermissionDescriptionVC.text = NSLocalizedString(@"CAMERA_SCAN_CARD_PERMISSION_DESCRIPTION_TEXT", @"Для сканирования карты\nнеобходимо разрешение\nна доступ к камере.");
  
  __weak typeof(self)weakSelf = self;
  cameraPermissionDescriptionVC.didCloseBlock = ^{
    
    [weakSelf closeTap];
    
  };
  cameraPermissionDescriptionVC.delegate = self;
  [self.navigationController pushViewController:cameraPermissionDescriptionVC animated:YES];
  
}

- (void)configureViews {
  
  self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
  
  UIColor *color = colorWithHexString(@"D0021B");
  
  NSString *actionText = NSLocalizedString(@"QR_DESCRIPTION_ACTION_TEXT", @"Что это такое?");
  NSString *text = [NSString stringWithFormat:NSLocalizedString(@"QR_DESCRIPTION_TEXT %@", @"Наведите камеру\nна QR-код Omnom.\n{QR_DESCRIPTION_ACTION_TEXT}"), actionText];
  
  NSMutableDictionary *attributes = [OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(25.0f) textColor:color textAlignment:NSTextAlignmentCenter];
  
  NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
  _textLabel.text = attributedString;
  
  attributes[NSUnderlineStyleAttributeName] = @(YES);
  _textLabel.linkAttributes = [attributes copy];
  
  attributes[NSForegroundColorAttributeName] = [color colorWithAlphaComponent:0.5];
  _textLabel.activeLinkAttributes = [attributes copy];
  
  [_textLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[text rangeOfString:actionText]];
  
  _qrFrame.image = [[UIImage imageNamed:@"qr-code-scanner-frame"] omn_tintWithColor:color];
  _qrIcon.image = [[UIImage imageNamed:@"qr-icon-small"] omn_tintWithColor:color];
  
  [_flashButton setImage:[UIImage imageNamed:@"ico-no-flash"] forState:UIControlStateNormal];
  [_flashButton setImage:[UIImage imageNamed:@"ico-flash"] forState:UIControlStateSelected];
  [_flashButton setImage:[UIImage imageNamed:@"ico-flash"] forState:UIControlStateSelected|UIControlStateHighlighted];
  
  AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if ([captureDevice hasTorch]) {
    
    [_flashButton bk_addEventHandler:^(UIButton *button) {
      
      button.selected = !button.selected;
      [captureDevice lockForConfiguration:nil];
      [captureDevice setTorchMode:(button.selected) ? (AVCaptureTorchModeOn) : (AVCaptureTorchModeOff)];
      [captureDevice unlockForConfiguration];
      
    } forControlEvents:UIControlEventTouchUpInside];
    
  }
  else {
    
    _flashButton.hidden = YES;
    
  }
  
  _titleLabel.font = FuturaOSFOmnomRegular(25.0f);
  _titleLabel.text = NSLocalizedString(@"QR_SCREEN_TITLE", @"Сканирование");
  _titleLabel.textColor = color;
  [_titleLabel sizeToFit];
  self.navigationItem.titleView = _titleLabel;
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:color target:self action:@selector(closeTap)];
  
}

- (void)createViews {
  
  UIView *contentView = [UIView omn_autolayoutView];
  contentView.userInteractionEnabled = YES;
  [self.view addSubview:contentView];
  
  _textLabel = [TTTAttributedLabel omn_autolayoutView];
  _textLabel.numberOfLines = 0;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.delegate = self;
  [contentView addSubview:_textLabel];
  
  _flashButton = [UIButton omn_autolayoutView];
  [contentView addSubview:_flashButton];
  
  _qrFrame = [UIImageView omn_autolayoutView];
  [contentView addSubview:_qrFrame];
  
  _qrIcon = [UIImageView omn_autolayoutView];
  [contentView addSubview:_qrIcon];
  
  _titleLabel = [[UILabel alloc] init];
  
  NSDictionary *views =
  @{
    @"textLabel" : _textLabel,
    @"qrFrame" : _qrFrame,
    @"qrIcon" : _qrIcon,
    @"flashButton" : _flashButton,
    @"contentView" : contentView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_qrFrame attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_flashButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [contentView addConstraint:[NSLayoutConstraint constraintWithItem:_qrIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[flashButton]-(18)-[qrFrame]-(80)-[qrIcon]-[textLabel]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)startScanning {
  
  NSError *error;
  
  // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
  // as the media type parameter.
  AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
  
  if (!input) {
    // If any error occurs, simply log the description of it and don't continue any more.
    DDLogError(@"startScanning>%@", [error localizedDescription]);
    return;
  }
  
  _captureSession = [[AVCaptureSession alloc] init];
  [_captureSession addInput:input];
  
  AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
  [_captureSession addOutput:captureMetadataOutput];
  
  [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
  
  _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
  [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  [_videoPreviewLayer setFrame:self.backgroundView.layer.bounds];
  [self.backgroundView.layer addSublayer:_videoPreviewLayer];

  [_captureSession startRunning];
  
}

- (void)stopScanning {
  
  // Stop video capture and make the capture session object nil.
  [_captureSession stopRunning];
  _captureSession = nil;
  
  // Remove the video preview layer from the viewPreview view's layer.
  [_videoPreviewLayer removeFromSuperlayer];
  _videoPreviewLayer.delegate = nil;
  _videoPreviewLayer = nil;
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (void)requestDemoMode {
  
  [self.delegate scanTableQRCodeVCRequestDemoMode:self];
  
}

- (void)decodeQR:(NSString *)qr {
  
  __weak typeof(self)weakSelf = self;
  [OMNRestaurantManager decodeQR:qr withCompletion:^(NSArray *restaurants) {
    
    [weakSelf didFindRestaurants:restaurants];
    
  } failureBlock:^(OMNError *error) {
    
    [weakSelf processError:error];
    
  }];
  
}

- (void)didFindRestaurants:(NSArray *)restaurants {
  
  if (1 == restaurants.count) {
    
    [self.delegate scanTableQRCodeVC:self didFindRestaurant:restaurants[0]];
    
  }
  else {
    
    [self processError:[OMNError omnomErrorFromCode:kOMNErrorCodeQrDecode]];
    
  }
  
}

- (void)processError:(OMNError *)error {
  
  OMNCircleRootVC *repeatVC = [[OMNCircleRootVC alloc] initWithParent:nil];
  repeatVC.backgroundImage = [UIImage imageNamed:@"wood_bg"];
  repeatVC.text = error.localizedDescription;
  repeatVC.circleIcon = error.circleImage;
  repeatVC.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"d0021b")];
  
  __weak typeof(self)weakSelf = self;
  repeatVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Проверить ещё") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf.navigationController popToViewController:weakSelf animated:YES];
      
    }]
    ];
  [self.navigationController pushViewController:repeatVC animated:YES];
  
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  
  DDLogDebug(@"didOutputMetadataObjects>%@", metadataObjects);
  AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
  
  if (metadataObject &&
      metadataObject.stringValue.length) {
    
    [self stopScanning];
    [self decodeQR:metadataObject.stringValue];
    
  }
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  OMNQRHelpAlertVC *qrHelpAlertVC = [[OMNQRHelpAlertVC alloc] init];
  __weak typeof(self)weakSelf = self;
  qrHelpAlertVC.didCloseBlock = ^{
    
    [weakSelf dismissViewControllerAnimated:YES completion:nil];
    
  };
  qrHelpAlertVC.didRequestDemoModeBlock = ^{
    
    [weakSelf dismissViewControllerAnimated:YES completion:^{
      
      [weakSelf requestDemoMode];
      
    }];
    
  };
  [self presentViewController:qrHelpAlertVC animated:YES completion:nil];
  
}

#pragma mark - OMNCameraPermissionDescriptionVCDelegate

- (void)cameraPermissionDescriptionVCDidReceivePermission:(OMNCameraPermissionDescriptionVC *)cameraPermissionDescriptionVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

@end