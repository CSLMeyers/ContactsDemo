//
//  YMMContactModel.m
//  ContactsDemo
//
//  Created by myang on 2018/11/28.
//  Copyright © 2018年 myang. All rights reserved.
//

#import "YMMContactModel.h"

@implementation YMMContactModel

- (instancetype)init {
    if (self = [super init]) {
        _first_name = [NSString string];
        _last_name = [NSString string];
        _avatar_filename = [NSString string];
        _title = [NSString string];
        _introduction = [NSString string];
    }
    
    return self;
}

+ (instancetype)createModelWithDict:(NSDictionary *)dict {
    YMMContactModel *model = [[self alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@ did not find !", key);
    return;
}

@end
