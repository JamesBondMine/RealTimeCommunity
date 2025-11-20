//
//  LoginServerConfigView.h
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginServerConfigCompleteBlock)(NSString * _Nullable companyId, NSString * _Nullable ipDomain);

@interface LoginServerConfigView : UIView

// 配置完成回调（返回企业号或IP/域名）
@property (nonatomic, copy) LoginServerConfigCompleteBlock configCompleteBlock;

// 显示弹窗
- (void)show;

// 隐藏弹窗
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END

