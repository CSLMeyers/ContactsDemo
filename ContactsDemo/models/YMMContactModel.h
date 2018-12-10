//
//  YMMContactModel.h
//  ContactsDemo
//
//  Created by myang on 2018/11/28.
//  Copyright © 2018年 myang. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define contactFirstName first_name
//#define ontactLastName last_name
//#define contactAvatar avatar_filename
//#define contactTitle title
//#define contactIntroduction introduction

@interface YMMContactModel : NSObject

@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *avatar_filename;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *introduction;

+ (instancetype) createModelWithDict:(NSDictionary *)dict;

@end

