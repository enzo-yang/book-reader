//
//  AppDelegate.m
//  book-reader
//
//  Created by ENZO YANG on 13-4-1.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "AppDelegate.h"


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
    
    return YES;
}

@end
