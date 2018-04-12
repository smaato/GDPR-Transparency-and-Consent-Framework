//
//  CMPConsentToolAPI.m
//
//  Copyright © 2018 Smaato Inc. All rights reserved.
//

#import "CMPConsentToolAPI.h"
#import "CMPConsentToolUtil.h"

NSString *const IABConsent_SubjectToGDPRKey = @"IABConsent_SubjectToGDPR";
NSString *const IABConsent_ConsentStringKey = @"IABConsent_ConsentString";

const NSInteger purposeNumBits = 24;

@implementation CMPConsentToolAPI

+(NSString *)consentString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:IABConsent_ConsentStringKey];
}

+(void)setConsentString:(NSString *)consentString{
    [[NSUserDefaults standardUserDefaults] setObject:consentString forKey:IABConsent_ConsentStringKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(CMPGDPRStatus)GDPRStatus {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:IABConsent_SubjectToGDPRKey] integerValue];
}

+(void)setGDPRStatus:(CMPGDPRStatus)GDPRStatus {
    [[NSUserDefaults standardUserDefaults] setInteger:GDPRStatus forKey:IABConsent_SubjectToGDPRKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDictionary *)vendorConsentsForVendorIds:(NSArray *)vendorIds {
    unsigned char* buffer = [CMPConsentToolAPI binaryConsent];
    
    if (!buffer) {
        return nil;
    }
    
    NSMutableDictionary* vendorConsentDict = [NSMutableDictionary new];
    
    char encodingType = buffer[142];
    if (encodingType == '0') {
        // BitFieldSection
        NSInteger maxVendorId = [CMPConsentToolUtil BinaryToDecimal:buffer fromIndex:126 toIndex:141];
        for (int i = 1 ; i <= (int)maxVendorId ; i++) {
            char vendorConsent = buffer[142 + i];
            if (vendorConsent == '0') {
                [vendorConsentDict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%d",i]];
            } else {
                [vendorConsentDict setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }
    } else {
        // RangeSection
        //TODO:: RangeSection needs to be implemented
    }
    free(buffer);
    
    if (vendorIds && vendorIds.count > 0) {
            return [vendorConsentDict dictionaryWithValuesForKeys:vendorIds];
    }
    return vendorConsentDict;
}

+(NSDictionary *)purposeConsentsForPurposeIds:(NSArray *)purposeIds {
    unsigned char* buffer = [CMPConsentToolAPI binaryConsent];
    
    if (!buffer) {
        return nil;
    }
    
    NSMutableDictionary *purposeConsentsDictionary = [NSMutableDictionary new];
    
    for (int i = 1; i <= purposeNumBits; i++) {
        NSNumber *consent = [CMPConsentToolAPI isPurposeAllowedForBinary:buffer atBitPosition:i-1];
        if (consent) {
            [purposeConsentsDictionary setValue:consent forKey:[NSString stringWithFormat:@"%d", i]];
        } else {
            free(buffer);
            return purposeConsentsDictionary;
        }
    }
    
    free(buffer);
    
    if (purposeIds && purposeIds.count > 0) {
        return [purposeConsentsDictionary dictionaryWithValuesForKeys:purposeIds];
    }
    
    return purposeConsentsDictionary;
}

#pragma mark - Private methods

+(NSNumber *)isPurposeAllowedForBinary:(unsigned char*)buffer atBitPosition:(NSInteger)bitPosition {
    const NSInteger purposeStartBit = 102;
    
    size_t binaryLength =  (int)strlen((const char *)buffer);
    NSInteger purposeId = purposeStartBit + bitPosition;
    
    if (binaryLength <= purposeId || purposeId > purposeStartBit + purposeNumBits) {
        return nil;
    }
    
    return buffer[purposeId] == '1' ? @YES : @NO;
}

+(unsigned char*)binaryConsent {
    NSString* safeString = [CMPConsentToolUtil safeBase64ConsetString:[self class].consentString];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:safeString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    if (!decodedData) {
        return nil;
    }
    
    return [CMPConsentToolUtil NSDataToBinary:decodedData];
}

@end
