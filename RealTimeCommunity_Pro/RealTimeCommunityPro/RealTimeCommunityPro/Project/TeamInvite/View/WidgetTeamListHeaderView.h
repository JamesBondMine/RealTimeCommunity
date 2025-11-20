//
//  WidgetTeamListHeaderView.h
//  CIMKit
//
//  Created by phl on 2025/7/21.
//

#import <UIKit/UIKit.h>
#import "NTMTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTeamListHeaderInfoItemView : UIView

/// 需要显示的标题
@property (nonatomic, copy) NSString *title;

/// 需要显示的数量
@property (nonatomic, copy) NSString *count;

/// 邀请标题
@property (nonatomic, strong) UILabel *titleLabel;

/// 邀请数量
@property (nonatomic, strong) UILabel *countLabel;

@end

@interface WidgetTeamListHeaderView : UIView

@property (nonatomic, strong) NTMTeamModel *teamModel;

@end

NS_ASSUME_NONNULL_END
