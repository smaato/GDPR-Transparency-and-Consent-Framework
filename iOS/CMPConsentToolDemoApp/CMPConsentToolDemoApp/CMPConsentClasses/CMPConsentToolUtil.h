//
//  CMPConsentToolUtil.h
//
//  Copyright © 2018 Smaato Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPConsentToolUtil : NSObject
+(NSString*)addPaddingIfNeeded:(NSString*)base64String;
+(unsigned char*)NSDataToBinary:(NSData *)decodedData;
+(NSString*)replaceSafeCharacters:(NSString*)consentString;
+(NSString*)safeBase64ConsetString:(NSString*)consentString;
+(NSInteger)BinaryToDecimal:(unsigned char*)buffer fromIndex:(int)startIndex toIndex:(int)endIndex;
@end
