//
//  OMNScanQRCodeVC.m
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNScanQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNCameraPermission.h"

@interface OMNScanQRCodeVC ()
<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation OMNScanQRCodeVC {
  
  AVCaptureSession *_captureSession;
  AVCaptureVideoPreviewLayer *_videoPreviewLayer;
  UILabel *_label;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = nil;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setup];
  
  _label.textColor = colorWithHexString(@"D0021B");
  _label.font = FuturaOSFOmnomRegular(25.0f);
  _label.numberOfLines = 0;
  _label.textAlignment = NSTextAlignmentCenter;

  [self setText:NSLocalizedString(@"SCAN_QR_HINT_TEXT", @"Наведитесь на QR-код\nOmnom.") error:NO];
  
}

- (void)setup {
  
  UIImageView *scanFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr-code-scanner-frame"]];
  scanFrame.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:scanFrame];
  
  _label = [[UILabel alloc] init];
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_label];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:scanFrame attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:scanFrame attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scanFrame attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:scanFrame attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scanFrame attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:scanFrame attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationItem setHidesBackButton:YES animated:animated];
  
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
  
  
  
}

- (void)setText:(NSString *)text error:(BOOL)error {
  
  [UIView transitionWithView:_label duration:0.3 options:0 animations:^{
  
    _label.text = text;
    
  } completion:nil];
  
}

- (void)didScanCode:(NSString *)code {
  
  [self.delegate scanQRCodeVC:self didScanCode:code];
  
}

- (void)startScanning {
  
  NSError *error;
  
  // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
  // as the media type parameter.
  AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
  
  if (!input) {
    // If any error occurs, simply log the description of it and don't continue any more.
    NSLog(@"startScanning>%@", [error localizedDescription]);
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

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  
  NSLog(@"didOutputMetadataObjects>%@", metadataObjects);
  AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];

  if (metadataObject) {

    [self didScanCode:metadataObject.stringValue];
    
  }
  
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

@end
