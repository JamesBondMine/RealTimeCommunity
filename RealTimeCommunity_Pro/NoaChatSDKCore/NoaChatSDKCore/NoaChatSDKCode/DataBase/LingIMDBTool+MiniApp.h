//
//  LingIMDBTool+MiniApp.h
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/7/21.
//

#import "LingIMDBTool.h"
#import "LingFloatMiniAppModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LingIMDBTool (MiniApp)

/// 获取我的 浮窗小程序 列表
- (NSArray <LingFloatMiniAppModel *> *)getMyFloatMiniAppList;

/// 浮窗小程序 新增/更新
/// - Parameter miniAppModel: 小程序快应用
- (BOOL)insertFloatMiniAppWith:(LingFloatMiniAppModel *)miniAppModel;

/// 删除浮窗小程序
/// - Parameter miniAppID: 小程序快应用唯一标识
- (BOOL)deleteFloatMiniAppWith:(NSString *)floladId;

@end

NS_ASSUME_NONNULL_END
