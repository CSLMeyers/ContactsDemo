//
//  YMMContactBriefView.m
//  ContactsDemo
//
//  Created by myang on 2018/11/29.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "YMMBriefScrollView.h"
#import "YMMBriefItemView.h"

@interface YMMBriefScrollView() <UIScrollViewDelegate>

@end

@implementation YMMBriefScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _models = [NSMutableArray array];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void) layoutSubviews {
    __block CGFloat contentY = 0.0;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.frame = CGRectMake(0, contentY, self.frame.size.width, self.frame.size.height);
        [view layoutIfNeeded];
        
        contentY += view.frame.size.height;
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    
    NSInteger tapIndex = [self indexOfTap:location];
    if (tapIndex != NSNotFound) {
        [self chooseContactAt:tapIndex];
        
        // call delegate when tapping...
        if ([self.briefViewDelegate respondsToSelector:@selector(briefView:didTapItem:atIndex:)]) {
            [self.briefViewDelegate briefView:self didTapItem:self.itemViews[tapIndex] atIndex:tapIndex];
        }
    }
}

// model to view
- (void)setModels:(NSMutableArray<YMMContactModel *> *)models {
    _models = [models copy];
    
    [_models enumerateObjectsUsingBlock:^(YMMContactModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        YMMBriefItemView *briefView = [[YMMBriefItemView alloc] init];
        // combine first name and last name.
        NSString *name = [model.first_name stringByAppendingFormat:@"%@%@", @" ", model.last_name];
        NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:name];
        
        [attrName addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24.0] range:NSMakeRange(0, model.first_name.length)];
        [attrName addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0] range:NSMakeRange(model.first_name.length + 1, model.last_name.length)];
        
        briefView.nameLabel.attributedText = attrName;
        
        briefView.titleLabel.text = model.title;
        briefView.titleLabel.enabled = NO;
        briefView.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        briefView.aboutLabel.font = [UIFont boldSystemFontOfSize:14.0];
        
        briefView.introductionLabel.text = model.introduction;
        briefView.introductionLabel.numberOfLines = 0;
        briefView.introductionLabel.enabled = NO;
        briefView.introductionLabel.font = [UIFont systemFontOfSize:14.0];
        briefView.introductionLabel.verTextAlignment = YMMTextAlignmentTop;
//        briefView.introductionLabel.verTextAlignment = YMMTextAlignmentMiddle;
//        briefView.introductionLabel.verTextAlignment = YMMTextAlignmentBottom;
        
        [self.itemViews addObject:briefView];
        [self addSubview:briefView];
    }];
    
    NSAssert([self.itemViews count] == [_models count], @"itemViews count must match models count.");
    
    self.contentSize = CGSizeMake(0, self.frame.size.height * self.models.count);
}

- (void) chooseContactAt:(NSUInteger)index {
    if (index >= self.itemViews.count) {
        NSLog(@"index out of count !");
        return;
    }
    
    UIView *view = self.itemViews[index];
    
    CGFloat newOffsetY= view.center.y - self.frame.size.height * 0.5;
    if (newOffsetY < 0.0) {
        newOffsetY = 0.0;
    }
    
    if (newOffsetY > self.contentSize.height - self.frame.size.height) {
        newOffsetY = self.contentSize.height - self.frame.size.height;
    }
    
    if (fabs(newOffsetY - self.contentOffset.y) < self.frame.size.height * 0.5) {
        return;
    }

    [UIView animateWithDuration:0.25 animations:^{
        [self setContentOffset:CGPointMake(0, newOffsetY)];
    }];
}

@end
