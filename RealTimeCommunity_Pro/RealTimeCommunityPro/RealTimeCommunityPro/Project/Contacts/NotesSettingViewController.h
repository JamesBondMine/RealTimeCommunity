//
//  NotesSettingViewController.h
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/11/8.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotesSettingViewController : BBBaseViewController

/// 初始化方法
/// @param titleStr 标题
/// @param remarkStr 备注内容
/// @param desStr 描述内容
- (instancetype)initWithTitle:(NSString *)titleStr remark:(NSString *)remarkStr description:(NSString *)desStr;

/// 保存按钮回调
@property (nonatomic, copy) void(^saveBtnBlock)(NSString *remarkStr, NSString *desStr);

/// 取消按钮回调（可选）
@property (nonatomic, copy) void(^cancelBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END
