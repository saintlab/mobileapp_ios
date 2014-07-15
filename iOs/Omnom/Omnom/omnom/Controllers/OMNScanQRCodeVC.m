//
//  OMNScanQRCodeVC.m
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNScanQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>

@interface OMNScanQRCodeVC ()
<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation OMNScanQRCodeVC {
  AVCaptureSession *_captureSession;
  AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = NSLocalizedString(@"QRCode reader", nil);
  
#if TARGET_IPHONE_SIMULATOR
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Stub scan", nil) style:UIBarButtonItemStylePlain target:self action:@selector(stubScan)];
#endif
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self startScanning];
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
  
  // Get an instance of the AVCaptureDeviceInput class using the previous device object.
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
  
  if (!input) {
    // If any error occurs, simply log the description of it and don't continue any more.
    NSLog(@"%@", [error localizedDescription]);
    return;
  }
  
  // Initialize the captureSession object.
  _captureSession = [[AVCaptureSession alloc] init];
  // Set the input device on the capture session.
  [_captureSession addInput:input];
  
  
  // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
  AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
  [_captureSession addOutput:captureMetadataOutput];
  
  [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
  
  // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
  _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
  [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  [_videoPreviewLayer setFrame:self.view.layer.bounds];
  [self.view.layer addSublayer:_videoPreviewLayer];

  // Start video capture.
  [_captureSession startRunning];
  
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  
  NSLog(@"%@", metadataObjects);
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
