//
//  ZJoinGroupModel.m
//  CIMKit
//
//  Created by cusPro on 2023/4/7.
//

#import "ZJoinGroupModel.h"

@implementation ZJoinGroupMemberModel

@end

@implementation ZJoinGroupInfoModel

@end


@implementation ZJoinGroupModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"groupMemberList":@"ZJoinGroupMemberModel"};
}



@end
