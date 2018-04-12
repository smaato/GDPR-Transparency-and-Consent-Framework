//
//  CMPConsentToolViewController.m
//
//  Copyright © 2018 Smaato. All rights reserved.
//

#import "CMPConsentToolViewController.h"
#import "CMPConsentToolAPI.h"
#import "CMPActivityIndicatorView.h"
#import <WebKit/WebKit.h>

NSString *const ConsentStringPrefix = @"consent://";

@interface CMPConsentToolViewController ()<WKNavigationDelegate>
@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, retain) CMPActivityIndicatorView *activityIndicatorView;
@end

@implementation CMPConsentToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
    [self initActivityIndicator];
}

-(void)initWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    _webView.navigationDelegate = self;
    _webView.scrollView.scrollEnabled = YES;
    [self.view addSubview:_webView];
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_webView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-0-[_webView]-0-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_webView)]];
    
    NSURLRequest *request = [self requestForConsentTool];
    if (request) {
        [_webView loadRequest:request];
    }
}

-(void)initActivityIndicator {
    _activityIndicatorView = [[CMPActivityIndicatorView alloc] initWithFrame:self.view.frame];
    _activityIndicatorView.userInteractionEnabled = NO;
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    NSURLRequest *request = navigationAction.request;
    
    if ([request.URL.absoluteString.lowercaseString hasPrefix:ConsentStringPrefix]) {
        NSString *newConsentString = [self consentStringFromRequest:request];
        if (newConsentString.length > 0) {
            [CMPConsentToolAPI setConsentString:newConsentString];
        }
        
        if (_onCloseCallback) {
            _onCloseCallback();
        }
    }

    decisionHandler(policy);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_activityIndicatorView stopAnimating];
}

-(NSURLRequest*)requestForConsentTool{
    if (_consentToolURL.absoluteString.length == 0) {
        return nil;
    }
    
    NSString *consentString = [CMPConsentToolAPI consentString];
    if (consentString.length > 0) {
        _consentToolURL = [self base64URLEncodedWithURL:_consentToolURL queryValue:consentString];
    }
    
    return [NSURLRequest requestWithURL:_consentToolURL];
}

-(NSString*)consentStringFromRequest:(NSURLRequest *)request {
    NSRange consentStringRange = [request.URL.absoluteString rangeOfString:ConsentStringPrefix options:NSBackwardsSearch];
    if (consentStringRange.location != NSNotFound) {
        NSString *responseString = [request.URL.absoluteString substringFromIndex:consentStringRange.location + consentStringRange.length];
        NSArray *response = [responseString componentsSeparatedByString:@"/"];
        NSString *consentString = response.firstObject;
        return consentString;
    }
    
    return nil;
}

-(NSURL *)base64URLEncodedWithURL:(NSURL *)URL queryValue:(NSString *)queryValue {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:NO];
    NSURLQueryItem * consentStringQueryItem = [[NSURLQueryItem alloc] initWithName:@"code64" value:queryValue];
    NSMutableArray * allQueryItems = [[NSMutableArray alloc] init];
    [allQueryItems addObject:consentStringQueryItem];
    [components setQueryItems:allQueryItems];
    
    return [components URL];
}

@end
