//
//  NSMassMessageErrorUserModel.m
//  CIMKit
//
//  Created by cusPro on 2023/4/21.
//

#import "NSMassMessageErrorUserModel.h"

@implementation NSMassMessageErrorUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    //更换参数名称
    return @{
        @"ID" : @"id"
    };
}

@end
