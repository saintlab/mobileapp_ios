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

@interface OMNScanTableQRCodeVC ()
<AVCaptureMetadataOutputObjectsDelegate,
TTTAttributedLabelDelegate>

@end

@implementation OMNScanTableQRCodeVC {
  
  AVCaptureSession *_captureSession;
  AVCaptureVideoPreviewLayer *_videoPreviewLayer;
  TTTAttributedLabel *_textLabel;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];

  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  NSMutableDictionary *attributes = [OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(25.0f) textColor:colorWithHexString(@"D0021B") textAlignment:NSTextAlignmentCenter];
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Наведите камеру\nна QR-код Omnom.\n" attributes:attributes];
  NSMutableAttributedString *actionText = [[NSMutableAttributedString alloc] initWithString:@"Что это такое?" attributes:attributes];
  [text appendAttributedString:actionText];
  _textLabel.text = text;
  
  attributes[(__bridge NSString *)kCTUnderlineStyleAttributeName] = @(YES);
  _textLabel.linkAttributes = [attributes copy];
  
  attributes[NSForegroundColorAttributeName] = [colorWithHexString(@"D0021B") colorWithAlphaComponent:0.5];
  _textLabel.activeLinkAttributes = [attributes copy];
  
  [_textLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[text.string rangeOfString:actionText.string]];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController.navigationBar omn_setTransparentBackground];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self initiateScan];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [self stopScanning];
  
}

- (void)omn_setup {
  
  _textLabel = [TTTAttributedLabel omn_autolayoutView];
  _textLabel.numberOfLines = 0;
  _textLabel.delegate = self;
  
  [self.view addSubview:_textLabel];
  
  NSDictionary *views =
  @{
    @"textLabel" : _textLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)initiateScan {
  
  NSString *mediaType = AVMediaTypeVideo;
  AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
  switch (authStatus) {
    case AVAuthorizationStatusAuthorized: {
      
      [self startScanning];
      
    } break;
    case AVAuthorizationStatusDenied: {
      
    } break;
    case AVAuthorizationStatusNotDetermined: {
      
      __weak typeof(self)weakSelf = self;
      [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if(granted) {
          NSLog(@"Granted access to %@", mediaType);
          dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf startScanning];
          });
          
        } else {
          NSLog(@"Not granted access to %@", mediaType);
        }
      }];
      
    } break;
    case AVAuthorizationStatusRestricted: {
      
    } break;
  }
  
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
  
  [self.delegate scanTableQRCodeVCDidCancel:self];
  
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
    
#warning didFindRestaurants
    [self processError:nil];
    
  }
  
}

- (void)processError:(OMNError *)error {
  
  OMNCircleRootVC *repeatVC = [[OMNCircleRootVC alloc] initWithParent:nil];
  repeatVC.faded = YES;
  repeatVC.text = error.localizedDescription;
  repeatVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
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
  
  NSLog(@"didOutputMetadataObjects>%@", metadataObjects);
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
  [self presentViewController:qrHelpAlertVC animated:YES completion:nil];
  
}

@end
