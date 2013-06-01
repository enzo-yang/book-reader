//
//  PageView.m
//  book-reader
//
//  Created by YANG ENZO on 13-5-31.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "PageView.h"

@implementation PageView {
    CTFrameRef _ctFrame;
    NSUInteger _pageNumber;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
//        CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
        self.transform = transform;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
    if (_ctFrame) CFRelease(_ctFrame);
}

- (void)setCTFrame:(CTFrameRef)ctFrame pageNumber:(NSUInteger)pageNumber {
    _pageNumber = pageNumber;
    if (ctFrame == _ctFrame) return;
    if (_ctFrame) CFRelease(_ctFrame);
    if (ctFrame)
        _ctFrame = CFRetain(ctFrame);
    else
        _ctFrame = NULL;
    
    [self setNeedsDisplay];
}

- (NSUInteger)pageNumber {
    return _pageNumber;
}

- (void)drawRect:(CGRect)rect {
    if (!_ctFrame) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CTFrameDraw(_ctFrame, context);
}

@end
