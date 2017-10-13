//
//  gkobjassist.h
//  GYKUtility
//
//  Created by wqc on 2017/7/27.
//  Copyright © 2017年 wqc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface gkobjassist : NSObject

+ (NSString *)md5:(NSString *)str;
+ (NSString *)sha1:(NSString *)str;
+ (NSString *)generateSign:(NSString *)str key:(NSString *)key;
+ (uint32_t)crc32OfData:(NSData *)data seed:(uint32_t)seed usingPolynomial:(uint32_t)poly;
+ (NSString *)fileHashWithPath:(NSString *)localPath;

@end
NS_ASSUME_NONNULL_END
