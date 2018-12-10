//
//  YMMLabel.h
//  ContactsDemo
//
//  Created by myang on 2018/12/1.
//  Copyright © 2018年 myang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YMMTextAlignment) {
    YMMTextAlignmentTop,
    YMMTextAlignmentMiddle,
    YMMTextAlignmentBottom,
};

@interface YMMLabel : UILabel

@property (nonatomic, assign) YMMTextAlignment verTextAlignment;

@end
