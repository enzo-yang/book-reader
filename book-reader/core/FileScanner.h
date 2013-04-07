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

@class FileScannerRandomAccess;

@interface FileScanner : NSObject

@property (nonatomic, retain, readonly) NSString *path;
@property (nonatomic, assign, readonly) int size;
@property (nonatomic, assign, readonly) NSStringEncoding encoding;
@property (nonatomic, assign, readonly) BOOL canRandomAccess;
@property (nonatomic, assign, readonly) int invalidCount; // 错误编码个数

+ (FileScanner *)fileScannerOfFile:(NSString *)path encoding:(NSStringEncoding)encoding;
+ (FileScannerRandomAccess *)fileScannerRandomAccessOfFile:(NSString *)path encoding:(NSStringEncoding)encoding;

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding;
- (NSString *)nextNChar:(int)n;
- (unsigned long long)position;
- (BOOL)isEndOfFile;

@end

// 定长字符编码可以随机读取
@interface FileScannerRandomAccess :FileScanner
@end

@interface FileScannerUTF16 : FileScannerRandomAccess
@end

@interface FileScannerLatin : FileScannerRandomAccess
@end


// 变长字符编码只能按顺序读
@interface FileScannerOrderAccess : FileScanner
// 不要实例化这个东西
@end

@interface FileScannerUTF8 : FileScannerOrderAccess
@property (nonatomic, assign, readonly) int noneSingleByteCharCount; // 用于判断是否纯英文
- (id)initWithPath:(NSString *)path;
@end

@interface FileScannerGB18030 : FileScannerOrderAccess
- (id)initWithPath:(NSString *)path;
@end

// 仅用 kCFStringEncodingBig5_HKSCS_1999 已经足够
@interface FileScannerBIG5 : FileScannerOrderAccess
- (id)initWithPath:(NSString *)path;
@end
