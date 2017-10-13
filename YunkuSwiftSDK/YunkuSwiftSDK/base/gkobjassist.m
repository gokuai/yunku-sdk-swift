//
//  gkobjassist.m
//  GYKUtility
//
//  Created by wqc on 2017/7/27.
//  Copyright © 2017年 wqc. All rights reserved.
//

#import "gkobjassist.h"
#import <CommonCrypto/CommonHMAC.h>
#import "FileMD5Hash.h"

static void generateCRC32Table(uint32_t *pTable, uint32_t poly)
{
    for (uint32_t i = 0; i <= 255; i++)
    {
        uint32_t crc = i;
        
        for (uint32_t j = 8; j > 0; j--)
        {
            if ((crc & 1) == 1)
                crc = (crc >> 1) ^ poly;
            else
                crc >>= 1;
        }
        pTable[i] = crc;
    }
}

@implementation gkobjassist

+ (NSString *)md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSString*)sha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([data bytes],(CC_LONG)[data length], digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i<CC_SHA1_DIGEST_LENGTH;i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}



+ (NSString *)generateSign:(NSString *)str key:(NSString *)key {
    const char *secretStr = [key UTF8String];
    const char *signStr = [str UTF8String];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, secretStr, [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding], signStr, [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    return [HMAC base64EncodedStringWithOptions:0];
}


+ (uint32_t)crc32OfData:(NSData *)data seed:(uint32_t)seed usingPolynomial:(uint32_t)poly
{
    uint32_t *pTable = (uint32_t *)malloc(sizeof(uint32_t) * 256);
    generateCRC32Table(pTable, poly);
    
    uint32_t crc    = seed;
    uint8_t *pBytes = (uint8_t *)[data bytes];
    uint32_t length = (uint32_t)[data length];
    
    while (length--)
    {
        crc = (crc>>8) ^ pTable[(crc & 0xFF) ^ *pBytes++];
    }
    
    free(pTable);
    return crc ^ 0xFFFFFFFFL;
}

+ (NSString *)fileHashWithPath:(NSString *)localPath {
    CFStringRef strref = [FileSHA1 FileMD5HashCreateWithPath:(__bridge CFStringRef) localPath size:0];
    if (!strref) {
        return  @"";
    }
    NSString * filehash = [(__bridge NSString *)strref copy];
    if (strref) {
        CFRelease(strref);
    }
    return  filehash.copy;
}

@end
