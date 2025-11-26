//
//  HomeChatRecordDetailViewController.m
//  CIMKit
//
//  Created by cusPro on 2023/4/25.
//

#import "HomeChatRecordDetailViewController.h"
#import "ZMessageBaseCell.h"
#import "ZMessageTextCell.h"
#import "ZMessageReferenceCell.h"
#import "ZMessageImageCell.h"
#import "ZMessageVideoCell.h"
#import "ZMessageAtUserCell.h"
#import "ZMessageFileCell.h"
#import "ZMessageVoiceCell.h"
#import "ZMessageGeoCell.h"
#import "ZMergeMessageRecordCell.h"
#import "ZMessageStickersCell.h"
#import "ZMessageGameStickersCell.h"
#import "KNPhotoBrowser.h"//图片视频浏览
#import "ZAudioPlayManager.h"//语音消息播放单例
#import "NHChatFileDetailViewController.h"//文件详情
#import "NFUserHomePageVC.h"//用户资料页(点击名片消息)
#import "HomeChatRecordDetailViewController.h"//消息记录详情页面
#import "ZMessageTools.h"
#import "NSMiniAppWebVC.h"

@interface HomeChatRecordDetailViewController () <UITableViewDelegate, UITableViewDataSource, ZMessageBaseCellDelegate, KNPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *recordMsgList;

@end

@implementation HomeChatRecordDetailViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //立刻聊天界面时，停止语音播放和播放的动画
    if (ZAudioPlayerTOOL.isPlaying) {
        [ZAudioPlayerTOOL stop];
    }
    if (ZAudioPlayerTOOL.currentVoiceCell) {
        [ZAudioPlayerTOOL stop];
        [ZAudioPlayerTOOL.currentVoiceCell stopAnimation];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_EEEEEE_DARK];
    self.navTitleStr = self.model.message.forwardMessage.title;
    self.navTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_EEEEEE_DARK];
    self.baseTableView.estimatedRowHeight = 0;
    self.baseTableView.estimatedSectionHeaderHeight = 0;
    self.baseTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
    }];
}

#pragma mark - Setter
- (void)setModel:(ZMessageModel *)model {
    _model = model;
    
    [self.recordMsgList removeAllObjects];
    NSArray *forwardMessageArr = _model.message.forwardMessage.messageListArray;
    for (IMChatMessage *imRecordMsg in forwardMessageArr) {
        if (self.levelNum >= 3 && imRecordMsg.mType == IMChatMessage_MessageType_ForwardMessage) {
            imRecordMsg.mType = IMChatMessage_MessageType_TextMessage;
            imRecordMsg.textMessage.content = MultilingualTranslation(@"[该消息暂不支持查看]");
        }
        LingIMChatMessageModel *recordLingIMMode = [[LingIMModelTool sharedTool] getChatMessageModelFromIMChatMessage:imRecordMsg];
        if (recordLingIMMode.messageType == CIMChatMessageType_GameStickersMessage) {
            recordLingIMMode.isGameAnimationed = YES;
        }
        recordLingIMMode.chatType = CIMChatType_GroupChat;
        ZMessageModel *messageModel = [[ZMessageModel alloc] initWithMessageModel:recordLingIMMode isSelf:NO];
        messageModel.message.messageSendType = CIMChatMessageSendTypeSuccess;
        [self.recordMsgList addObject:messageModel];
    }
    [self.baseTableView reloadData];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recordMsgList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZMessageModel *model = [self.recordMsgList objectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.recordMsgList.count) {
        
        ZMessageBaseCell *cell = [ZMessageBaseCell new];
        ZMessageModel *model = [self.recordMsgList objectAtIndex:indexPath.row];
        //cell
        switch (model.message.messageType) {
            case CIMChatMessageType_TextMessage:    //文本消息
            {
                //纯文本消息
                cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
                if (cell == nil) {
                    cell = [[ZMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"];
                }
                cell.delegate = self;
                cell.sessionId = @"";
                [cell setConfigMessage:model];
            }
                break;
            case CIMChatMessageType_ImageMessage:   //图片消息
            {
                //图片消息
                cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
                if (cell == nil) {
                    cell = [[ZMessageImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
                }
                cell.delegate = self;
                cell.sessionId = @"";
                [cell setConfigMessage:model];
            }
                break;
            case CIMChatMessageType_StickersMessage:   //表情消息
            {
                //表情消息
                cell = [tableView dequeueReusableCellWithIdentifier:@"stickerCell"];
                if (cell == nil) {
                    cell = [[ZMessageStickersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stickerCell"];
                }
                cell.delegate = self;
                cell.sessionId = @"";
                [cell setConfigMessage:model];
            }
                break;
            case CIMChatMessageType_GameStickersMessage:   //游戏表情消息
            {
                //游戏表情消息
                cell = [tableView dequeueReusableCellWithIdentifier:@"gameStickerCell"];
                if (cell == nil) {
                    cell = [[ZMessageGameStickersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gameStickerCell"];
                }
                cell.delegate = self;
                cell.sessionId = @"";
                [cell setConfigMessage:model];
            }
                break;
            case CIMChatMessageType_VideoMessage:   //视频消息
            {
                //视频消息
                cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
                if (cell == nil) {
                    cell = [[ZMessageVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
                }
                cell.delegate = self;
                cell.sessionId = @"";
                [cell setConfigMessage:model];
            }
                break;
            case CIMChatMessageType_AtMessage:   //At消息
            {
                if (![NSString isNil:model.message.referenceMsgId]) {
                    //引用消息 + At
                    cell = [tableView dequeueReusableCellWithIdentifier:@"referenceTextCell"];
                    if (cell == nil) {
                        cell = [[ZMessageReferenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"referenceTextCell"];
                    }
                } else {
                    //At消息
                    cell = [tableView dequeueReusableCellWithIdentifier:@"AtUsetCell"];
                    if (cell == nil) {
                        cell = [[ZMessageAtUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AtUsetCell"];
                    }
                }
                cell.delegate = self;
                cell.sessionId = @"";
                [cell setConfigMessage:model];
            }
                break;
            case CIMChatMessageType_FileMessage:   //文件消息
            {
                //文件消息
                ZMessageFileCell * fileCell;
                NSString * cellId = [ZMessageFileCell cellIdentifier];
                fileCell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (fileCell == nil) {
                    fileCell = [[ZMessageFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                fileCell.delegate = self;
                fileCell.sessionId = @"";
                [fileCell setConfigMessage:model];
                cell = fileCell;
            }
                break;
            case CIMChatMessageType_VoiceMessage:   //音频消息
            {
                //音频消息
                cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
                if (cell == nil) {
                    cell = [[ZMessageVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"voiceCell"];
                }
                cell.delegate = self;
                cell.sessionId = @"";
                model.message.chatMessageReaded = YES;
                [cell setConfigMessage:model];
            }
                break;
            case CIMChatMessageType_GeoMessage:    //地理位置消息
            {
                //地理位置消息
                cell = [tableView dequeueReusableCellWithIdentifier:@"geoLocationCell"];
                if (cell == nil) {
                    cell = [[ZMessageGeoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"geoLocationCell"];
                }
                cell.delegate = self;
                cell.sessionId = @"";
                [cell setConfigMessage:model];
            }
                break;
            case CIMChatMessageType_ForwardMessage:    //合并转发的消息记录
            {
                //合并转发的消息记录
                cell = [tableView dequeueReusableCellWithIdentifier:@"ZMergeMessageRecordCell"];
                if (cell == nil) {
                    cell = [[ZMergeMessageRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZMergeMessageRecordCell"];
                }
                cell.delegate = self;
                cell.sessionId = @"";
                [cell setConfigMessage:model];
            }
                break;
            default:
                break;
        }
        cell.cellIndex = indexPath;
        return cell;
    } else {
        return [UITableViewCell new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - ZMessageBaseCellDelegate
//图片或视频的浏览
- (void)messageCellBrowserImageAndVideo:(LingIMChatMessageModel *)messageModel {
    [self imageVideoBrowserWith:messageModel];
}

//语音消息点击，播放或者停止
- (void)voiceMessageClick:(NSIndexPath *)cellIndex {
    ZMessageVoiceCell *clickVoiceCell = (ZMessageVoiceCell *)[self.baseTableView cellForRowAtIndexPath:cellIndex];
    ZMessageModel *voiceMsgModel = [self.recordMsgList objectAtIndex:cellIndex.row];
    if (ZAudioPlayerTOOL.isPlaying) {
        [ZAudioPlayerTOOL stop];
    }
    if (clickVoiceCell.isAnimation) {
        [clickVoiceCell stopAnimation];
        [ZAudioPlayerTOOL stop];
    } else {
        if (ZAudioPlayerTOOL.currentVoiceCell && ![ZAudioPlayerTOOL.currentVoiceCell isEqual:clickVoiceCell]) {
            [ZAudioPlayerTOOL stop];
            [ZAudioPlayerTOOL.currentVoiceCell stopAnimation];
        }
        ZAudioPlayerTOOL.currentVoiceCell = clickVoiceCell;
        if (voiceMsgModel.isSelf) {
            //本地音频文件路径
            NSString *folderPath = [NSString getVoiceDiectoryWithCustomPath:[NSString stringWithFormat:@"%@-%@",UserManager.userInfo.userUID, self.model.message.msgID]];
            NSString *meLocalPath = [NSString stringWithFormat:@"%@/%@", folderPath, voiceMsgModel.message.localVoiceName];
            //判断本地音频文件是否存在
            if ([[NSFileManager defaultManager] fileExistsAtPath:meLocalPath]) {
                //本地存在对应的音频文件
                BOOL isPlay = [ZAudioPlayerTOOL playAudioPath:meLocalPath];
                if (isPlay) {
                    [clickVoiceCell startAnimation];
                    ZAudioPlayerTOOL.currentAudioPath = voiceMsgModel.message.localVoiceName;
                    ZAudioPlayerTOOL.playMessageID = voiceMsgModel.message.msgID;
                }
            } else {
                //本地不存在对应的音频文件，需要先缓存，再播放(先判断是否有网络)
                if ([ZTOOL isNetworkAvailable]) {
                    //有网络，下载语音文件，下载成功后并进行播放
                    NSString *downloadVoicePath = [NSString stringWithFormat:@"%@/%@", folderPath, [voiceMsgModel.message.voiceName MD5Encryption]];
                    //下载语音音频文件
                    [ZMessageTools downloadAudioWith:voiceMsgModel.message.voiceName AudioCachePath:downloadVoicePath completion:^(BOOL success, NSString * _Nonnull audioPath) {
                        if (success) {
                            BOOL isPlay = [ZAudioPlayerTOOL playAudioPath:audioPath];
                            if (isPlay) {
                                [clickVoiceCell startAnimation];
                                ZAudioPlayerTOOL.currentAudioPath = voiceMsgModel.message.localVoiceName;
                                ZAudioPlayerTOOL.playMessageID = voiceMsgModel.message.msgID;
                            }
                        } else {
                            [HUD showMessage:MultilingualTranslation(@"语音播放失败，请稍后再试")];
                        }
                    }];
                } else {
                    //无网络
                    [HUD showMessage:MultilingualTranslation(@"网络错误,播放失败")];
                }
            }
        } else {
            //本地音频文件路径
            NSString *folderPath = [NSString getVoiceDiectoryWithCustomPath:[NSString stringWithFormat:@"%@-%@",UserManager.userInfo.userUID, self.model.message.msgID]];
            NSString *meLocalPath = [NSString stringWithFormat:@"%@/%@", folderPath, [voiceMsgModel.message.voiceName MD5Encryption]];
            //判断本地音频文件是否存在
            if ([[NSFileManager defaultManager] fileExistsAtPath:meLocalPath]) {
                //本地存在对应的音频文件
                BOOL isPlay = [ZAudioPlayerTOOL playAudioPath:meLocalPath];
                if (isPlay) {
                    [clickVoiceCell startAnimation];
                    ZAudioPlayerTOOL.currentAudioPath = voiceMsgModel.message.voiceName;
                    ZAudioPlayerTOOL.playMessageID = voiceMsgModel.message.msgID;
                }
            } else {
                //本地不存在对应的音频文件，需要先缓存，再播放(先判断是否有网络)
                if ([ZTOOL isNetworkAvailable]) {
                    //有网络，下载语音文件，下载成功后并进行播放
                    [ZMessageTools downloadAudioWith:voiceMsgModel.message.voiceName AudioCachePath:meLocalPath completion:^(BOOL success, NSString * _Nonnull audioPath) {
                        if (success) {
                            BOOL isPlay = [ZAudioPlayerTOOL playAudioPath:audioPath];
                            if (isPlay) {
                                [clickVoiceCell startAnimation];
                                ZAudioPlayerTOOL.currentAudioPath = voiceMsgModel.message.voiceName;
                                ZAudioPlayerTOOL.playMessageID = voiceMsgModel.message.msgID;
                            }
                        } else {
                            [HUD showMessage:MultilingualTranslation(@"语音播放失败，请稍后再试")];
                        }
                    }];
                } else {
                    //无网络
                    [HUD showMessage:MultilingualTranslation(@"网络错误,播放失败")];
                }
            }
        }
    }
}

//消息气泡点击
- (void)messageBubbleClick:(NSIndexPath *)cellIndex {
    ZMessageModel *bubbleMsgClickModel = [self.recordMsgList objectAtIndex:cellIndex.row];
    if (bubbleMsgClickModel.message.messageType == CIMChatMessageType_FileMessage) {
        //文件消息-文件详情
        NSString *foldPath = [NSString getFileDiectoryWithCustomPath:[NSString stringWithFormat:@"%@-%@",UserManager.userInfo.userUID, self.model.message.msgID]];
        NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@", foldPath, bubbleMsgClickModel.message.fileName];
        
        NHChatFileDetailViewController *fileDetailVC = [[NHChatFileDetailViewController alloc] init];
        fileDetailVC.fileMsgModel = bubbleMsgClickModel;
        fileDetailVC.fromSessionId = @"";
        fileDetailVC.localFilePath = fileFullPath;
        fileDetailVC.isShowRightBtn = NO;
        fileDetailVC.isFromCollcet = NO;
        [self.navigationController pushViewController:fileDetailVC animated:YES];
    } else if (bubbleMsgClickModel.message.messageType == CIMChatMessageType_CardMessage) {
        //名片消息-用户个人资料页
        NFUserHomePageVC *userHomeVC = [NFUserHomePageVC new];
        userHomeVC.userUID = bubbleMsgClickModel.message.cardUserId;
        userHomeVC.groupID = @"";
        [self.navigationController pushViewController:userHomeVC animated:YES];
    } else if (bubbleMsgClickModel.message.messageType == CIMChatMessageType_ForwardMessage) {
        //消息记录详情页面
        HomeChatRecordDetailViewController *chatRecordDetailVC = [[HomeChatRecordDetailViewController alloc] init];
        chatRecordDetailVC.levelNum = self.levelNum + 1;
        chatRecordDetailVC.model = bubbleMsgClickModel;
        [self.navigationController pushViewController:chatRecordDetailVC animated:YES];
    }
}
#pragma mark - ******图片和视频的浏览******
- (void)imageVideoBrowserWith:(LingIMChatMessageModel *)messageModel {
    NSMutableArray *browserMessages = [NSMutableArray array];
    if (messageModel.messageType == CIMChatMessageType_ImageMessage) {
        KNPhotoItems *item = [[KNPhotoItems alloc] init];
        //图片
        item.isVideo = false;
        if (messageModel.localImgName) {
            //本地有图片
            NSString *customPath = [NSString stringWithFormat:@"%@-%@", UserManager.userInfo.userUID, self.model.message.msgID];
            UIImage *localImage = [NSString getImageWithImgName:messageModel.localImgName CustomPath:customPath];
            item.sourceImage = localImage;
        } else {
            //网络图片
            item.url = [messageModel.imgName getImageFullString];
            //缩略图地址
            item.thumbnailUrl = [messageModel.thumbnailImg getImageFullString];
        }
        [browserMessages addObjectIfNotNil:item];
    } else if (messageModel.messageType == CIMChatMessageType_VideoMessage) {
        //视频
        KNPhotoItems *item = [[KNPhotoItems alloc] init];
        item.isVideo = true;
        if (messageModel.localVideoCover) {
            //本地视频封面
            NSString *customPath = [NSString stringWithFormat:@"%@-%@", UserManager.userInfo.userUID, self.model.message.msgID];
            NSString *pathStr = [NSString getPathWithImageName:messageModel.localVideoCover CustomPath:customPath];
            item.videoPlaceHolderImageUrl = pathStr;
        } else {
            //网络视频封面
            item.videoPlaceHolderImageUrl = [messageModel.videoCover getImageFullString];
        }
        if (messageModel.localVideoName) {
            //本地视频地址
            NSString *customPath = [NSString stringWithFormat:@"%@-%@", UserManager.userInfo.userUID, self.model.message.msgID];
            NSString *videoUrl = [NSString getPathWithVideoName:messageModel.localVideoName CustomPath:customPath];
            item.url = videoUrl;
        }else {
            //网络视频地址
            item.url = [messageModel.videoName getImageFullString];
        }
        [browserMessages addObjectIfNotNil:item];
    }
    
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    [KNPhotoBrowserConfig share].isNeedCustomActionBar = false;
    photoBrowser.delegate = self;
    photoBrowser.itemsArr = browserMessages;
    photoBrowser.placeHolderColor = UIColor.lightTextColor;
    photoBrowser.currentIndex = 0;
    photoBrowser.isSoloAmbient = true;//音频模式
    photoBrowser.isNeedPageNumView = false;//分页
    photoBrowser.isNeedRightTopBtn = true;//更多按钮
    photoBrowser.isNeedLongPress = false;//长按
    photoBrowser.isNeedPanGesture = true;//拖拽
    photoBrowser.isNeedPrefetch = true;//预取图像(最大8)
    photoBrowser.isNeedAutoPlay = true;//自动播放
    photoBrowser.isNeedOnlinePlay = false;//在线播放(先自动下载视频)

    [photoBrowser present];
}

- (void)messageTextContainUrlClick:(NSString *)urlStr messageModel:(nonnull ZMessageModel *)messageModel {
    //跳转Web
    
    LingFloatMiniAppModel * floadModel = [[LingFloatMiniAppModel alloc] init];
    floadModel.url = urlStr;
    floadModel.floladId = [NSString stringWithFormat:@"%@_%@",messageModel.message.msgID,urlStr];
    floadModel.title = nil;
    floadModel.headerUrl = nil;
    
    NSMiniAppWebVC *webVC = [[NSMiniAppWebVC alloc] init];
    webVC.webViewUrl = urlStr;
    webVC.webType = NSMiniAppWebVCTypeMiniApp;
    webVC.floatMiniAppModel = floadModel;
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark - Lazy
- (NSMutableArray *)recordMsgList {
    if (!_recordMsgList) {
        _recordMsgList = [[NSMutableArray alloc] init];
    }
    return _recordMsgList;
}


@end
