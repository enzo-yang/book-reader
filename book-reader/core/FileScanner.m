//
//  FileScanner.m
//  book-reader
//
//  Created by ENZO YANG on 13-4-2.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "FileScanner.h"
#import "AutoPropertyRelease.h"

@interface FileScanner()

@property (nonatomic, retain, readwrite) NSString *path;
@property (nonatomic, assign, readwrite) int size;
@property (nonatomic, assign, readwrite) NSStringEncoding encoding;
@property (nonatomic, assign, readwrite) BOOL canRandomAccess;

@property (nonatomic, retain) NSFileHandle *fileHandle;

@end

@implementation FileScanner

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super init];
    if (self) {
        self.path               = path;
        self.encoding           = encoding;
        self.canRandomAccess    = NO;
        // self.position           = 0;
        
        self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.path];
        if (!self.fileHandle) {
            [self release];
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
    [AutoPropertyRelease releaseProperties:self thisClass:[FileScanner class]];
    [super dealloc];
}

@end

@implementation FileScannerUTF16

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super initWithPath:path encoding:encoding];
    if (self) {
        self.canRandomAccess = YES;
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
        NSString *result = [[[NSString alloc] initWithData:data encoding:self.encoding] autorelease];
        
        if (!result) return @"";
        return result;
    }
}

@end

@implementation FileScannerLatin

- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding {
    self = [super initWithPath:path encoding:encoding];
    if (self) {
        self.canRandomAccess = YES;
    }
    return self;
}

- (NSString *)nextNChar:(int)n {
    @synchronized(self) {
        if ([self isEndOfFile]) return @"";
        
        NSData *data = [self.fileHandle readDataOfLength:n];
        NSString *result = [[[NSString alloc] initWithData:data encoding:self.encoding] autorelease];
        
        if (!result) return @"";
        return result;
    }
}
@end

@interface FileScannerOrderAccess()

@property (nonatomic, assign) char *buffer;
@property (nonatomic, assign) int   bufferSize;

@end

@implementation FileScannerOrderAccess

- (void)dealloc {
    free(_buffer);
    [AutoPropertyRelease releaseProperties:self thisClass:[FileScannerOrderAccess class]];
    [super dealloc];
}

@end

@interface FileScannerUTF8()
@property (nonatomic, retain) NSData    *data;
@property (nonatomic, assign) int       innerOffset;
@end

@implementation FileScannerUTF8

- (id)initWithPath:(NSString *)path {
    self = [super initWithPath:path encoding:NSUTF8StringEncoding];
    if (self) {
    }
    return self;
}

- (NSString *)nextNChar:(int)n {
    @synchronized(self) {
        int beginOffset = (int)[self.fileHandle offsetInFile];
        if (beginOffset == self.size) return @"";
        
        if (self.bufferSize/4 < (n+1)) {
            free(self.buffer);
            self.bufferSize = (n+1)/4;
            self.buffer = malloc(self.bufferSize);
        }
        
        NSData *data = [self.fileHandle readDataOfLength:(int)(n*self.avgCharLength)];
        const char *bytes = [data bytes];
        int dataLength = [data length];
        
        int offset = beginOffset;
        
        int wordCount = 0;
        int byteCount = 0;
        while (offset < self.size && wordCount < n) {
            
        }
    }
}

@end
