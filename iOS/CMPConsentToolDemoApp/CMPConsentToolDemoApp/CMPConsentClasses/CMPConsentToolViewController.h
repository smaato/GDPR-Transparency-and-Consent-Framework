//
//  CMPConsentToolViewController.h
//
//  Copyright © 2018 Smaato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPConsentToolAPI.h"

@interface CMPConsentToolViewController : UIViewController

/**
 NSURL that is used to create and load the request into the WKWebView – it is the request for the consent webpage. This property is mandatory.
 */
@property (nonatomic, strong) NSURL *consentToolURL;
@property (nonatomic, copy) void (^onCloseCallback)(void);
@end
