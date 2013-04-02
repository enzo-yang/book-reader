//
//  FileScanner.h
//  book-reader
//
//  Created by ENZO YANG on 13-4-2.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import <Foundation/Foundation.h>

// 不理会Byte Order Mark， 没影响


@interface FileScanner : NSObject

@property (nonatomic, retain, readonly) NSString *path;
@property (nonatomic, assign, readonly) int size;
@property (nonatomic, assign, readonly) NSStringEncoding encoding;
@property (nonatomic, assign, readonly) BOOL canRandomAccess;

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding;
- (NSString *)nextNChar:(int)n;
- (unsigned long long)position;
- (BOOL)isEndOfFile;

@end

// 定长字符编码可以随机读取
@interface FileScannerUTF16 : FileScanner
@end

@interface FileScannerLatin : FileScanner
@end


// 变长字符编码只能按顺序读
@interface FileScannerOrderAccess : FileScanner
@end

@interface FileScannerUTF8 : FileScannerOrderAccess
- (id)initWithPath:(NSString *)path;
@end

@interface FileScannerGB18030 : FileScannerOrderAccess
- (id)initWithPath:(NSString *)path;
@end

@interface FileScannerBIG5 : FileScannerOrderAccess
@end
