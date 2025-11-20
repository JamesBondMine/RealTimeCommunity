//
//  ZMessageSendHander.h
//  CIMKit
//
//  Created by cusPro on 2022/10/28.
//

#import <Foundation/Foundation.h>
#import "ZMessageModel.h"
#import "ZFilePickModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMessageSendHander : NSObject

//发送文本消息(包括引用类消息)
+ (LingIMChatMessageModel *)ZMessageTextSend:(NSString *)textMessage withToUserId:(NSString *)to withChatType:(CIMChatType)chatType referenceMsgId:(NSString *)referenceMsgId;

//发送 @用户 消息 (包括引用类消息)
+ (LingIMChatMessageModel *)ZMessageAtUserSend:(NSString *)content showContent:(NSString *)showContent withAtUsersDicList:(NSArray *)atUsersDicList withToUserId:(NSString *)to withChatType:(CIMChatType)chatType referenceMsgId:(NSString *)referenceMsgId;

//发送图片或者视频
+ (void)ZMessageMediaSend:(NSMutableArray<PHAsset *> *)mediaAssetArr withToUserId:(NSString *)to withChatType:(CIMChatType)chatType compelete:(void(^)(NSArray <LingIMChatMessageModel *> * sendChatMsgArr))compelete;

////发送图片消息
//+ (void)ZMessageImageSend:(PHAsset *)mediaAsset withToUserId:(NSString *)to withChatType:(CIMChatType)chatType compelete:(void(^)(LingIMChatMessageModel * sendChatMsg))compelete imageUpload:(void(^)(NSData *imageData, NSString *imageName, LingIMChatMessageModel *imageChatMsgModel))imageUpload;
//
////发送视频消息
//+ (void)ZMessageVideoSend:(PHAsset *)mediaAsset withToUserId:(NSString *)to withChatType:(CIMChatType)chatType compelete:(void(^)(LingIMChatMessageModel * sendChatMsg))compelete videoUplaod:(void(^)(NSData *videoData, NSData *coverImgData, NSString *fileName, LingIMChatMessageModel *videoChatMsgModel))videoUplaod;

//发送语音消息
+ (void)ZMessageVoiceSend:(NSString *)voicePath fileName:(NSString *)fileName voiceDuring:(float)voiceDuring withToUserId:(NSString *)to withChatType:(CIMChatType)chatType compelete:(void(^)(LingIMChatMessageModel * sendChatMsg))compelete;

//发送文件消息
+ (void)ZMessageFileSendData:(ZFilePickModel *)fileModel withToUserId:(NSString *)to withChatType:(CIMChatType)chatType compelete:(void(^)(LingIMChatMessageModel * sendChatMsg))compelete;

//发送位置信息消息
+ (void)ZMessageLocationSendWithLng:(NSString *)geoLng lat:(NSString *)geoLat name:(NSString *)geoName cImg:(UIImage *)geoImg detail:(NSString *)geoDetail withToUserId:(NSString *)to withChatType:(CIMChatType)chatType compelete:(void(^)(LingIMChatMessageModel * sendChatMsg))compelete;

//组装图片消息-用于分享二维码
+ (void)ZMessageAssembleQRcodeImage:(UIImage *)qrImage compelete:(void(^)(LingIMChatMessageModel * sendChatMsg))compelete;

//发送 多选-合并转发 的消息记录类型的消息
+ (void)ZMessageMergeForwardSendWith:(NSArray *)multiSelectedItmeArr withTitle:(NSString *)title withToUserInfoArr:(NSArray *)userInfoArr compelete:(void(^)(NSArray <LingIMChatMessageModel *> *sendChatMsgList))compelete;

//发送表情消息
+ (LingIMChatMessageModel *)ZMessageStickersSendContentUrl:(NSString *)stickersImgUrl stickerThumbImgUrl:(NSString *)stickerThumbImgUrl stickerId:(NSString *)stickerId stickerName:(NSString *)stickerName stickerHeight:(float)stickerHeight stickerWidth:(float)stickerWidth stickerSize:(long long)stickerSize isStickersSet:(BOOL)isStickersSet stickerExt:(NSString *)stickerExt withToUserId:(NSString *)to withChatType:(CIMChatType)chatType;

//发送游戏表情消息
+ (LingIMChatMessageModel *)ZMessageGameStickersSendResultContent:(NSString *)resultContent gameStickersType:(ZChatGameStickerType)gameStickersType gameStickerExt:(NSString *)gameStickerExt withToUserId:(NSString *)to withChatType:(CIMChatType)chatType;

//组装已读类型消息HaveReadMessage
+ (LingIMChatMessageModel *)ZMessageReadedWithMsgSidList:(NSArray *)readedMsgSidList withToUserId:(NSString *)to withChatType:(CIMChatType)chatType;

//消息发送失败，重新发送
+ (void)ZMessageReSendWithFailMsg:(ZMessageModel *)failMsg compelete:(void(^)(LingIMChatMessageModel * sendChatMsg))compelete ;

@end

NS_ASSUME_NONNULL_END
