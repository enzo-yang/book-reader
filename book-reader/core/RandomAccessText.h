//
//  RandomAccessText.h
//  book-reader
//
//  Created by YANG ENZO on 13-5-25.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomAccessText : NSObject
- (id)initWithPath:(NSString *)path encoding:(NSStringEncoding)encoding;

- (NSInteger)length; // 单位：字符

- (NSString *)textInRange:(NSRange)range;

- (NSString *)path;

@end
