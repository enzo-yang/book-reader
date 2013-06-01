//
//  PageView.h
//  book-reader
//
//  Created by YANG ENZO on 13-5-31.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface PageView : UIView

- (void)setCTFrame:(CTFrameRef)ctFrame pageNumber:(NSUInteger)pageNumber;

- (NSUInteger)pageNumber;

@end
