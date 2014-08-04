//
//  SocketIO.m
//  SocketIO
//
//  Created by Hao-kang Den on 6/7/14.
//
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "OMNSocketIO.h"

@interface OMNSocketIO()
<UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;
@property (nonatomic) JSContext *context;
@property (nonatomic) JSValue *io;

@end

@implementation OMNSocketIO

- (instancetype) init {
  self = [super init];
  if (self) {

    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [_webView loadHTMLString:@"<!DOCTYPE html><html lang=\"en\"><body></body></html>" baseURL:nil];

    
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [_context evaluateScript:[[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"socket.io.js" ofType:nil] encoding:NSUTF8StringEncoding error:nil]];
    __weak typeof(self)weakSelf = self;
    _context[@"window"][@"onload"] = ^{
      [weakSelf onReady];
    };
    
    [_context setExceptionHandler:^(JSContext *ctx, JSValue *val) {
      NSLog(@"error %@", val);
      NSDictionary *info = @{@"context": ctx, @"value": val};
      NSError *error     = [NSError errorWithDomain:@"SocketIO" code:0 userInfo:info];
      [weakSelf emit:@"error", error];
    }];
  }
  return self;
}

- (Socket *) of:(NSString *)url and:(NSDictionary *)options {
  JSValue *socket = [_io callWithArguments:@[url, options]];
  return [[Socket alloc] initWithSocket:socket];
}

- (void)onReady {
  self.io = self.context[@"io"];
  [self emit:@"ready"];
}

@end
