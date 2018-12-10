//
//  YMMBaseScrollView.h
//  ContactsDemo
//
//  Created by myang on 2018/11/29.
//  Copyright © 2018年 myang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMMBaseScrollView : UIScrollView

// use itemViews to enum contactView because self.subviews may have other views.
@property (nonatomic, strong) NSMutableArray *itemViews;

- (NSInteger)indexOfTap:(CGPoint)location;
- (NSInteger)indexOfView:(UIView *)view;

- (void) chooseContactAt:(NSUInteger) index;
- (BOOL) deleteContactAt:(NSUInteger)index;
- (BOOL) addContact:(id)model at:(NSUInteger)index;
- (BOOL) addContact:(id)model;

// animation.
- (void) layoutSubviewsWithAnimations;

@end
