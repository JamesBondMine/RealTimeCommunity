//
//  NSMassMessageUserCell.h
//  CIMKit
//
//  Created by cusPro on 2023/4/19.
//

#import "ZBaseCell.h"
#import "NSMassMessageUserModel.h"
#import "NSMassMessageErrorUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMassMessageUserCell : ZBaseCell
@property (nonatomic, strong) id userModel;

@property (nonatomic, strong) UIImageView *ivHeader;
@property (nonatomic, strong) UILabel *ivRoleName;//用户角色名称
@property (nonatomic, strong) UILabel *lblNickname;
@property (nonatomic, strong) UILabel *lblTip;
@end

NS_ASSUME_NONNULL_END
