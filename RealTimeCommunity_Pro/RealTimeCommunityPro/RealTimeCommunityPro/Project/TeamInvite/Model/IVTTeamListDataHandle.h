//
//  IVTTeamListDataHandle.h
//  CIMKit
//
//  Created by phl on 2025/7/21.
//

#import <Foundation/Foundation.h>
#import "ZBaseModel.h"
#import "NTMTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IVTTeamListDataHandle : ZBaseModel

/// 团队顶部详情
@property (nonatomic, strong) NTMTeamModel *defaultTeamModel;

/// 团队列表
@property (nonatomic, strong) NSMutableArray <NTMTeamModel *>*teamListModelArr;

/// 请求团队首页上方数据
@property (nonatomic, strong) RACCommand *requestTeamHomeDataCommand;

/// 请求团队列表数据
@property (nonatomic, strong) RACCommand *requestTeamListCommand;

/// 下拉刷新数据
- (void)resumeDefaultConfigure;

/// 上拉加载数据
- (void)requestMoreDataConfigure;

/// 根据indexPath获取团队模型
/// - Parameter indexPath: indexPath
- (NTMTeamModel *)obtainTeamModelWithIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
