//
//  HomeGroupNotalkMemberModel.h
//  CIMKit
//
//  Created by cusPro on 2022/11/17.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeGroupNotalkMemberModel : ZBaseModel
@property (nonatomic, copy) NSString *expireTime;//禁言时间
@property (nonatomic, copy) NSString *forbidUserIcon;//头像
@property (nonatomic, copy) NSString *forbidUserNickName;//昵称
@property (nonatomic, copy) NSString *forbidUserUid;//ID
@property (nonatomic, copy) NSString *updateTime;//时间
@property (nonatomic, copy) NSString *groupId;//群id
@property (nonatomic, assign) NSInteger roleId;//角色Id
@end

NS_ASSUME_NONNULL_END
