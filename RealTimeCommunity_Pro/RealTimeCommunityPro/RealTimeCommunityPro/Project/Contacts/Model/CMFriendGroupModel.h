//
//  CMFriendGroupModel.h
//  CIMKit
//
//  Created by cusPro on 2023/7/5.
//

#import "ZBaseModel.h"
#import "CMFriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMFriendGroupModel : ZBaseModel
//好友分组信息
@property (nonatomic, strong) LingIMFriendGroupModel *friendGroupModel;
//好友分组下的 好友列表
@property (nonatomic, strong) NSMutableArray <CMFriendModel *> *friendList;
@property (nonatomic, strong) NSMutableArray <CMFriendModel *> *friendOnLineList;//在线
@property (nonatomic, strong) NSMutableArray <CMFriendModel *> *friendOffLineList;//离线
@property (nonatomic, strong) NSMutableArray <CMFriendModel *> *friendSignOutList;//注销
//好友分组 是否展开
@property (nonatomic, assign) BOOL openedSection;
@end

NS_ASSUME_NONNULL_END
