//
//  FileTools.m
//  book-reader
//
//  Created by YANG ENZO on 13-4-5.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "TextFileTools.h"


const NSStringEncoding kUnknownStringEncoding = -1;

@implementation TextFileTools

+ (BOOL)convertFile:(TextFileScanner *)scanner toEncoding:(NSStringEncoding)encoding dest:(NSString *)destPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:destPath]) {
        [fileManager removeItemAtPath:destPath error:nil];
    }
    [fileManager createFileAtPath:destPath contents:[NSData data] attributes:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:destPath];
    BOOL success = YES;
    @try {
        while (![scanner isEndOfFile]) {
            @autoreleasepool {
                NSString *string = [scanner nextNChar:2000];
                NSData *data = [string dataUsingEncoding:encoding allowLossyConversion:YES];
                [fileHandle writeData:data];
            }
        }
    }
    @catch (NSException *exception) {
        success = NO;
    }
    
    [fileHandle closeFile];
    
    return success;
}

+ (NSStringEncoding)recognizeEncoding:(NSString *)path {
    NSStringEncoding encoding = kUnknownStringEncoding;
    // BOM
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [fileHandle readDataOfLength:3];
    if ([data length] != 3) {
        return kUnknownStringEncoding;
    } else {
        const unsigned char *bytes = [data bytes];
        if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
            // UTF16 Little Endian
            encoding = NSUTF16LittleEndianStringEncoding;
        } else if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
            // UTF16 Big Endian
            encoding = NSUTF16BigEndianStringEncoding;
        } else if (bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF) {
            // UTF8
            encoding = NSUTF8StringEncoding;
        }
    }
    
    [fileHandle closeFile]; fileHandle = nil;
    if (encoding != kUnknownStringEncoding) return encoding;
    
    TextFileScannerUTF8 *scanner = [[TextFileScannerUTF8 alloc] initWithPath:path];
    while (![scanner isEndOfFile]) {
        @autoreleasepool {
            [scanner nextNChar:2000];
        }
    }
    if (scanner.invalidCount > kFileScannerTolerateMaxInvalidCount) {
        return kUnknownStringEncoding;
    }
    
    if (scanner.noneSingleByteCharCount == 0) {
        return NSASCIIStringEncoding;
    }
    
    return NSUTF8StringEncoding;
}


@end
