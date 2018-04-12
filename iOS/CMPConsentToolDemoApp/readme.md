# Implementation Guide for the CMPConsentTool

## Getting Started

### Integration of CMPConsentToolViewController

Preparations: Add all the provided iOS wrapper classes to the project.

```

CMPConsentToolViewController *consentToolVC = [[CMPConsentToolViewController alloc] init];
consentToolVC.consentToolURL = [NSURL URLWithString: @"https://demofiles.smaato.com/cmp/index.html"];
consentToolVC.onCloseCallback = ^{[self dismissViewControllerAnimated:YES completion:nil];};
[self presentViewController:consentToolVC animated:YES completion:nil];

```

1. Create the CMPConsentToolViewController object, which presents the consent tool.
2. Provide the url for the consent webpage.
3. Configure optional onCloseCallback, which will be triggered once a new consent string was stored within the consent webpage. (This is a good place for dismissing the CMPConsentToolViewController again.)
4. Present the CMPConsentToolViewController to the user.

(Note: GDPR Consent String will be stored automatically by the CMPConsentToolViewController.)

### Accessing the CMPConsentToolAPI

The CMPConsentToolAPI class provides access to all GDPR-related information.

Property for the consent string.
The consent string as a websafe base64-encoded string.
```

CMPConsentToolAPI.consentString

```

Property for the IsSubjectToGDPR-flag.
GDPRStatus: Enum that indicates:
* CMPGDPRDisabled - value 0, not subject to GDPR
* CMPGDPREnabled - value 1, subject to GDPR
* CMPGDPRUnknown - value 2, unset
```

CMPConsentToolAPI.GDPRStatus

```

Retrieve consent information for given vendorIds.
Returns a dictionary NSString-NSNumber meaning VendorId-VendorConsent.
```

+(NSDictionary *)vendorConsentsForVendorIds:(NSArray *)vendorIds;
Example: [CMPConsentToolAPI vendorConsentsForVendorIds:arrayWithVendorIdsAsNSStrings];

```

Retrieve consent information for given purposeIds.
Returns a dictionary NSString-NSNumber meaning PurposeId-PurposeConsent.
```

+(NSDictionary *)purposeConsentsForPurposeIds:(NSArray *)purposeIds;
Example: [CMPConsentToolAPI purposeConsentsForPurposeIds:arrayWithPurposeIdsAsNSStrings];

```