//
//  AppDelegate.m
//  book-reader
//
//  Created by ENZO YANG on 13-4-1.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "AppDelegate.h"
#import "Paginater.h"
#import <CoreText/CoreText.h>

@interface AppDelegate()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    NSString *jis = @"次の\n\r行0D0Aをコー\n\rシフトJIS";
//    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSData *data = [jis dataUsingEncoding:NSShiftJISStringEncoding];
//    NSLog(@"data : %@", data);
    
//    NSString *utf16GuWenPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"古文观止-utf16le" ofType:@"txt"];
//    RandomAccessText *text = [[RandomAccessText alloc] initWithPath:utf16GuWenPath encoding:NSUTF16LittleEndianStringEncoding];
//    Paginater *paginater = [[Paginater alloc] initWithRandomAccessText:text size:CGSizeMake(320, 480) font:[UIFont systemFontOfSize:17]];
//    
//    NSDate *beginTime = [NSDate date];
//    [paginater paginate];
//    NSLog(@"used time %lfs, pageCount %d", [[NSDate date] timeIntervalSinceDate:beginTime], [paginater pageCount]);
//    
//    // NSLog(@"content of page 3: %@", [paginater stringOfPage:3]);
//    NSString *str = [paginater stringOfPage:3];
//    NSLog(@"%@", str);
    
    return YES;
}

@end
