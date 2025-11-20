//
//  WidgetTeamListView.h
//  CIMKit
//
//  Created by phl on 2025/7/21.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@class IVTTeamListDataHandle;
@interface WidgetTeamListView : UIView

/// 跳转详情页面通知
@property (nonatomic, strong) RACSubject *jumpDetailVCSubject;

/// 创建团队页面，返回刷新
- (void)reloadData;

/// 初始化WidgetTeamListView
/// - Parameters:
///   - frame: frame
///   - dataHandle: 数据处理类
- (instancetype)initWithFrame:(CGRect)frame
           TeamListDataHandle:(IVTTeamListDataHandle *)dataHandle;

@end

NS_ASSUME_NONNULL_END
