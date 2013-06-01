//
//  ReadController.m
//  book-reader
//
//  Created by YANG ENZO on 13-5-31.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "ReadController.h"
#import "Paginater.h"
#import "PageView.h"
#import "Typesetting.h"

@interface ReadController ()<UIScrollViewDelegate>

@end

#define kPageViewWidthInset  20.0f
#define kPageViewHeightInset 25.0f

typedef enum {
    kLeftPage = 0,
    kMiddlePage,
    kRightPage,
    kPagePositionCount
} PagePosition;

@implementation ReadController {
    RandomAccessText    *_text;
    Paginater           *_paginater;
    CGSize              _pageSize;
    UIFont              *_font;
    
    CGPathRef           _pageRectPath;
    
    NSMutableArray      *_pageViews;
    CGRect              _pageRects[kPagePositionCount];
    
    NSUInteger          _currentPageNo;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *utf16LEGuWenPath = [NSHomeDirectory() stringByAppendingPathComponent:@"古文观止-utf16le.txt"];
        NSLog(@"%@", utf16LEGuWenPath);
        _text = [[RandomAccessText alloc] initWithPath:utf16LEGuWenPath encoding:NSUTF16LittleEndianStringEncoding];
        
        CGSize applicationSize = [UIScreen mainScreen].applicationFrame.size;
        _pageSize   = CGSizeMake(applicationSize.width - kPageViewWidthInset * 2, applicationSize.height - kPageViewHeightInset * 2);
        _font       = [UIFont systemFontOfSize:17];
        _paginater  = [[Paginater alloc] initWithRandomAccessText:_text size:_pageSize font:_font];
        
        _pageRectPath = CGPathCreateWithRect(CGRectMake(0, 0, _pageSize.width, _pageSize.height), NULL);
        
        _pageRects[kLeftPage]   = CGRectMake(kPageViewWidthInset, kPageViewHeightInset, _pageSize.width, _pageSize.height);
        _pageRects[kMiddlePage] = CGRectMake(kPageViewWidthInset * 3 + _pageSize.width, kPageViewHeightInset, _pageSize.width, _pageSize.height);
        _pageRects[kRightPage]  = CGRectMake(kPageViewWidthInset * 5 + _pageSize.width * 2, kPageViewHeightInset, _pageSize.width, _pageSize.height);
        
        NSLog(@"w:%f, h:%f", [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![_paginater isPaginated]) {
        [_paginater paginate];
    }
    
    if (!_pageViews) {
        _pageViews = [@[[[PageView alloc] initWithFrame:_pageRects[kLeftPage]],
                      [[PageView alloc] initWithFrame:_pageRects[kMiddlePage]],
                      [[PageView alloc] initWithFrame:_pageRects[kRightPage]]]
                      mutableCopy];
    }
    
    for (PageView *v in _pageViews) {
        [self.pageScroller addSubview:v];
    }
    
    [self _jumpToPage:5];
}

- (void)_jumpToPage:(NSUInteger)page {
    int pageLimit = 3;
    int totalPages = _paginater.pageCount;
    int beginPage = page;
    // 这里还不能确定scrollview的大小，只能自己计算
    CGFloat scrollerWidth  = kPageViewWidthInset * 2 + _pageSize.width;
    CGFloat scrollerHeight = kPageViewHeightInset * 2 + _pageSize.height;
    
    // 0页
    if (totalPages == 0) return;
    
    if (page >= totalPages) page = totalPages - 1;
    
    if (totalPages < 3) {
        // 不够3页
        pageLimit   = totalPages;
        beginPage   = 0;
        [self.pageScroller setContentSize:CGSizeMake(scrollerWidth * totalPages, scrollerHeight)];
        [self.pageScroller setContentOffset:CGPointMake(scrollerWidth * page, 0)];
    } else if (page == 0) {
        // 首页
        beginPage = 0;
        [self.pageScroller setContentSize:CGSizeMake(scrollerWidth * 3, scrollerHeight)];
        [self.pageScroller setContentOffset:CGPointZero];
    } else if (page == (totalPages - 1)) {
        // 末页
        beginPage = page - 2;
        [self.pageScroller setContentSize:CGSizeMake(scrollerWidth * 3, scrollerHeight)];
        [self.pageScroller setContentOffset:CGPointMake(scrollerWidth * 2, 0)];
    } else {
        // 中间
        beginPage = page - 1;
        [self.pageScroller setContentSize:CGSizeMake(scrollerWidth * 3, scrollerHeight)];
        [self.pageScroller setContentOffset:CGPointMake(scrollerWidth, 0)];
    }
    
    // 清空
    for (PageView *v in _pageViews) {
        [v setCTFrame:NULL pageNumber:0];
    }
    
    NSUInteger  textBegin = [_paginater offsetOfPage:beginPage];
    NSRange     tailRange = [_paginater rangeOfPage:beginPage + pageLimit - 1];
    NSRange     textRange = NSMakeRange(textBegin, tailRange.location + tailRange.length - textBegin);
    
    NSString *text = [_text textInRange:textRange];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:text];
    [attrString setAttributes:[Typesetting stringAttrWithFont:_font] range:NSMakeRange(0, attrString.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    NSUInteger next = 0;
    for (int i=0; i<pageLimit; ++i) {
        PageView *pageView = _pageViews[i];
        pageView.frame = _pageRects[i];
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(next, 0), _pageRectPath, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        next = range.location + range.length;
        [pageView setCTFrame:frame pageNumber:beginPage+i];
        CFRelease(frame);
    }
    CFRelease(frameSetter);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [self prevPage];
    } else if (scrollView.contentOffset.x == 2* CGRectGetWidth(scrollView.bounds)) {
        [self nextPage];
    }
}

- (void)prevPage {
    // 这时scrollview显示leftPage
    PageView *leftPage = _pageViews[kLeftPage];
    NSUInteger curPageNumber = [leftPage pageNumber];
    if (curPageNumber == 0) return;
    
    PageView *rightPage     = _pageViews[kRightPage];
    _pageViews[kRightPage]  = _pageViews[kMiddlePage];
    _pageViews[kMiddlePage] = _pageViews[kLeftPage];
    _pageViews[kLeftPage]   = rightPage;
    
    for (int i=0; i<kPagePositionCount; ++i) {
        PageView *pageView = _pageViews[i];
        pageView.frame = _pageRects[i];
    }
    
    [_pageScroller setContentOffset:CGPointMake(CGRectGetWidth(_pageScroller.bounds), 0)];
    
    [self loadContentOfPage:curPageNumber-1 inPageView:_pageViews[kLeftPage]];
    
}

- (void)nextPage {
    // 这时scrollview显示rightPage
    PageView *rightPage = _pageViews[kRightPage];
    NSUInteger curPageNumber = [rightPage pageNumber];
    if (curPageNumber == [_paginater pageCount] - 1) return;
    
    PageView *leftPage      = _pageViews[kLeftPage];
    _pageViews[kLeftPage]   = _pageViews[kMiddlePage];
    _pageViews[kMiddlePage] = _pageViews[kRightPage];
    _pageViews[kRightPage]  = leftPage;
    
    for (int i=0; i<kPagePositionCount; ++i) {
        PageView *pageView = _pageViews[i];
        pageView.frame = _pageRects[i];
    }
    
    [_pageScroller setContentOffset:CGPointMake(CGRectGetWidth(_pageScroller.bounds), 0)];
    
    [self loadContentOfPage:curPageNumber+1 inPageView:_pageViews[kRightPage]];
}

- (void)loadContentOfPage:(NSUInteger)pageNumber inPageView:(PageView *)pageView {
    NSRange  textRange = [_paginater rangeOfPage:pageNumber];
    NSString *text = [_text textInRange:textRange];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString  alloc] initWithString:text];
    [attrString setAttributes:[Typesetting stringAttrWithFont:_font] range:NSMakeRange(0, attrString.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), _pageRectPath, NULL);
    [pageView setCTFrame:frame pageNumber:pageNumber];
    CFRelease(frame);
    CFRelease(frameSetter);
}

- (void)dealloc {
    CFRelease(_pageRectPath);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
