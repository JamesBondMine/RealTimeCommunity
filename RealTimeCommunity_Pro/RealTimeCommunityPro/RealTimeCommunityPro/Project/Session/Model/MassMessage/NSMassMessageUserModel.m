//
//  NSMassMessageUserModel.m
//  CIMKit
//
//  Created by cusPro on 2023/4/21.
//

#import "NSMassMessageUserModel.h"

@implementation NSMassMessageUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    //更换参数名称
    return @{
        @"taskId" : @"id"
    };
}

@end
