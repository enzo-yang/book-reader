//
//  book_readerTests.m
//  book-readerTests
//
//  Created by ENZO YANG on 13-4-1.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "book_readerTests.h"
#import "FileTools.h"
#import "Paginater.h"

@implementation book_readerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testEncodingRecognize {
    NSString *utf8GuWenPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"古文观止-utf8" ofType:@"txt"];
    NSString *utf16GuWenPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"古文观止-utf16" ofType:@"txt"];
    NSString *gb18030Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"诗经-gb18030" ofType:@"txt"];
    NSString *utf8Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"诗经-utf8" ofType:@"txt"];
    NSString *asciiPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"harry-porter" ofType:@"txt"];
    
    FileScanner *scanner = nil;
    scanner = [FileScanner fileScannerOfFile:utf8GuWenPath encoding:[FileTools recognizeEncoding:utf8GuWenPath]];
    NSLog(@"%@", scanner);
    
    scanner = [FileScanner fileScannerOfFile:utf16GuWenPath encoding:[FileTools recognizeEncoding:utf16GuWenPath]];
    NSLog(@"%@", scanner);
    
    scanner = [FileScanner fileScannerOfFile:gb18030Path encoding:[FileTools recognizeEncoding:gb18030Path]];
    NSLog(@"%@", scanner);
    
    scanner = [FileScanner fileScannerOfFile:utf8Path encoding:[FileTools recognizeEncoding:utf8Path]];
    NSLog(@"%@", scanner);
    
    scanner = [FileScanner fileScannerOfFile:asciiPath encoding:[FileTools recognizeEncoding:asciiPath]];
    NSLog(@"%@", scanner);
    
}



- (void)testConverShiftJIS2Utf16BE {
    NSString *shiftJISWenxuePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"文学少女-Shift-JIS" ofType:@"txt"];
    NSString *utf16BEWenXuePath = [NSHomeDirectory() stringByAppendingPathComponent:@"文学少女-utf16be.txt"];
    FileScanner *scanner = [[FileScannerByLine alloc] initWithPath:shiftJISWenxuePath encoding:NSShiftJISStringEncoding];
    [FileTools convertFile:scanner toEncoding:NSUTF16BigEndianStringEncoding dest:utf16BEWenXuePath];
    
    NSLog(@"%@", utf16BEWenXuePath);
}

- (void)testWenxuePagination {
    NSString *utf16BEWenXuePath = [NSHomeDirectory() stringByAppendingPathComponent:@"文学少女-utf16be.txt"];
    RandomAccessText *text = [[RandomAccessText alloc] initWithPath:utf16BEWenXuePath encoding:NSUTF16BigEndianStringEncoding];
    
    Paginater *paginater = [[Paginater alloc] initWithRandomAccessText:text size:CGSizeMake(320, 480) font:[UIFont systemFontOfSize:17]];
    
    NSDate *beginTime = [NSDate date];
    [paginater paginate];
    NSLog(@"used time %lfs, pageCount %d", [[NSDate date] timeIntervalSinceDate:beginTime], [paginater pageCount]);
    
    NSString *str = [paginater stringOfPage:3];
    NSLog(@"%@", str);
}

- (void)testConverBig52Utf16LE {
    NSString *big5GuWenPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"古文观止-big5" ofType:@"txt"];
    NSString *utf16LEGuWenPath = [NSHomeDirectory() stringByAppendingPathComponent:@"古文观止-utf16le.txt"];
    FileScanner *scanner = [[FileScannerBIG5 alloc] initWithPath:big5GuWenPath];
    [FileTools convertFile:scanner toEncoding:NSUTF16LittleEndianStringEncoding dest:utf16LEGuWenPath];
    
    NSLog(@"%@", utf16LEGuWenPath);
}

- (void)testGuwenPagination {
    NSString *utf16LEGuWenPath = [NSHomeDirectory() stringByAppendingPathComponent:@"古文观止-utf16le.txt"];
    RandomAccessText *text = [[RandomAccessText alloc] initWithPath:utf16LEGuWenPath encoding:NSUTF16LittleEndianStringEncoding];
    
    Paginater *paginater = [[Paginater alloc] initWithRandomAccessText:text size:CGSizeMake(320, 480) font:[UIFont systemFontOfSize:17]];
    
    NSDate *beginTime = [NSDate date];
    [paginater paginate];
    NSLog(@"used time %lfs, pageCount %d", [[NSDate date] timeIntervalSinceDate:beginTime], [paginater pageCount]);
    
    NSString *str = [paginater stringOfPage:3];
    NSLog(@"%@", str);
}

- (void)testHarryPorterPagination {
    NSString *asciiPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"harry-porter" ofType:@"txt"];
    RandomAccessText *text = [[RandomAccessText alloc] initWithPath:asciiPath encoding:NSASCIIStringEncoding];
    
    Paginater *paginater = [[Paginater alloc] initWithRandomAccessText:text size:CGSizeMake(320, 480) font:[UIFont systemFontOfSize:17]];
    
    NSDate *beginTime = [NSDate date];
    [paginater paginate];
    NSLog(@"used time %lfs, pageCount %d", [[NSDate date] timeIntervalSinceDate:beginTime], [paginater pageCount]);
    
    NSString *str = [paginater stringOfPage:3];
    NSLog(@"%@", str);
}

//- (void)testPagination {
//    NSString *utf16GuWenPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"古文观止-utf16" ofType:@"txt"];
//    RandomAccessText *text = [[RandomAccessText alloc] initWithPath:utf16GuWenPath encoding:NSUTF16StringEncoding];
//    Paginater *paginater = [[Paginater alloc] initWithRandomAccessText:text size:CGSizeMake(320, 480) font:[UIFont systemFontOfSize:17]];
//    
//    NSDate *beginTime = [NSDate date];
//    [paginater paginate];
//    NSLog(@"used time %lfs, pageCount %d", [[NSDate date] timeIntervalSinceDate:beginTime], [paginater pageCount]);
//    
//    // NSLog(@"content of page 3: %@", [paginater stringOfPage:3]);
//    NSString *str = [paginater stringOfPage:3];
//    NSLog(@"%@", str);
//}

@end
