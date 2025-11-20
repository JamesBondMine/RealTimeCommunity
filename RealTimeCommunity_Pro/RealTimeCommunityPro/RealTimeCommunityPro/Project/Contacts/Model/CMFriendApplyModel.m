//
//  CMFriendApplyModel.m
//  CIMKit
//
//  Created by cusPro on 2022/10/20.
//

#import "CMFriendApplyModel.h"

@implementation CMFriendApplyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    //更换参数名称
    return @{
        @"ID" : @"id"
    };
}
@end
