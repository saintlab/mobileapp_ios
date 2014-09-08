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

@interface OMNScanQRCodeVC ()
<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation OMNScanQRCodeVC {
  AVCaptureSession *_captureSession;
  AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = NSLocalizedString(@"QR", nil);
  self.view.backgroundColor = [UIColor whiteColor];
  if (TARGET_IPHONE_SIMULATOR ||
      [OMNConstants useStubBeacon]) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stub scan", nil) style:UIBarButtonItemStylePlain target:self action:@selector(stubScan)];
  }
  
  UIImageView *scanFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr-code-scanner-frame"]];
  scanFrame.center = self.view.center;
  scanFrame.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
  [self.view addSubview:scanFrame];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
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

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self stopScanning];
}

- (void)stubScan {
  
  [self didScanCode:@"123"];
  
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

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
