//
//  MMGroupGMManageMemberCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/14.
//

#import "ZBaseCell.h"
#import "BBBaseImageView.h"
#import "HomeGroupNotalkMemberModel.h"
#import "CCGroupGMManageCommonCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapCancelNotalkBlock)(HomeGroupNotalkMemberModel * model);

@interface MMGroupGMManageMemberCell : ZBaseCell
@property (nonatomic, strong) UIView *viewBg;
@property (nonatomic, strong) UILabel *lblUserName;
@property (nonatomic, strong) BBBaseImageView *ivHeader;
@property (nonatomic, strong) UILabel *lblUserRoleName;//用户角色名称
@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *viewLine;
//点击解除禁言回调Block
@property (nonatomic, copy)TapCancelNotalkBlock tapCancelNotalkBlock;

- (void)setCornerRadiusWithIsShow:(BOOL)isShow location:(CornerRadiusLocationType)locationType;
- (void)cellConfigWithmodel:(HomeGroupNotalkMemberModel *)model;
@end

NS_ASSUME_NONNULL_END
