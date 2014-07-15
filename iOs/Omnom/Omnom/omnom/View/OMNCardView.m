//
//  OMNCardView.m
//  restaurants
//
//  Created by tea on 22.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCardView.h"
#import "NSString+jquery.h"

@interface OMNCardView ()
<UIWebViewDelegate>

@end

@implementation OMNCardView {
  BOOL _formSubmitted;
  BOOL _hasForm;
}

- (void)awakeFromNib {
  
  self.delegate = self;
  
}

//- (void)fillCardData:(OMNCard *)card {
//  
//  _formSubmitted = YES;
//  NSString *script = [card fillFormScript];
//  NSString *scriptResult = [self stringByEvaluatingJavaScriptFromString:script];
//  NSLog(@"%@",scriptResult);
//  
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  if (NO == _hasForm) {
    
    [webView stringByEvaluatingJavaScriptFromString:[NSString jqueryScript]];
    _hasForm = YES;
    
  }
  
  if (_formSubmitted) {

    
  }
  
  if ([self.webDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
    
    [self.webDelegate webViewDidFinishLoad:webView];
    
  }
  
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  if ([self.webDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
  {
    [self.webDelegate webView:webView didFailLoadWithError:error];
  }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if ([self.webDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
  {
    return [self.webDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
  }
  else
  {
    return YES;
  }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
  if ([self.webDelegate respondsToSelector:@selector(webViewDidStartLoad:)])
  {
    [self.webDelegate webViewDidStartLoad:webView];
  }  
}

@end
