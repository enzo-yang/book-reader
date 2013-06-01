//
//  Paginater.m
//  book-reader
//
//  Created by YANG ENZO on 13-5-25.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "Paginater.h"
#include <vector>
#include <fstream>
#include <iostream>
#import <CoreText/CoreText.h>

#import "Typesetting.h"

using namespace std;

@implementation Paginater {
    vector<NSUInteger> _pageOffsets;
    
    UIFont *_font;
    RandomAccessText *_text;
    CGSize _size;
}
- (id)initWithRandomAccessText:(RandomAccessText *)text size:(CGSize)size font:(UIFont *)font {
    self = [super init];
    if (self) {
        _text = text;
        _font = font;
        _size = size;
        [self load];
    }
    return self;
}


- (BOOL)isPaginated {
    return _pageOffsets.size() != 0;
}


- (void)paginate {
    const int charsPerLoad = 50000;
    
    NSString *buffer = [_text textInRange:NSMakeRange(0, charsPerLoad)];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:buffer];
    buffer = nil; // 马上释放
    
    NSDictionary *strAttr = [Typesetting stringAttrWithFont:_font];
    [attrString setAttributes:strAttr range:NSMakeRange(0, attrString.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, _size.width, _size.height), NULL);
    
    _pageOffsets.clear();
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            ++samePlaceRepeatCount;
        } else {
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (_pageOffsets.size() == 0) {
                _pageOffsets.push_back(currentOffset);
            } else {
                int lastOffset = _pageOffsets.back();
                if (lastOffset != currentOffset) {
                    _pageOffsets.push_back(currentOffset);
                }
            }
            break;
        }
        
        _pageOffsets.push_back(currentOffset);
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        
        if ((range.location + range.length) != attrString.length) {
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else if ((range.location + range.length) == attrString.length && (currentOffset + range.length) != [_text length]) {
            // 加载后面的
            CFRelease(frame); frame = NULL;
            CFRelease(frameSetter);
            
            _pageOffsets.pop_back();
            buffer = [_text textInRange:NSMakeRange(currentOffset, charsPerLoad)];
            attrString = [[NSMutableAttributedString alloc] initWithString:buffer];
            [attrString setAttributes:strAttr range:NSMakeRange(0, attrString.length)];
            buffer = nil;
            
            currentInnerOffset = 0;
            
            frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    
    [self save];
}

- (NSUInteger)pageCount {
    return _pageOffsets.size();
}

- (NSUInteger)offsetOfPage:(NSUInteger)page {
    if (page >= [self pageCount]) return NSNotFound;
    return _pageOffsets[page];
}

- (NSRange)rangeOfPage:(NSUInteger)page {
    if (page >= _pageOffsets.size()) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    if (page < _pageOffsets.size() - 1) {
        return NSMakeRange(_pageOffsets[page], _pageOffsets[page + 1] - _pageOffsets[page]);
    }
    
    return NSMakeRange(_pageOffsets[page], _text.length - _pageOffsets[page]);
}

- (NSString *)stringOfPage:(NSUInteger)page {
    if (page >= [self pageCount]) return @"";
    
    NSUInteger head = _pageOffsets[page];
    
    NSUInteger tail = _text.length;
    if (page+1 < [self pageCount]) {
        tail = _pageOffsets[page+1];
    }
    
    return [_text textInRange:NSMakeRange(head, tail-head)];
}

- (NSString *)pageInfoFileName {
    return [NSString stringWithFormat:@"page-info-%d-%d-%f-%@.txt", (int)_size.width, (int)_size.height, _font.pointSize, [_font.fontName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)pageInfoFilePath {
    return [[_text.path stringByDeletingLastPathComponent] stringByAppendingPathComponent:[self pageInfoFileName]];
}

- (void)save {
    ofstream stream([[self pageInfoFilePath] UTF8String]);
    NSLog(@"%@", [self pageInfoFilePath]);
    if (stream.is_open()) {
        stream << [self pageCount] << endl;
        for (vector<NSUInteger>::iterator iter = _pageOffsets.begin(); iter != _pageOffsets.end(); ++iter) {
            stream << *iter << endl;
        }
    }
    stream.close();
}

- (void)load {
    ifstream stream([[self pageInfoFilePath] UTF8String]);
    NSLog(@"%@", [self pageInfoFilePath]);
    vector<NSUInteger> offsets;
    if (stream.is_open()) {
        NSUInteger cnt;
        stream >> cnt;
        if (cnt && stream.good()) {
            int tmp = 0;
            for (int i=0; i<cnt && !stream.eof(); ++i) {
                stream >> tmp;
                offsets.push_back(tmp);
            }
        }
    }
    stream.close();

    _pageOffsets.swap(offsets);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"size:{%f, %f}, font: %@, pages: %d", _size.width, _size.height, _font, [self pageCount]];
}

@end
