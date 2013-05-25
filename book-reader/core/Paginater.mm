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
}
- (id)initWithRandomAccessText:(RandomAccessText *)text font:(UIFont *)font {
    self = [super init];
    if (self) {
        _text = text;
        _font = font;
    }
    return self;
}

- (BOOL)isPaginated {
    return _pageOffsets.size() == 0;
}


- (void)paginate {
    const int charsPerLoad = 100000;
    
    NSString *buffer = [_text textInRange:NSMakeRange(0, charsPerLoad)];
    int bufferTailOffset = buffer.length;
    int currentOffset = 0;
    
    while (bufferTailOffset < _)
    
    
    
    // 用属性化字符串创建框架排版器
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(CFAttributedStringRef string)
    
    // 用整个字符串（CFRange(0, 0)）创建一个可以装进填充路径的框架
    CTFrameRef
    frame = CTFramesetterCreateFrame(framesetter,
                                     CFRangeMake(0, 0),
                                     path,
                                     NULL);

}

- (NSUInteger)pageCount {
    return _pageOffsets.size();
}

- (NSUInteger)offsetOfPage:(NSUInteger)page {
    return _pageOffsets[page];
}

@end
