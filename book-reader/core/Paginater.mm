//
//  Paginater.m
//  book-reader
//
//  Created by YANG ENZO on 13-5-25.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "Paginater.h"
#include <vector>
#import <CoreText/CoreText.h>

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
    }
    return self;
}

- (BOOL)isPaginated {
    return _pageOffsets.size() == 0;
}


- (void)paginate {
    const int charsPerLoad = 50000;
    
    NSString *buffer = [_text textInRange:NSMakeRange(0, charsPerLoad)];
    NSAttributedString *attrString = [[NSAttributedString  alloc] initWithString:buffer];
    buffer = nil; // 马上释放
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
            attrString = [[NSAttributedString alloc] initWithString:buffer];
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
}

- (NSUInteger)pageCount {
    return _pageOffsets.size();
}

- (NSUInteger)offsetOfPage:(NSUInteger)page {
    return _pageOffsets[page];
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

@end
