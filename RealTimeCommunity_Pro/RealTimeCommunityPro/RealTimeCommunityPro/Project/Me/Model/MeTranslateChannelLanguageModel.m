//
//  MeTranslateChannelLanguageModel.m
//  CIMKit
//
//  Created by cusPro on 2024/8/7.
//

#import "MeTranslateChannelLanguageModel.h"

@implementation ZTranslateLanguageModel

@end

@implementation MeTranslateChannelLanguageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    //更换参数名称
    return @{
        @"channelId" : @"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"lang_table":@"ZTranslateLanguageModel"};
}


@end
