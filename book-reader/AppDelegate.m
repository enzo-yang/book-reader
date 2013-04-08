//
//  AppDelegate.m
//  book-reader
//
//  Created by ENZO YANG on 13-4-1.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    char c = 'a';
    NSString *result = [[NSString alloc] initWithBytes:&c length:0 encoding:NSUTF8StringEncoding];
    NSLog(@"result %@ %@", result, [result isKindOfClass:[NSString class]] ? @"YES" : @"NO");

    return YES;
}


@end
