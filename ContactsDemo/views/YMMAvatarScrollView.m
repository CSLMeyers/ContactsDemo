//
//  YMMContactContainer.m
//  ContactsDemo
//
//  Created by myang on 2018/11/28.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "YMMAvatarScrollView.h"

#define SELECTEDCOLOR [UIColor colorWithRed:202.0/255 green:223.0/255 blue:244.0/255 alpha:1.0].CGColor
//#define SELECTEDCOLOR [UIColor greenColor].CGColor
#define NORMALCOLOR [UIColor clearColor].CGColor

@interface YMMAvatarScrollView() <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *lastSelectedView;

@end

@implementation YMMAvatarScrollView

- (void) layoutSubviews {
    __block CGFloat x = (self.frame.size.width - AVATAR_DIAMETER) / 2.0;
    CGFloat y = (self.frame.size.height - AVATAR_DIAMETER) / 2.0;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGRect frame = CGRectMake(x, y, AVATAR_DIAMETER, AVATAR_DIAMETER);
        view.frame = frame;
        
        x += AVATAR_DIAMETER + AVATAR_PADDING;
    }];
}

#pragma mark private

- (void) chooseContact:(UIView *) sender atIndex:(NSInteger)index {
    if (sender == self.lastSelectedView) {
        sender.layer.borderColor = SELECTEDCOLOR;
        return;
    }
    
    self.lastSelectedView.layer.borderColor = NORMALCOLOR;
    
    self.lastSelectedView = sender;
    CGFloat newOffsetX = sender.center.x - self.frame.size.width * 0.5;
    if (newOffsetX < 0.0) {
        newOffsetX = 0.0;
    }
    if (newOffsetX > self.contentSize.width - self.frame.size.width) {
        newOffsetX = self.contentSize.width - self.frame.size.width;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        if (fabs(newOffsetX - self.contentOffset.x) > (AVATAR_DIAMETER + AVATAR_PADDING) * 0.5) {
            [self setContentOffset:CGPointMake(newOffsetX, 0)];
        }
    } completion:^(BOOL finished) {
        // add animation when completion block is called
        sender.layer.borderColor = SELECTEDCOLOR;
        
        CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        borderAnimation.fromValue = (id)NORMALCOLOR;
        borderAnimation.toValue = (id)SELECTEDCOLOR;
        borderAnimation.duration = 0.5f;
        [sender.layer addAnimation:borderAnimation forKey:nil];
    }];
}

- (void) tapAtContact:(UIView *)view {
    NSInteger index = [self indexOfView:view];
    if (index == NSNotFound) {
        return;
    }
    
    [self chooseContact:view atIndex:index];
    
    // call delegate when clicking...
    if ([self.avatarDelegate respondsToSelector:@selector(avatarContainer:didTapItem:atIndex:)]) {
        [self.avatarDelegate avatarContainer:self didTapItem:view atIndex:index];
    }
}

#pragma mark public

- (void)setContactAvatar:(NSMutableArray<UIImage *> *)contactAvatar {
    _contactAvatar = [contactAvatar copy];
    
    [_contactAvatar enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *imageButton = [[UIButton alloc] init];
        [imageButton setImage:image forState:UIControlStateNormal];
        imageButton.layer.cornerRadius = AVATAR_DIAMETER / 2.0;
        [imageButton addTarget:self action:@selector(tapAtContact:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.layer.borderColor = NORMALCOLOR;
        imageButton.layer.borderWidth = 2.0;
        
        [self addSubview:imageButton];
        [self.itemViews addObject:imageButton];
    }];
    
    NSAssert([self.itemViews count] == [_contactAvatar count], @"itemViews count must match contactAvatars count.");
    
    self.contentSize = CGSizeMake((AVATAR_DIAMETER + AVATAR_PADDING) * (_contactAvatar.count - 1) + self.frame.size.width, 0);
}

- (void) chooseContactAt:(NSUInteger) index{
    if (index >= self.itemViews.count) {
        NSLog(@"index out of count !");
        return;
    }
    
    [self chooseContact:self.itemViews[index] atIndex:index];
}

@end
