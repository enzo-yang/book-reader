//
//  FileUtil.m
//  book-reader
//
//  Created by ENZO YANG on 13-5-29.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "FileUtil.h"
#import <sys/xattr.h>

@implementation FileUtil

+ (NSString*)documentPath {
    static NSString *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *pathArray =  nil;
        pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = pathArray[0];
    });
    return path;
}

+ (NSString*)libraryPath {
    static NSString *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *pathArray =  nil;
        pathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        path = pathArray[0];
    });
    return path;
}


+ (void)serializeObject:(NSObject*)obj toPath:(NSString*)path {
    if (obj == nil) {
        [self deleteFile:path];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [data writeToFile:path atomically:YES];
}

+ (NSObject*)deserializeObjectAtPath:(NSString*)path {
    // 如果文件不存在 则 返回nil
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSObject *obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return obj;
}

+ (BOOL)isFolderAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary *attrDict = [fileManager attributesOfItemAtPath:path error:&error];
    if (!attrDict || ![attrDict[NSFileType] isEqualToString:NSFileTypeDirectory]) {
        return NO;
    }
    return YES;
}

+ (BOOL)createFolderAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        return [fileManager createDirectoryAtPath:path
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:NULL];
    }
    return YES;
}

+ (void) addSkipBackupAttributeToFile:(NSString*)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    [self addSkipBackupAttributeToFileUrl:url];
}

+ (void) addSkipBackupAttributeToFileUrl:(NSURL*)url {
    u_int8_t b = 1;
    setxattr([[url path] fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

+ (void) addSkipBackupAttributeToFilesUnderFolder:(NSString*)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *elementArray = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString* elementName in elementArray) {
        NSLog(@"%@", elementName);
        NSString *aPath = [folderPath stringByAppendingPathComponent:elementName];
        if ([self isFolderAtPath:aPath]) {
            [self addSkipBackupAttributeToFilesUnderFolder:aPath];
        } else {
            [self addSkipBackupAttributeToFile:aPath];
        }
    }
}

+ (int)fileSizeAtPath:(NSString *)path {
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NO];
    if (fileAttributes == nil) return 0;
    NSNumber *nFileSize = fileAttributes[NSFileSize];
    return (int)[nFileSize longLongValue];
}

+ (BOOL)deleteFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

@end
