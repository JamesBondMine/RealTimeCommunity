//
//  ZJoinGroupModel.h
//  CIMKit
//
//  Created by cusPro on 2023/4/7.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

//群成员展示
@interface ZJoinGroupMemberModel : ZBaseModel

@property (nonatomic, copy)NSString  *msgNoPromt;
@property (nonatomic, copy)NSString  *msgTimeStart;
@property (nonatomic, copy)NSString *msgTop;
@property (nonatomic, copy)NSString  *nickName;
@property (nonatomic, copy)NSString *role;
@property (nonatomic, assign)int serialNumber;
@property (nonatomic, copy)NSString  *userAvatarFileName;
@property (nonatomic, copy)NSString  *userUid;

@end

//群信息展示
@interface ZJoinGroupInfoModel : ZBaseModel

@property (nonatomic, copy)NSString  *avatar;
@property (nonatomic, assign)int estoppelStatus;
@property (nonatomic, copy)NSString *gName;
@property (nonatomic, assign)int gStatus;
@property (nonatomic, copy)NSString *gid;
@property (nonatomic, assign)int groupMemberCount;
@property (nonatomic, assign)int groupStatus;
@property (nonatomic, assign)int maxMemberCount;
@property (nonatomic, assign)BOOL isNeedVerify;

@end

@interface ZJoinGroupModel : ZBaseModel

@property (nonatomic, strong)NSArray <ZJoinGroupMemberModel *> *groupMemberList;
@property (nonatomic, strong)ZJoinGroupInfoModel *groupInfo;
@property (nonatomic, copy)NSString *shareUserUid;
@property (nonatomic, assign)BOOL isOnGroup;
@property (nonatomic, copy)NSString *showGroupCountOfAdm;

@end


NS_ASSUME_NONNULL_END
