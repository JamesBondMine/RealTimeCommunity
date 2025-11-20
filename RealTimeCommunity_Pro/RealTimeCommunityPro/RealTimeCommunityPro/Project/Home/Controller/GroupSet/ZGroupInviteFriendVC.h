//
//  ZGroupInviteFriendVC.h
//  CIMKit
//
//  Created by cusPro on 2022/11/9.
//

#import "BBBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZGroupInviteFriendVC : BBBaseViewController

@property (nonatomic,strong)NSArray<LingIMGroupMemberModel *> *groupMemberList;
@property (nonatomic,strong)LingIMGroup *groupInfoModel;

@end

NS_ASSUME_NONNULL_END
