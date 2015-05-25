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

@property (nonatomic) UIWebView *webView;
@property (nonatomic) JSContext *context;
@property (nonatomic) JSValue *io;

@end

@implementation OMNSocketIO

- (void)dealloc {
  
  _context.exceptionHandler = nil;
  _context = nil;
  _webView.delegate = nil;
  [_webView stopLoading];
  _webView = nil;
  
}

- (instancetype) init {
  self = [super init];
  if (self) {

    _webView = [[UIWebView alloc] init];
    [_webView loadHTMLString:@"<!DOCTYPE html><html lang=\"en\"><body></body></html>" baseURL:nil];
    _context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *script = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"socket.io.js" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    [_context evaluateScript:script];
    __weak typeof(self)weakSelf = self;
    _context[@"window"][@"onload"] = ^{
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf onReady];
    };
    
    [_context setExceptionHandler:^(JSContext *ctx, JSValue *val) {

      NSDictionary *info = @{@"context": ctx, @"value": val};
      NSError *error     = [NSError errorWithDomain:@"SocketIO" code:0 userInfo:info];
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf emit:@"error", error];
      
    }];
    
  }
  return self;
}

- (Socket *)of:(NSString *)url and:(NSDictionary *)options {
  JSValue *socket = [_io callWithArguments:@[url, options]];
  return [[Socket alloc] initWithSocket:socket];
}

- (void)onReady {
  self.io = self.context[@"io"];
  [self emit:@"ready"];
}

@end
