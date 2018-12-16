//
//  YMMBriefItemView.h
//  ContactsDemo
//
//  Created by myang on 2018/11/29.
//  Copyright © 2018年 myang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMMLabel.h"
#import "YMMContactModel.h"

@interface YMMBriefItemView : UIView

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *aboutLabel;
@property (nonatomic) YMMLabel *introductionLabel;

@property (nonatomic) YMMContactModel *model;

@end

