//
//  YMMLabel.m
//  ContactsDemo
//
//  Created by myang on 2018/12/1.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "YMMLabel.h"

@implementation YMMLabel

- (id) initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.verTextAlignment = YMMTextAlignmentMiddle;
    }
    
    return self;
}

- (void) setVerTextAlignment:(YMMTextAlignment)verTextAlignment {
    _verTextAlignment = verTextAlignment;
    [self setNeedsDisplay];
}

// calculate text rect by YMMTextAlignment.
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    
    switch (_verTextAlignment) {
        case YMMTextAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case YMMTextAlignmentMiddle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2;
            break;
        case YMMTextAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        default:
            textRect.origin.y = bounds.origin.y;
            break;
    }
    
    return textRect;
}

- (void) drawTextInRect:(CGRect)rect {
    CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:textRect];
}


@end
