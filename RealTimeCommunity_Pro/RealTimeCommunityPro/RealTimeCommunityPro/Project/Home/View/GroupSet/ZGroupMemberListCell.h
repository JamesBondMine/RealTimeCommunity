//
//  ZGroupMemberListCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/9.
//

#import "ZBaseCell.h"
#import "BBBaseImageView.h"
#import <NoaChatSDKCore/LingIMGroupMemberModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGroupMemberListCell : ZBaseCell
@property (nonatomic, strong) UILabel *lblUserName;
@property (nonatomic, strong) BBBaseImageView *ivHeader;
@property (nonatomic, strong) UILabel *lblUserRoleName;//用户角色名称

- (void)cellConfigWithmodel:(LingIMGroupMemberModel *)model searchStr:(NSString *)searchStr activityInfo:(GHomeActivityInfoModel * _Nullable )activityInfo isActivityEnable:(NSInteger)isActivityEnable;
@end

NS_ASSUME_NONNULL_END
