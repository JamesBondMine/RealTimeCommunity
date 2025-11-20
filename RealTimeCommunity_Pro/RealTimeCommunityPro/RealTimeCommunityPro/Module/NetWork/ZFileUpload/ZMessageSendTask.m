//
//  ZMessageSendTask.m
//  CIMKit
//
//  Created by cusPro on 2024/3/8.
//

#import "ZMessageSendTask.h"

@implementation ZMessageSendTask

-(void)setUploadTask:(NSArray<ZFileUploadTask *> *)uploadTask{
    _uploadTask = uploadTask;
    for (ZFileUploadTask * task in uploadTask) {
        [self addDependency:task];
    }
}

- (void)main{
    @autoreleasepool {
        if (self.isCancelled) {
            // 任务被取消，退出执行
            return;
        }
        [self sendMessage];
    }
}

-(void)sendMessage{
   // NSLog(@"FileUpload: 任务全部完成，开始发送消息");
    
    //给消息体赋值
    for (ZFileUploadTask * task in self.uploadTask) {
        LingIMChatMessageModel *beSendMessage = task.beSendMessage;
        if (beSendMessage.messageType == CIMChatMessageType_ImageMessage) {
            if (task.messageTaskType == FileUploadMessageTaskTypeThumbImage) {
                beSendMessage.thumbnailImg = task.originUrl;
            } else if(task.messageTaskType == FileUploadMessageTaskTypeImage) {
                beSendMessage.imgName = task.originUrl;
            }
        } else if (beSendMessage.messageType == CIMChatMessageType_VideoMessage) {
            if (task.messageTaskType == FileUploadMessageTaskTypeCover) {
                beSendMessage.videoCover = task.originUrl;
            } else if(task.messageTaskType == FileUploadMessageTaskTypeVideo) {
                beSendMessage.videoName = task.originUrl;
            }
        } else if (beSendMessage.messageType == CIMChatMessageType_FileMessage) {
            beSendMessage.filePath = task.originUrl;
        } else if (beSendMessage.messageType == CIMChatMessageType_VoiceMessage) {
            beSendMessage.voiceName = task.originUrl;
        } else if (beSendMessage.messageType == CIMChatMessageType_GeoMessage) {
            beSendMessage.geoImg = task.originUrl;
        }
    }
    
    for (ZFileUploadTask * uploadTask in self.uploadTask) {
        if (uploadTask.messageTaskType == FileUploadMessageTaskTypeThumbImage || uploadTask.messageTaskType == FileUploadMessageTaskTypeCover) {
            continue;
        }
        LingIMChatMessageModel *beSendMessage = uploadTask.beSendMessage;
        LingIMChatMessageModel * sendMessage;
        if (beSendMessage.messageType == CIMChatMessageType_ImageMessage) {
            if (![NSString isNil:beSendMessage.imgName] && ![NSString isNil:beSendMessage.thumbnailImg]) {
                sendMessage = beSendMessage;
            }
        } else if (beSendMessage.messageType == CIMChatMessageType_VideoMessage) {
            if (![NSString isNil:beSendMessage.videoCover] && ![NSString isNil:beSendMessage.videoName]) {
                sendMessage = beSendMessage;
            }
        } else if (beSendMessage.messageType == CIMChatMessageType_FileMessage) {
            if (![NSString isNil:beSendMessage.filePath]) {
                sendMessage = beSendMessage;
            }
        } else if (beSendMessage.messageType == CIMChatMessageType_VoiceMessage) {
            if (![NSString isNil:beSendMessage.voiceName]) {
                sendMessage = beSendMessage;
            }
        } else if (beSendMessage.messageType == CIMChatMessageType_GeoMessage) {
            if (![NSString isNil:beSendMessage.geoImg]) {
                sendMessage = beSendMessage;
            }
        }

        if (sendMessage) {
            [IMSDKManager toolSendChatMessageWith:sendMessage];
        }else {
            sendMessage.messageSendType = CIMChatMessageSendTypeFail;
            [IMSDKManager toolInsertOrUpdateChatMessageWith:sendMessage];
        }
    }
}

@end
