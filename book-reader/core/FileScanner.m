//
//  FileScanner.m
//  book-reader
//
//  Created by ENZO YANG on 13-4-2.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "FileScanner.h"

extern const NSStringEncoding kUnknownStringEncoding;
const NSInteger kFileScannerTolerateMaxInvalidCount = 100;

@interface FileScanner()

@property (nonatomic, strong, readwrite) NSString *path;
@property (nonatomic, assign, readwrite) int size;
@property (nonatomic, assign, readwrite) NSStringEncoding encoding;
@property (nonatomic, assign, readwrite) BOOL canRandomAccess;
@property (nonatomic, assign, readwrite) int invalidCount;

@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation FileScanner

+ (FileScanner *)fileScannerOfFile:(NSString *)path encoding:(NSStringEncoding)encoding {
    if (encoding == kUnknownStringEncoding) return nil;
    
    FileScanner *result = [self fileScannerRandomAccessOfFile:path encoding:encoding];
    if (result) return result;
    
    NSStringEncoding GB18030Encoding    = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSStringEncoding BIG5Encoding       = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5_HKSCS_1999);
    
    if (encoding == NSUTF8StringEncoding) {
        result = [[FileScannerUTF8 alloc] initWithPath:path];
    } else if (encoding == GB18030Encoding) {
        result = [[FileScannerGB18030 alloc] initWithPath:path];
    } else if (encoding == BIG5Encoding) {
        result = [[FileScannerBIG5 alloc] initWithPath:path];
    } else {
        result = [[FileScannerByLine alloc] initWithPath:path encoding:encoding];
    }
    
    return result;
}

+ (FileScannerRandomAccess *)fileScannerRandomAccessOfFile:(NSString *)path encoding:(NSStringEncoding)encoding {
    FileScannerRandomAccess *result = nil;
    if (encoding == NSASCIIStringEncoding ||
        encoding == NSISOLatin1StringEncoding ||
        encoding == NSISOLatin2StringEncoding ) {
        
        result = [[FileScannerLatin alloc] initWithPath:path encoding:encoding];
        
    } else if (encoding == NSUTF16LittleEndianStringEncoding ||
               encoding == NSUTF16BigEndianStringEncoding ) {
        
        result = [[FileScannerUTF16 alloc] initWithPath:path encoding:encoding];
    }
    
    return result;
}

+ (FileScannerByLine *)fileScannerByLineOfFile:(NSString *)path encoding:(NSStringEncoding)encoding {
    FileScannerByLine *scanner = [[FileScannerByLine alloc] initWithPath:path encoding:encoding];
    return scanner;
}

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super init];
    if (self) {
        self.path               = path;
        self.encoding           = encoding;
        self.canRandomAccess    = NO;
        self.invalidCount       = 0;
        
        self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.path];
        if (!self.fileHandle) {
            self = nil;
        } else {
            self.size = (int)[self.fileHandle seekToEndOfFile];
            [self.fileHandle seekToFileOffset:0];
        }
    }
    return self;
}

- (NSString *)nextNChar:(int)n {
    return @"";
}

- (unsigned long long)position {
    return [self.fileHandle offsetInFile];
}

- (BOOL)isEndOfFile {
    return [self position] == self.size;
}

- (void)dealloc {
    [self.fileHandle closeFile];
}

- (NSString *)description {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(self.encoding);
    NSString *encodingName = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(cfEncoding);
    
    NSDictionary *dict = @{@"path": self.path,
                           @"encoding" : [encodingName copy],
                           @"size": [NSNumber numberWithLongLong:self.size],
                           @"randomAccess" : self.canRandomAccess ? @"YES" : @"NO"};
    return [NSString stringWithFormat:@"%@", dict];
}

@end

@implementation FileScannerRandomAccess {
    @protected
    int _bytesAChar;
}

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super initWithPath:path encoding:encoding];
    if (self) {
        self.canRandomAccess = YES;
    }
    return self;
}

- (NSString *)nextNChar:(int)n from:(int)from {
    if (from * _bytesAChar >= self.size) {
        [self.fileHandle seekToEndOfFile];
    } else {
        [self.fileHandle seekToFileOffset:from * _bytesAChar];
    }
    return [self nextNChar:n];
}

@end

@implementation FileScannerUTF16

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super initWithPath:path encoding:encoding];
    if (self) {
        _bytesAChar = 2;
    }
    return self;
}

- (NSString *)nextNChar:(int)n {
    @synchronized(self) {
        unsigned long long offset = [self.fileHandle offsetInFile];
        if (offset == self.size) return @"";
        if (offset % 2) {
            offset -= 1;
            [self.fileHandle seekToFileOffset:offset];
        }
        
        NSData *data = [self.fileHandle readDataOfLength:n*2];
        NSString *result = [[NSString alloc] initWithData:data encoding:self.encoding];
        
        if (!result) return @"";
        return result;
    }
}

@end

@implementation FileScannerLatin

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super initWithPath:path encoding:encoding];
    if (self) {
        _bytesAChar = 1;
    }
    return self;
}

- (NSString *)nextNChar:(int)n {
    @synchronized(self) {
        if ([self isEndOfFile]) return @"";
        
        NSData *data = [self.fileHandle readDataOfLength:n];
        NSString *result = [[NSString alloc] initWithData:data encoding:self.encoding];
        
        if (!result) return @"";
        return result;
    }
}
@end

@interface FileScannerOrderAccess()

@property (nonatomic, strong) NSData    *data;
@property (nonatomic, assign) int       innerOffset;

- (NSString *)_nextNChar:(int)n;
- (void)_loadFollowingDataIfNotMuch;
- (void)_moveToEndOfFile;

@end

@implementation FileScannerOrderAccess

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super initWithPath:path encoding:encoding];
    if (self) {
        self.data = [NSData data];
        self.innerOffset = 0;
    }
    return self;
}


- (unsigned long long)position {
    unsigned long long filePosition = [self.fileHandle offsetInFile];
    return filePosition - [self.data length] + self.innerOffset;
}

- (NSString *)nextNChar:(int)n {
    @synchronized(self) {
        // 为了用递归的方式获得字符串, 另开一个方法
        return [self _nextNChar:n];
    }
}

- (NSString *)_nextNChar:(int)n {
    return @"";
}

- (void)_loadFollowingDataIfNotMuch {
    // 无符号整型比较! 转成有符号的
    if ((long long)self.position > ((long long)[self.fileHandle offsetInFile] - 4)) {
        [self.fileHandle seekToFileOffset:self.position];
        self.data = [self.fileHandle readDataOfLength:2000*4]; //每次读8000个字节
        self.innerOffset = 0;
    }
}

- (void)_moveToEndOfFile {
    [self.fileHandle seekToEndOfFile];
    self.data = [NSData data];
    self.innerOffset = 0;
}

@end

@interface FileScannerUTF8()
@property (nonatomic, assign, readwrite) int noneSingleByteCharCount;
@end

@implementation FileScannerUTF8

- (id)initWithPath:(NSString *)path {
    self = [super initWithPath:path encoding:NSUTF8StringEncoding];
    if (self) {
        self.noneSingleByteCharCount = 0;
    }
    return self;
}


- (NSString *)_nextNChar:(int)n {
    if (n == 0) return @"";
    if ([self isEndOfFile]) return @"";
    
    [self _loadFollowingDataIfNotMuch];
    
    const char *bytes = [self.data bytes];
    int dataLength = [self.data length];
    
    int innerOffset = self.innerOffset; // 扫描到的位置
    int wordCount = 0; // 字符数
    int byteCount = 0; // 和字符数对应的字节数
    BOOL longEnough = YES;
    while (innerOffset < dataLength && wordCount < n) {
        int checkNextN = 0;
        BOOL valid = YES;
        
        unsigned char b = bytes[innerOffset];
        if ((b & 0x80) == 0) {
            ;
        } else if ((b & 0x20) == 0) {
            checkNextN = 1;
        } else if ((b & 0x10) == 0) {
            checkNextN = 2;
        } else if ((b & 0x08) == 0) {
            checkNextN = 3;
        } else {
            valid = NO;
        }
        
        // 不够解释完一个字符
        if (innerOffset + 1 + checkNextN >= dataLength) {
            longEnough = NO;
            break;
        }
        
        const char *pb = bytes + innerOffset + 1;
        const char *pbDest = pb + checkNextN;
        while (pb != pbDest) {
            if ((*pb & 0x40) != 0) {
                valid = NO;
                break;
            }
            ++pb;
        }
        
        innerOffset += (1 + checkNextN);
        if (!valid) {
            // 遇到错误字符，忽略错误那一段
            self.invalidCount += 1;
            innerOffset = [self _findNextValid:bytes from:innerOffset to:dataLength];
            break;
        }
        
        byteCount += (1 + checkNextN);
        ++wordCount;
        
        if (checkNextN) {
            _noneSingleByteCharCount += 1;
        }
    }
    
    NSString *result = [[NSString alloc] initWithBytes:(bytes+self.innerOffset) length:byteCount encoding:self.encoding];
    if (!result) {
        result = @"";
        self.invalidCount = kFileScannerTolerateMaxInvalidCount + 1;
    }
    
    self.innerOffset = innerOffset;
    
    if (!longEnough && self.size == [self.fileHandle offsetInFile]) {
        // 后面的错误忽略掉， 防止死循环
        self.innerOffset = dataLength;
    }
    
    if (self.invalidCount > kFileScannerTolerateMaxInvalidCount) {
        [self _moveToEndOfFile];
    }
    return [result stringByAppendingString:[self _nextNChar:(n-wordCount)]];
}

- (int)_findNextValid:(const char *)bytes from:(int)offset to:(int)size {
    const char *pb = bytes + offset;
    const char *pbDest = bytes + size;
    while (pb != pbDest) {
        if ((*pb & 0x80) == 0 ||
            (*pb & 0x20) == 0 ||
            (*pb & 0x10) == 0 ||
            (*pb & 0x08) == 0) {
            break;
        }
        ++pb;
    }
    return pb - bytes;
}

@end


@implementation FileScannerGB18030

- (id)initWithPath:(NSString *)path {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [super initWithPath:path encoding:encoding];
}

- (NSString *)_nextNChar:(int)n {
    if (n == 0) return @"";
    if ([self isEndOfFile]) return @"";
    
    [self _loadFollowingDataIfNotMuch];
    
    const unsigned char *bytes = [self.data bytes];
    int dataLength = [self.data length];
    int innerOffset = self.innerOffset; // 扫描到的位置
    int wordCount = 0; // 字符数
    int byteCount = 0; // 和字符数对应的字节数
    int longEnough = YES;
    while (innerOffset < dataLength && wordCount < n) {
        // 单字节，其值从0到0x7F。
		// 双字节，第一个字节的值从0x81到0xFE，第二个字节的值从0x40到0xFE（不包括0x7F）。
		// 四字节，第一个字节的值从0x81到0xFE，第二个字节的值从0x30到0x39，第三个字节从0x81到0xFE，第四个字节从0x30到0x39。
        const unsigned char *pb = bytes + innerOffset;
        int wordByteCount = 1;
        BOOL valid = YES;
        if ((*pb & 0x80) == 0) {
            // 单字节
            ;
        } else if (*pb == 0x80) {
            valid = NO;
        } else {
            // 多字节
            wordByteCount = 2;
            if (innerOffset + wordByteCount >= dataLength) {
                longEnough = NO;
                break;
            }

            ++pb;
            
            if (*pb >= 0x40 && *pb <= 0xFE) {
                // 双字节
                ;
            } else if (*pb >= 0x30 && *pb <= 0x39) {
                // 四字节
                wordByteCount = 4;
                if (innerOffset + wordByteCount >= dataLength) {
                    longEnough = NO;
                    break;
                }
                
                ++pb;
                if (*pb < 0x81 || *pb > 0xFE) {
                    valid = NO;
                }
                ++pb;
                if (*pb < 0x30 || *pb > 0x39) {
                    valid = NO;
                }
            } else {
                valid = NO;
            }
        }
        
        innerOffset += wordByteCount;
        if (!valid) {
            self.invalidCount += 1;
            break;
        }
        
        byteCount += wordByteCount;
        ++wordCount;
    }
    
    NSString *result = [[NSString alloc] initWithBytes:(bytes+self.innerOffset) length:byteCount encoding:self.encoding];
    if (!result) {
        result = @"";
        self.invalidCount = kFileScannerTolerateMaxInvalidCount + 1;
    }
    self.innerOffset = innerOffset;
    
    if (!longEnough && self.size == [self.fileHandle offsetInFile]) {
        // 后面的错误忽略掉， 防止死循环
        self.innerOffset = dataLength;
    }
    
    if (self.invalidCount > kFileScannerTolerateMaxInvalidCount) {
        [self _moveToEndOfFile];
    }
    
    return [result stringByAppendingString:[self _nextNChar:(n-wordCount)]];
}

@end

// 和GB18030差不多
@implementation FileScannerBIG5

- (id)initWithPath:(NSString *)path {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5_HKSCS_1999);
    return [super initWithPath:path encoding:encoding];
}

- (NSString *)_nextNChar:(int)n {
    if (n == 0) return @"";
    if ([self isEndOfFile]) return @"";
    
    [self _loadFollowingDataIfNotMuch];
    
    const unsigned char *bytes = [self.data bytes];
    int dataLength = [self.data length];
    int innerOffset = self.innerOffset; // 扫描到的位置
    int wordCount = 0; // 字符数
    int byteCount = 0; // 和字符数对应的字节数
    int longEnough = YES;
    while (innerOffset < dataLength && wordCount < n) {
        // 单字节，其值从0到0x7F。
        // 中文 “高位字节”使用了0x81-0xFE，“低位字节”使用了0x40-0x7E，及0xA1-0xFE
        const unsigned char *pb = bytes + innerOffset;
        int wordByteCount = 1;
        BOOL valid = YES;
        if ((*pb & 0x80) == 0) {
            // 单字节
            ;
        } else if (*pb == 0x80) {
            valid = NO;
        } else {
            // 双字节
            wordByteCount = 2;
            if (innerOffset + wordByteCount >= dataLength) {
                longEnough = NO;
                break;
            }
            
            ++pb;
            
            if (!((*pb >= 0x40 && *pb <= 0x7E) ||
                (*pb >= 0xA1 && *pb <= 0xFE))) {
                valid = NO;
            }
        }
        
        innerOffset += wordByteCount;
        if (!valid) {
            self.invalidCount += 1;
            break;
        }
        
        byteCount += wordByteCount;
        ++wordCount;
    }
    
    NSString *result = [[NSString alloc] initWithBytes:(bytes+self.innerOffset) length:byteCount encoding:self.encoding];
    if (!result) {
        result = @"";
        self.invalidCount = kFileScannerTolerateMaxInvalidCount + 1;
    }
    self.innerOffset = innerOffset;
    
    if (!longEnough && self.size == [self.fileHandle offsetInFile]) {
        // 后面的错误忽略掉， 防止死循环
        self.innerOffset = dataLength;
    }
    
    if (self.invalidCount > kFileScannerTolerateMaxInvalidCount) {
        [self _moveToEndOfFile];
    }
    
    return [result stringByAppendingString:[self _nextNChar:(n-wordCount)]];
}

@end

@implementation FileScannerByLine {
    int _offsetInBuffer;
    
    NSData *_buffer;
    NSData *_newLineData;
}

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super initWithPath:path encoding:encoding];
    if (self) {
        _buffer = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:nil];
        NSString *newLineString = @"\n";
        _newLineData = [newLineString dataUsingEncoding:encoding];
        if (!_buffer) {
            self = nil;
        }
    }
    return self;
}

- (NSString *)nextNChar:(int)n {
    return [self nextLine];
}

- (NSString *)nextLine {
    NSRange range = [_buffer rangeOfData:_newLineData options:0 range:NSMakeRange(_offsetInBuffer, _buffer.length - _offsetInBuffer)];
    
    NSData *resultData = nil;
    int nextOffset = _buffer.length;
    if (range.location != NSNotFound) {
        nextOffset = range.location + range.length;
        
    }
    resultData = [_buffer subdataWithRange:NSMakeRange(_offsetInBuffer, nextOffset - _offsetInBuffer)];
    _offsetInBuffer = nextOffset;
    return [[NSString alloc] initWithData:resultData encoding:self.encoding];
}

- (unsigned long long)position {
    return _offsetInBuffer;
}

- (BOOL)isEndOfFile {
    return _offsetInBuffer == _buffer.length;
}

@end

