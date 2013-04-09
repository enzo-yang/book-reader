//
//  AppDelegate.m
//  book-reader
//
//  Created by ENZO YANG on 13-4-1.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "AppDelegate.h"


@interface AA : NSObject
@property (strong) NSString *string;
@end

@implementation AA
- (void)dealloc {
    NSLog(@"%@ dealloc", self.string);
}
@end

@interface AppDelegate()

@property (copy) void (^aBlock)(int);

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    char c = 'a';
    NSString *result = [[NSString alloc] initWithBytes:&c length:0 encoding:NSUTF8StringEncoding];
    NSLog(@"result %@ %@", result, [result isKindOfClass:[NSString class]] ? @"YES" : @"NO");
    
    NSString *st = [[NSString alloc] initWithFormat:@"xxx %d", 1];;
    NSString * __weak st2 = st;
    st = nil;
    NSLog(@"st : %@", st2);
    
    st = @"xxxyyy";
    st2 = st;
    st = nil;
    NSLog(@"st : %@", st2);
    
    AA * __strong aa_weak_holder = [[AA alloc] init];
    aa_weak_holder.string = @"weak";
    AA * __weak aa_weak = aa_weak_holder;
    aa_weak_holder = nil;
    NSLog(@"aa : %@", aa_weak);
    
    CFBridgingRetain
    
    [self testArcSimple];

    return YES;
}

- (void)testArcSimple {
    AA * __strong aa_weak_holder = [[AA alloc] init];
    AA * __weak aa_weak = aa_weak_holder;
    aa_weak_holder.string = @"aa_weak";
    
    void (^aBlock)(void) = ^(){
        NSLog(@"block : %@", aa_weak.string);
    };
    
    aa_weak_holder = nil;
    aBlock();
}

- (void)testArc {
    __block AA *aa_block = [AA new];
    AA * __strong aa_weak_holder = [[AA alloc] init];
    AA * __weak aa_weak = aa_weak_holder;
    AA * __strong aa_strong = [AA new];
    
    aa_block.string = @"aa_block";
    aa_weak_holder.string = @"aa_weak";
    aa_strong.string = @"aa_strong";
    
    void (^aBlock)(int) = ^(int num){
        NSLog(@"block%d : %@", num, aa_block.string);
        NSLog(@"block%d : %@", num, aa_weak.string);
        NSLog(@"block%d : %@", num, aa_strong.string);
    };
    
    self.aBlock = aBlock;
    
    aa_weak_holder = nil;
    self.aBlock(1);
    
    aa_block = nil;
    self.aBlock(2);
    
    [self performSelectorOnMainThread:@selector(Arc2) withObject:nil waitUntilDone:NO];
}

- (void)Arc2 {
    self.aBlock(3);
    self.aBlock = nil;
}


@end
