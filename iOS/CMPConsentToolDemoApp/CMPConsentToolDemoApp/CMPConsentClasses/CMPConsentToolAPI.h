//
//  CMPConsentToolAPI.h
//
//  Copyright © 2018 Smaato Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPTypes.h"

/**
 Object that provides the interface for storing and retrieving GDPR-related information
 */
@interface CMPConsentToolAPI : NSObject

/**
 The consent string passed as a websafe base64-encoded string.
 */
@property (class, nonatomic, retain) NSString *consentString;

/**
 Enum that indicates    'CMPGDPRDisabled' – value 0, not subject to GDPR
                        'CMPGDPREnabled' – value 1, subject to GDPR,
                        'CMPGDPRUnknown'- value 2, unset.
 */
@property (class, nonatomic, assign) CMPGDPRStatus GDPRStatus;

/*!
 The argument must be passed as an NSArray of NSString to vendorIds
 Returns a dictionary String-Boolean meaning VendorId-VendorConsent
 @return The object containing vendor consents.
 */
+(NSDictionary *)vendorConsentsForVendorIds:(NSArray *)vendorIds;

/*!
 Returns a dictionary String-Boolean meaning PurposeId-PurposeConsent.
 @param purposeIds must be an NSArray of NSString to purposeIds for which is requesting consent for.
 @return The object containing purpose consents. If purposeIds array is null or empty, the method returns all configured purposes.
 */
+(NSDictionary *)purposeConsentsForPurposeIds:(NSArray *)purposeIds;

@end
