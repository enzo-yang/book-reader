//
//  FileTools.h
//  book-reader
//
//  Created by YANG ENZO on 13-4-5.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextFileScanner.h"

extern const NSStringEncoding kUnknownStringEncoding;

@interface TextFileTools : NSObject

+ (BOOL)convertFile:(TextFileScanner *)scanner toEncoding:(NSStringEncoding)encoding dest:(NSString *)destPath;

+ (NSStringEncoding)recognizeEncoding:(NSString *)path;

@end
