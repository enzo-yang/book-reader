//
//  book_readerTests.m
//  book-readerTests
//
//  Created by ENZO YANG on 13-4-1.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "book_readerTests.h"

@implementation book_readerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testReadFile {
    NSArray *filenames = @[@"ascii", @"gb18030", @"japanese-euc", @"shift-jis", @"utf-16-be", @"utf-16-le", @"utf-8"];
    for (NSString *filename in filenames) {
        NSString *filepath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"txt"];
        NSLog(@"path: %@", filepath);
        NSStringEncoding encoding;
        NSError *error = nil;
        NSString *string = [NSString stringWithContentsOfFile:filepath usedEncoding:&encoding error:&error];
        NSLog(@"string: %@, encoding: %x, error: %@", string, encoding, error);
        NSLog(@"***********************************");
    }
}

//- (void)testGenerateTestFile {
////    NSArray *filenames = @[@"ascii.txt", @"gb18030.txt", @"japanese-euc.txt", @"shift-jis.txt", @"utf-16-be.txt", @"utf-16-le.txt", @"utf-8.txt"];
////    NSArray *contents = @[@"this is ascii file.",
////                           @"这是一段中文，gb18030编码",
////                           @"これは日本語、eucで、形式です",
////                           @"これは日本語、Shift-JISで、形式です",
////                           @"这是一段中文， utf-16-be编码",
////                           @"这是一段中文，utf-16-le编码",
////                           @"这是一段中文，utf-8编码"];
//    
//    NSLog(@"home dir: %@", NSHomeDirectory());
//    
//    NSString *filename = @"ascii.txt";
//    NSString *content = @"this is ascii file.";
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    [content writeToFile:path atomically:YES encoding:NSASCIIStringEncoding error:nil];
//    
//    filename = @"gb18030.txt";
//    content = @"这是一段中文，gb18030编码";
//    path = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    [content writeToFile:path atomically:YES encoding:enc error:nil];
//    
//    filename = @"japanese-euc.txt";
//    content = @"これは日本語、eucで、形式です";
//    path = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    [content writeToFile:path atomically:YES encoding:NSJapaneseEUCStringEncoding error:nil];
//    
//    filename = @"shift-jis.txt";
//    content = @"これは日本語、Shift-JISで、形式です";
//    path = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    [content writeToFile:path atomically:YES encoding:NSShiftJISStringEncoding error:nil];
//    
//    filename = @"utf-16-be.txt";
//    content = @"这是一段中文， utf-16-be编码";
//    path = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    [content writeToFile:path atomically:YES encoding:NSUTF16BigEndianStringEncoding error:nil];
//    
//    filename = @"utf-16-le.txt";
//    content = @"这是一段中文，utf-16-le编码";
//    path = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    [content writeToFile:path atomically:YES encoding:NSUTF16LittleEndianStringEncoding error:nil];
//    
//    filename = @"utf-8.txt";
//    content = @"这是一段中文，utf-8编码";
//    path = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//}

@end
