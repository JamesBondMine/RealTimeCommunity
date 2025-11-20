//
//  HomeSystemMessageVC.h
//  CIMKit
//
//  Created by cusPro on 2023/5/9.
//

// 系统消息VC(群助手)

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeSystemMessageVC : BBBaseViewController

@property (nonatomic, assign)ZGroupHelperFormType groupHelperType;
@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, strong) LingIMSessionModel *sessionModel;//红点消息已读使用的参数
@end

NS_ASSUME_NONNULL_END
