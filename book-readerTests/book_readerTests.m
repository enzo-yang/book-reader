//
//  book_readerTests.m
//  book-readerTests
//
//  Created by ENZO YANG on 13-4-1.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "book_readerTests.h"
#import "FileTools.h"

@interface AA : NSObject {
    // NSString * _gg;
}
@property (nonatomic, weak) NSString *gg;
@end

@implementation AA

- (id)run {
    self.gg = [[NSString alloc] initWithFormat:@"xxxxxxyyyyyy %@", @"xxx"];
    return self;
}

- (id)runAgain {
    NSLog(@"%@", self.gg);
    // NSLog(@"%@", _gg);
    return self;
}

- (void)save:(NSError * __autoreleasing *)error {
    *error = [[NSError alloc] initWithDomain:@"xxxx" code:12 userInfo:nil];
}

@end


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

- (void)testArc {
    AA *a = [[[AA new] run] runAgain];
    
    [a runAgain];
    
    NSError * __autoreleasing error;
    [a save:&error];
    NSLog(@"error %@", error);
}

- (void)testReadFile {
//    NSArray *filenames = @[@"ascii", @"gb18030", @"japanese-euc", @"shift-jis", @"utf-16-be", @"utf-16-le", @"utf-8"];
//    for (NSString *filename in filenames) {
//        NSString *filepath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"txt"];
//        NSLog(@"path: %@", filepath);
//        NSStringEncoding encoding;
//        NSError *error = nil;
//        NSString *string = [NSString stringWithContentsOfFile:filepath usedEncoding:&encoding error:&error];
//        NSLog(@"string: %@, encoding: %x, error: %@", string, encoding, error);
//        NSLog(@"***********************************");
//    }
}

- (void)testEncodingRecognize {
//    NSString *utf8GuWenPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"古文观止-utf8" ofType:@"txt"];
//    NSString *utf16GuWenPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"古文观止-utf16" ofType:@"txt"];
//    NSString *gb18030Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"诗经-gb18030" ofType:@"txt"];
//    NSString *utf8Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"诗经-utf8" ofType:@"txt"];
//    NSString *asciiPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ascii" ofType:@"txt"];
//    
//    FileScanner *scanner = nil;
//    scanner = [FileScanner fileScannerOfFile:utf8GuWenPath encoding:[FileTools recognizeEncoding:utf8GuWenPath]];
//    NSLog(@"%@", scanner);
//    
//    scanner = [FileScanner fileScannerOfFile:utf16GuWenPath encoding:[FileTools recognizeEncoding:utf16GuWenPath]];
//    NSLog(@"%@", scanner);
//    
//    scanner = [FileScanner fileScannerOfFile:gb18030Path encoding:[FileTools recognizeEncoding:gb18030Path]];
//    NSLog(@"%@", scanner);
//    
//    scanner = [FileScanner fileScannerOfFile:utf8Path encoding:[FileTools recognizeEncoding:utf8Path]];
//    NSLog(@"%@", scanner);
//    
//    scanner = [FileScanner fileScannerOfFile:asciiPath encoding:[FileTools recognizeEncoding:asciiPath]];
//    NSLog(@"%@", scanner);
    
}

- (void)testConvertFormat {
//    NSString *gb18030Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"诗经-gb18030" ofType:@"txt"];
//    NSString *utf8Path = [NSHomeDirectory() stringByAppendingPathComponent:@"诗经-utf8.txt"];
//    NSString *utf16LEPath = [NSHomeDirectory() stringByAppendingPathComponent:@"诗经-utf16le.txt"];
//    NSString *utf16BEPath = [NSHomeDirectory() stringByAppendingPathComponent:@"诗经-utf16be.txt"];
//    
//    NSString *utf8GuWenPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"古文观止-utf8" ofType:@"txt"];
//    NSString *big5GuWenPath = [NSHomeDirectory() stringByAppendingPathComponent:@"古文观止-big5.txt"];
//    NSString *utf16GuWenPath = [NSHomeDirectory() stringByAppendingPathComponent:@"古文观止-utf16.txt"];
//    NSString *utf16LEGuWenPath = [NSHomeDirectory() stringByAppendingPathComponent:@"古文观止-utf16le.txt"];
//    
//    NSLog(@"utf16BEPath %@", utf16BEPath);
//    
//    FileScanner *scanner = [[FileScannerGB18030 alloc] initWithPath:gb18030Path];
//    [FileTools convertFile:scanner toEncoding:NSUTF8StringEncoding dest:utf8Path];
//    [scanner release];
//    
//    scanner = [[FileScannerUTF8 alloc] initWithPath:utf8Path];
//    [FileTools convertFile:scanner toEncoding:NSUTF16LittleEndianStringEncoding dest:utf16LEPath];
//    [scanner release];
//    
//    scanner = [[FileScannerUTF16 alloc] initWithPath:utf16LEPath encoding:NSUTF16LittleEndianStringEncoding];
//    [FileTools convertFile:scanner toEncoding:NSUTF16BigEndianStringEncoding dest:utf16BEPath];
//    [scanner release];
//    
//    scanner = [[FileScannerUTF8 alloc] initWithPath:utf8GuWenPath];
//    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5_HKSCS_1999);
//    [FileTools convertFile:scanner toEncoding:encoding dest:big5GuWenPath];
//    [scanner release];
//    
//    scanner = [[FileScannerBIG5 alloc] initWithPath:big5GuWenPath];
//    [FileTools convertFile:scanner toEncoding:NSUTF16StringEncoding dest:utf16GuWenPath];
//    [scanner release];
//    
//    scanner = [[FileScannerUTF16 alloc] initWithPath:utf16GuWenPath encoding:NSUTF16StringEncoding];
//    [FileTools convertFile:scanner toEncoding:NSUTF16LittleEndianStringEncoding dest:utf16LEGuWenPath];
//    [scanner release];
//    
//    NSLog(@"finished");
}

- (void)testGenerateTestFile {
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
    
//    NSString *filename = @"big5.txt";
//    NSString *content = @"這是一段中文，big5編碼";
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
//    [content writeToFile:path atomically:YES encoding:enc error:nil];
}

@end
