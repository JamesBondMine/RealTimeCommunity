//
//  LingIMDBTool+MiniApp.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/7/21.
//

#import "LingIMDBTool+MiniApp.h"

//小程序信息
#import "LingFloatMiniAppModel+WCTTableCoding.h"

@implementation LingIMDBTool (MiniApp)

#pragma mark - 获取我的 浮窗小程序 列表
- (NSArray <LingFloatMiniAppModel *> *)getMyFloatMiniAppList {
    return [self.cimDB getObjectsOfClass:LingFloatMiniAppModel.class fromTable:CIMDBFloatMiniAppTableName];
}

#pragma mark - 浮窗小程序 新增/更新
- (BOOL)insertFloatMiniAppWith:(LingFloatMiniAppModel *)miniAppModel {
    return [self insertModelToTable:CIMDBFloatMiniAppTableName model:miniAppModel];
}

#pragma mark - 删除浮窗小程序
- (BOOL)deleteFloatMiniAppWith:(NSString *)floladId {
    //自检一下
    [self isTableStateOkWithName:CIMDBFloatMiniAppTableName model:LingFloatMiniAppModel.class];
    
    return [self.cimDB deleteFromTable:CIMDBFloatMiniAppTableName where:LingFloatMiniAppModel.floladId == floladId];
}

@end
