//
//  YMMContactContainer.h
//  ContactsDemo
//
//  Created by myang on 2018/11/28.
//  Copyright © 2018年 myang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMMBaseScrollView.h"

#define AVATAR_DIAMETER     64.0
#define AVATAR_PADDING      10.0

@protocol YMMAvatarScrollViewDelegate <NSObject>

- (void)avatarContainer:(YMMBaseScrollView *)avatarContainer didTapItem:(UIView *)view atIndex:(NSInteger) index;

@end

@interface YMMAvatarScrollView : YMMBaseScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray<UIImage *> *contactAvatar;
@property (nonatomic, weak) id<YMMAvatarScrollViewDelegate> avatarDelegate;

@end
