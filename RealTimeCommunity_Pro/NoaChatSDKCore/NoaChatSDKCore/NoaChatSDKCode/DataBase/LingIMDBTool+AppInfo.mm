//
//  LingIMDBTool+AppInfo.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/7/5.
//

#import "LingIMDBTool+AppInfo.h"
#import <WCDBObjc/WCDBObjc.h>
#import "LingIMSensitiveRecordsModel+WCTTableCoding.h"//敏感词信息

@implementation LingIMDBTool (AppInfo)

/// 获取本地缓存的 敏感词(开启状态) 数据
- (NSArray<LingIMSensitiveRecordsModel *> *)getLocalSensitiveWithTableName:(NSString *)tableName {
    
    return [self.cimDB getObjectsOfClass:LingIMSensitiveRecordsModel.class fromTable:tableName where: LingIMSensitiveRecordsModel.status == 0];
}

@end
