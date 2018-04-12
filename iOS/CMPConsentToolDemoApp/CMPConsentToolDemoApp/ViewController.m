//
//  ViewController.m
//  CMPConsentToolDemoApp
//
//  Copyright © 2018 Smaato. All rights reserved.
//

#import "ViewController.h"
#import "CMPConsentToolAPI.h"
#import "CMPConsentToolViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *GDPRConsentStringLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showGDPRConsentTool:(id)sender {

    // Create and configure the CMPConsentToolViewController that will be presented
    CMPConsentToolViewController *consentToolVC = [[CMPConsentToolViewController alloc] init];
    consentToolVC.consentToolURL = [NSURL URLWithString: @"https://demofiles.smaato.com/cmp/index.html"];
    
    // Provide a callback to be executed once the consent string is received or when the view controller is closed
    consentToolVC.onCloseCallback = ^{
        self.GDPRConsentStringLabel.text = CMPConsentToolAPI.consentString;
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"GDPR Consent Tool VC dismissed");
            NSLog(@"consentString: %@",CMPConsentToolAPI.consentString);
            NSLog(@"getVendorConsent: \n%@",[CMPConsentToolAPI vendorConsentsForVendorIds:nil]);
            NSLog(@"getPurposeConsent: \n%@",[CMPConsentToolAPI purposeConsentsForPurposeIds:nil]);
        }];
    };
    
    // Present the view controller
    [self presentViewController:consentToolVC animated:YES completion:^{
        NSLog(@"GDPR Consent Tool VC presented...");
    }];
    
}

@end
