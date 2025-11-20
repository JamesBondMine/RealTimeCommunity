//
//  NFUserHomePageVC.h
//  CIMKit
//
//  Created by cusPro on 2022/10/20.
//

// 用户主页VC

#import "BBBaseViewController.h"


//typedef NS_ENUM(NSUInteger, UserHomePageVCType) {
//    UserHomePageSingleChatType = 1,        //单聊、通讯录查看好友信息
//    UserHomePageGroupChatType = 2,        //群聊查看好友信息
//};


NS_ASSUME_NONNULL_BEGIN

@interface NFUserHomePageVC : BBBaseViewController
@property (nonatomic, copy) NSString *userUID;
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, assign) BOOL isFromQRCode;

@end

NS_ASSUME_NONNULL_END
