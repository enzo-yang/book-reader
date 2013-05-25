//
//  Paginater.h
//  book-reader
//
//  Created by YANG ENZO on 13-5-25.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomAccessText.h"

@interface Paginater : NSObject

- (id)initWithRandomAccessText:(RandomAccessText *)text size:(CGSize)size font:(UIFont *)font;

- (BOOL)isPaginated;
- (void)paginate;

- (NSUInteger)pageCount;
- (NSUInteger)offsetOfPage:(NSUInteger)page;
- (NSString *)stringOfPage:(NSUInteger)page;

@end
