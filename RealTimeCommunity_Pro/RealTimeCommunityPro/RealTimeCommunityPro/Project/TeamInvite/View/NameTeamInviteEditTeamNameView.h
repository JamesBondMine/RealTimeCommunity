//
//  NameTeamInviteEditTeamNameView.h
//  CIMKit
//
//  Created by phl on 2025/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IVTTeamInviteEditTeamNameDataHandle;
@interface NameTeamInviteEditTeamNameView : UIView

/// 初始化NameTeamInviteEditTeamNameView
/// - Parameters:
///   - frame: frame
///   - dataHandle: 数据处理类
- (instancetype)initWithFrame:(CGRect)frame
       editTeamNameDataHandle:(IVTTeamInviteEditTeamNameDataHandle *)dataHandle;

@end

NS_ASSUME_NONNULL_END
