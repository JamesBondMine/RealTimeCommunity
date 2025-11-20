//
//  GHomeActivityInfoModel.m
//  CIMKit
//
//  Created by cusPro on 2025/2/24.
//

#import "GHomeActivityInfoModel.h"

@implementation ZGroupActivityActionModel

@end

@implementation ZGroupActivityLevelModel

@end

@implementation GHomeActivityInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"actions":@"ZGroupActivityActionModel",
        @"levels":@"ZGroupActivityLevelModel"
    };
}

@end
