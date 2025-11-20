//
//  HomeGroupMyNicknameVC.h
//  CIMKit
//
//  Created by cusPro on 2022/11/11.
//

// 我的群昵称VC

#import "BBBaseViewController.h"
#import "LingIMGroup.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^myGroupNicknameChangeBlock)(void);

@interface HomeGroupMyNicknameVC : BBBaseViewController

//我在本群的昵称发生修改
@property (nonatomic, copy) myGroupNicknameChangeBlock myGroupNicknameChange;
@property (nonatomic, strong) LingIMGroup *groupInfoModel;

@end

NS_ASSUME_NONNULL_END
