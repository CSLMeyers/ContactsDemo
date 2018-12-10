//
//  YMMContactModel.m
//  ContactsDemo
//
//  Created by myang on 2018/11/28.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "YMMContactModel.h"

@implementation YMMContactModel

+ (instancetype)createModelWithDict:(NSDictionary *)dict {
    YMMContactModel *model = [[self alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
