//
//  YMMContactBriefView.h
//  ContactsDemo
//
//  Created by myang on 2018/11/29.
//  Copyright © 2018年 myang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMMBaseScrollView.h"
#import "YMMContactModel.h"

@protocol YMMBriefScrollViewDelegate <NSObject>

- (void)briefView:(YMMBaseScrollView *)briefView didTapItem:(UIView *)view atIndex:(NSInteger) index;

@end

@interface YMMBriefScrollView : YMMBaseScrollView

@property (nonatomic, copy) NSMutableArray<YMMContactModel *> *models;
@property (nonatomic, weak) id<YMMBriefScrollViewDelegate> briefViewDelegate;

@end

