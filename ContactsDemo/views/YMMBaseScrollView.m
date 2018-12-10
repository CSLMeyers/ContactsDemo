//
//  YMMBaseScrollView.m
//  ContactsDemo
//
//  Created by myang on 2018/11/29.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "YMMBaseScrollView.h"

@interface YMMBaseScrollView ()



@end

@implementation YMMBaseScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark private

- (void)animateSpringWithView:(UIView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED
    [UIView animateWithDuration:0.5
                          delay:(initDelay + idx*0.1f)
         usingSpringWithDamping:10
          initialSpringVelocity:50
                        options:0
                     animations:^{
                         view.layer.transform = CATransform3DIdentity;
                         view.alpha = 1;
                     }
                     completion:nil];
#endif
}


#pragma mark public

- (void) layoutSubviewsWithAnimations {
    [self layoutIfNeeded];
    CGFloat initDelay = 0.1f;
    [self.itemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        
        [self animateSpringWithView:view idx:idx initDelay:initDelay];
    }];
}


- (NSInteger)indexOfTap:(CGPoint)location {
    __block NSUInteger index = NSNotFound;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(view.frame, location)) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (NSInteger)indexOfView:(UIView *)view {
    __block NSUInteger index = NSNotFound;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIView *itemView, NSUInteger idx, BOOL *stop) {
        if (view == itemView) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (NSMutableArray *)itemViews {
    if (!_itemViews) {
        _itemViews = [NSMutableArray array];
    }
    
    return _itemViews;
}

// override by subclass
- (void)chooseContactAt:(NSUInteger)index{
    
}

- (BOOL)addContact:(id)model {
    return [self addContact:model at:_itemViews.count];
}

- (BOOL)addContact:(id)model at:(NSUInteger)index {
    
    return false;
}

- (BOOL) deleteContactAt:(NSUInteger)index {
    
    return false;
}

@end
