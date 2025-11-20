//
//  GroupGMManageManagerCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/15.
//

#import "ZBaseCell.h"
#import "BBBaseImageView.h"
#import <NoaChatSDKCore/LingIMGroupMemberModel.h>
#import "CCGroupGMManageCommonCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapCancelManagerBlock)(LingIMGroupMemberModel * model);
@interface GroupGMManageManagerCell : ZBaseCell
@property (nonatomic, strong) UIView *viewBg;
@property (nonatomic, strong) UILabel *lblUserName;
@property (nonatomic, strong) BBBaseImageView *ivHeader;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *viewLine;
@property (nonatomic, copy)TapCancelManagerBlock tapCancelManagerBlock;

- (void)cellConfigWithmodel:(LingIMGroupMemberModel *)model;
- (void)setCornerRadiusWithIsShow:(BOOL)isShow location:(CornerRadiusLocationType)locationType;
@end

NS_ASSUME_NONNULL_END
