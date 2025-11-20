//
//  ZCallInfoModel.h
//  CIMKit
//
//  Created by cusPro on 2023/6/2.
//

// 即构 音视频通话信息Model

#import "ZBaseModel.h"
@class ZCallMemberInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZCallInfoModel : ZBaseModel
//通话唯一标识
@property (nonatomic, copy) NSString *callId;
//通话房间ID
@property (nonatomic, copy) NSString *roomId;
//用户在音视频通话里的鉴权token
@property (nonatomic, copy) NSString *token;
//通话类型
@property (nonatomic, assign) LingIMCallType callType;//1音频2视频
//当前通话成员列表
@property (nonatomic, strong) NSArray <ZCallMemberInfoModel *> *receiveUserInfo;
@end

@interface ZCallMemberInfoModel:ZBaseModel
//通话唯一标识
@property (nonatomic, copy) NSString *userUid;
//通话唯一标识
@property (nonatomic, copy) NSString *nickname;
//通话唯一标识
@property (nonatomic, copy) NSString *avatar;
@end

NS_ASSUME_NONNULL_END
