//
//  ZMsgAtListViewController.h
//  CIMKit
//
//  Created by cusPro on 2022/12/5.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMsgAtListViewController : BBBaseViewController

@property (nonatomic, assign)CIMChatType chatType;
@property (nonatomic, copy)NSString *sessionId;
@property (nonatomic, copy)void(^AtUserSelectClick)(id _Nullable atModel);

@end

NS_ASSUME_NONNULL_END
