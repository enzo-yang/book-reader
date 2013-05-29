//
//  FileScanner.h
//  book-reader
//
//  Created by ENZO YANG on 13-4-2.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import <Foundation/Foundation.h>

// 不理会Byte Order Mark， 没影响

// 在读取文件的情况下，下面各个方法基本没有机会抛出异常， 可不作异常处理。

extern const NSInteger kFileScannerTolerateMaxInvalidCount;

@class TextFileScannerRandomAccess;
@class TextFileScannerByLine;

@interface TextFileScanner : NSObject

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, assign, readonly) int size;
@property (nonatomic, assign, readonly) NSStringEncoding encoding;
@property (nonatomic, assign, readonly) BOOL canRandomAccess;
@property (nonatomic, assign, readonly) int invalidCount; // 错误编码个数

+ (TextFileScanner *)fileScannerOfFile:(NSString *)path encoding:(NSStringEncoding)encoding;
+ (TextFileScannerRandomAccess *)fileScannerRandomAccessOfFile:(NSString *)path encoding:(NSStringEncoding)encoding;
+ (TextFileScannerByLine *)fileScannerByLineOfFile:(NSString *)path encoding:(NSStringEncoding)encoding;

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding;
- (NSString *)nextNChar:(int)n;
- (unsigned long long)position;
- (BOOL)isEndOfFile;

@end

// 定长字符编码可以随机读取
@interface TextFileScannerRandomAccess :TextFileScanner
// offset 以字符为单位
- (NSString *)nextNChar:(int)n from:(int)offset;
@end

@interface TextFileScannerUTF16 : TextFileScannerRandomAccess
@end

@interface TextFileScannerLatin : TextFileScannerRandomAccess
@end


// 变长字符编码只能按顺序读
@interface TextFileScannerOrderAccess : TextFileScanner
// 不要实例化这个东西
@end

@interface TextFileScannerUTF8 : TextFileScannerOrderAccess
@property (nonatomic, assign, readonly) int noneSingleByteCharCount; // 用于判断是否纯英文
- (id)initWithPath:(NSString *)path;
@end

@interface TextFileScannerGB18030 : TextFileScannerOrderAccess
- (id)initWithPath:(NSString *)path;
@end

// 仅用 kCFStringEncodingBig5_HKSCS_1999 已经足够
@interface TextFileScannerBIG5 : TextFileScannerOrderAccess
- (id)initWithPath:(NSString *)path;
@end

// 
@interface TextFileScannerByLine : TextFileScanner

// 包括换行符
- (NSString *)nextLine;

- (unsigned long long)position;
- (BOOL)isEndOfFile;
@end
