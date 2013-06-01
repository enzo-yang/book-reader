//
//  RandomAccessText.m
//  book-reader
//
//  Created by YANG ENZO on 13-5-25.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "RandomAccessText.h"

@implementation RandomAccessText {
    NSData              *_buffer;
    int                 _bytesAChar;
    NSStringEncoding    _encoding;
    NSString            *_path;
}
- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super init];
    if (self) {
        if (encoding == NSUTF16StringEncoding ||
            encoding == NSUTF16BigEndianStringEncoding ||
            encoding == NSUTF16LittleEndianStringEncoding) {
            _bytesAChar = 2;
        } else {
            _bytesAChar = 1;
        }
        
        _encoding = encoding;
        _buffer = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedAlways error:nil];
        _path   = path;
        if (!_buffer) {
            self = nil;
        }
    }
    return self;
}

- (NSInteger)length {
    return _buffer.length / _bytesAChar;
}

- (NSString *)textInRange:(NSRange)range {
    if (range.location == NSNotFound) return @"";
    
    int head = range.location * _bytesAChar;
    if (head >= _buffer.length) return @"";
    
    int tail = (range.location + range.length) * _bytesAChar;
    tail = tail > _buffer.length ? _buffer.length : tail;
    
    if ((NSUInteger)(tail - head) == 4294602370) {
        NSLog(@"这里有问题");
    }
    NSData *data = [_buffer subdataWithRange:NSMakeRange(head, tail - head)];
    NSString *result = [[NSString alloc] initWithData:data encoding:_encoding];

    if (!result) result = @"";
    return [result copy];
}

- (NSString *)path {
    return _path;
}

@end
