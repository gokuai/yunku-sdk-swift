/*
 *  FileMD5Hash.h
 *  FileMD5Hash
 * 
 *  Copyright © 2010 Joel Lopes Da Silva. All rights reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *        http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */


//---------------------------------------------------------
// Includes
//---------------------------------------------------------

// Core Foundation
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


//---------------------------------------------------------
// Constant declaration
//---------------------------------------------------------

// In bytes
#define FileHashDefaultChunkSizeForReadingData 4096

/** @file FileMD5Hash.h
 * @brief 计算文件Hash
 */

@interface FileSHA1 : NSObject
{
    
}

/**
 *@brief 计算文件Hash
 *
 *@param filePath [文件路径]
 *@param chunkSizeForReadingData [数据块大小]
 *@return [文件的hash]
 */
+(CFStringRef) FileMD5HashCreateWithPath:(CFStringRef) filePath size: 
                                                         (size_t) chunkSizeForReadingData;

@end
