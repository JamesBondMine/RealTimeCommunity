//
//  NFFriendGroupManagerVC.h
//  CIMKit
//
//  Created by cusPro on 2023/7/3.
//

// 通讯录-好友-分组管理 VC

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NFFriendGroupManagerVC : BBBaseViewController
//好友分组是否可以编辑
@property (nonatomic, assign) BOOL friendGroupCanEdit;
//当前好友所属好友分组信息
@property (nonatomic, strong) LingIMFriendGroupModel *currentFriendGroupModel;
//当前好友ID
@property (nonatomic, copy) NSString *friendID;
@end

NS_ASSUME_NONNULL_END
