//
//  YMMBriefItemView.m
//  ContactsDemo
//
//  Created by myang on 2018/11/29.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "YMMBriefItemView.h"

#define ABOUTSTRING @"About me";

@implementation YMMBriefItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setModel:(YMMContactModel *)model {
    if (![model isKindOfClass:[YMMContactModel class]]) {
        return;
    }
    
    // combine first name and last name.
    NSString *name = [model.first_name stringByAppendingFormat:@"%@%@", @" ", model.last_name];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc] initWithString:name];
    
    [attrName addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24.0] range:NSMakeRange(0, model.first_name.length)];
    [attrName addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0] range:NSMakeRange(model.first_name.length + 1, model.last_name.length)];
    
    self.nameLabel.attributedText = attrName;
    
    self.titleLabel.text = model.title;
    
    self.introductionLabel.text = model.introduction;
}

- (void) layoutSubviews {
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.aboutLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.introductionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *nameCst1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[name]|" options:0 metrics:nil views:@{@"name":self.nameLabel}];
    [self addConstraints:nameCst1];
    
    NSArray *titleCst1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[title]|" options:0 metrics:nil views:@{@"title":self.titleLabel}];
    
    [self addConstraints:titleCst1];
    
    
    NSArray *aboutCst1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[about]|" options:0 metrics:nil views:@{@"about":self.aboutLabel}];
    [self addConstraints:aboutCst1];

    NSArray *introductionCst1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[intro]|" options:0 metrics:nil views:@{@"intro":self.introductionLabel}];
    [self addConstraints:introductionCst1];
    
    NSArray *verCst = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[name(40)]-4-[title(12)]-24-[about(24)]-4-[intro]|" options:0 metrics:nil views:@{@"name":self.nameLabel,@"title":self.titleLabel,@"about":self.aboutLabel,@"intro":self.introductionLabel}];
    [self addConstraints:verCst];
}

#pragma mark lazyLoad

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        _nameLabel = label;
        
        [self addSubview:_nameLabel];
    }
    
    return _nameLabel;
}

- (UILabel *) titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.enabled = NO;
        label.font = [UIFont systemFontOfSize:14.0];
        _titleLabel = label;
        
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *) aboutLabel {
    if (!_aboutLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:14.0];
        label.text = ABOUTSTRING;
        _aboutLabel = label;
        
        [self addSubview:_aboutLabel];
    }
    
    return _aboutLabel;
}

- (UILabel *) introductionLabel {
    if (!_introductionLabel) {
        YMMLabel *label = [[YMMLabel alloc] init];
        label.numberOfLines = 0;
        label.enabled = NO;
        label.font = [UIFont systemFontOfSize:14.0];
        label.verTextAlignment = YMMTextAlignmentTop;
        _introductionLabel = label;
        
        [self addSubview:_introductionLabel];
    }
    
    return _introductionLabel;
}

@end
