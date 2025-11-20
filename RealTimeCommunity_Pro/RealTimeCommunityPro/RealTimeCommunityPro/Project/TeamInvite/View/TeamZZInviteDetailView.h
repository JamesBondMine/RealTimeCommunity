//
//  TeamZZInviteDetailView.h
//  CIMKit
//
//  Created by phl on 2025/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class IVTTeamInviteDetailDataHandle;
@interface TeamZZInviteDetailView : UIView

/// 点击修改团队名称
@property (nonatomic, strong) RACSubject *editTeamNameSubject;

/// 初始化TeamZZInviteDetailView
/// - Parameters:
///   - frame: frame
///   - dataHandle: 数据处理类
- (instancetype)initWithFrame:(CGRect)frame
   TeamInviteDetailDataHandle:(IVTTeamInviteDetailDataHandle *)dataHandle;

/// 刷新数据
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
