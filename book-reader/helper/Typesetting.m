//
//  Typesetting.m
//  book-reader
//
//  Created by YANG ENZO on 13-6-1.
//  Copyright (c) 2013年 SideTrip. All rights reserved.
//

#import "Typesetting.h"

@implementation Typesetting

+ (NSDictionary *)stringAttrWithFont:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = font.pointSize / 2;
    
    return @{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font};
}

@end
