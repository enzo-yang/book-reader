//
//  FileUtil.h
//  book-reader
//
//  Created by ENZO YANG on 13-5-29.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

+ (NSString*)documentPath;
+ (NSString*)libraryPath;

// 序列化对象到文件中
+ (void)serializeObject:(NSObject*)obj toPath:(NSString*)path;

// 从文件中加载对象
+ (NSObject*)deserializeObjectAtPath:(NSString*)path;

// 文件夹
+ (BOOL)isFolderAtPath:(NSString *)path;
+ (BOOL)createFolderAtPath:(NSString *)path; // WithIntermediateDirectory = YES

// 不让icloud备份
+ (void) addSkipBackupAttributeToFile:(NSString*)path;
+ (void) addSkipBackupAttributeToFileUrl:(NSURL*)url;
+ (void) addSkipBackupAttributeToFilesUnderFolder:(NSString*)folderPath;

// 取得文件的大小
+ (int)fileSizeAtPath:(NSString*)path;

+ (BOOL)deleteFile:(NSString *)path;

@end
