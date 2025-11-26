//
//  HomeChatTopView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/29.
//

#import "HomeChatTopView.h"
#import "ZChatLinkCollectCell.h"
#import "ZChatNavLinkAddView.h" //群链接addView
#import "ChatZZNavLinkSettingView.h" //群链接SettingView
#import "ZMessageAlertView.h"
#import "LingIMGroup.h"

@interface HomeChatTopView() <UICollectionViewDataSource, UICollectionViewDelegate, ZChatNavLinkSettingDelegate>

@property (nonatomic, strong) UIButton *backBtn;        //返回按钮
@property (nonatomic, strong) UIButton *rightBtn;       //右侧按钮
@property (nonatomic, strong) UIButton *btnCancel;      //多选-取消按钮

@property (nonatomic, strong) UIView *chatLinkBackView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ChatZZNavLinkSettingView *linkSettingView;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIButton *noticeBtn;

/// 设置
@property (nonatomic, strong) UIButton *settingBtn;

/// 添加连接
@property (nonatomic, strong) UIButton *addBtn;

/// 网络检测
@property (nonatomic, strong) UIButton *netDetectionBtn;

@end

@implementation HomeChatTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tkThemebackgroundColors = @[COLORWHITE, COLORWHITE_DARK];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectStateChange:) name:@"IMConnectStateChange" object:nil];
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(7);
        make.leading.equalTo(self).offset(10);
        make.height.width.mas_equalTo(30);
    }];
    
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.trailing.equalTo(self).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.tipExplainLbl];
    if ([ZLanguageTOOL.currentLanguage.languageName_zn isEqualToString:@"简体中文"]) {
        [self.tipExplainLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-(6 + DWScale(40)));
            make.centerX.equalTo(self);
            make.height.mas_equalTo(14);
        }];
    } else {
        [self.tipExplainLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-(6 + DWScale(40)));
            make.centerX.equalTo(self);
            make.height.mas_equalTo(14);
        }];
    }
    
    [self addSubview:self.tipLockImgView];
    [self.tipLockImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.tipExplainLbl.mas_leading).offset(-5);
        make.centerY.equalTo(self.tipExplainLbl);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(12);
    }];
    
    [self addSubview:self.chatNameLbl];
    [self.chatNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tipExplainLbl.mas_top).offset(-5);
        make.centerX.equalTo(self);
        make.width.mas_lessThanOrEqualTo(DWScale(180));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    [self addSubview:self.btnTime];
    [self.btnTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightBtn);
        make.trailing.equalTo(self.rightBtn.mas_leading).offset(-DWScale(10));
        make.size.mas_equalTo(CGSizeMake(DWScale(20), DWScale(20)));
    }];
    
    [self addSubview:self.btnCancel];
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.trailing.equalTo(self).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    _viewOnline = [UIView new];
    _viewOnline.tkThemebackgroundColors = @[HEXCOLOR(@"01BC46"), HEXCOLOR(@"01BC46")];
    _viewOnline.layer.cornerRadius = DWScale(3);
    _viewOnline.layer.masksToBounds = YES;
    _viewOnline.hidden = YES;
    [self addSubview:_viewOnline];
    [_viewOnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_chatNameLbl);
        make.leading.equalTo(_chatNameLbl.mas_trailing).offset(DWScale(2));
        make.size.mas_equalTo(CGSizeMake(DWScale(6), DWScale(6)));
    }];
    
    [self addSubview:self.chatLinkBackView];
    [self.chatLinkBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_equalTo(DWScale(40));
    }];
    
    //消息
    CGFloat msgTitleWidth = [MultilingualTranslation(@"消息") widthForFont:FONTN(14)];
    _messageBtn = [[UIButton alloc] init];
    [_messageBtn setTitle:MultilingualTranslation(@"消息") forState:UIControlStateNormal];
    [_messageBtn setTkThemeTitleColor:@[COLOR_4791FF, COLOR_4791FF] forState:UIControlStateNormal];
    [_messageBtn setImage:ImgNamed(@"remsg_icon_chat_link_message") forState:UIControlStateNormal];
    _messageBtn.tkThemebackgroundColors = @[[COLOR_4791FF colorWithAlphaComponent:0.2], [COLOR_4791FF colorWithAlphaComponent:0.2]];
    [_messageBtn rounded:DWScale(4)];
    _messageBtn.titleLabel.font = FONTN(14);
    //_messageBtn.userInteractionEnabled = NO;
    [_messageBtn setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:2];
    [self.chatLinkBackView addSubview:_messageBtn];
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.chatLinkBackView).offset(DWScale(16));
        make.centerY.equalTo(self.chatLinkBackView);
        make.width.mas_equalTo(msgTitleWidth + DWScale(28));
        make.height.mas_equalTo(DWScale(24));
    }];
    
    if (self.isShowGroupNotice) {
        //群公告
        CGFloat noticeTitleWidth = [MultilingualTranslation(@"群公告") widthForFont:FONTN(14)];
        self.noticeBtn.hidden = NO;
        [self.chatLinkBackView addSubview:self.noticeBtn];
        [self.noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.chatLinkBackView).offset(DWScale(16 + 10) + msgTitleWidth + DWScale(28));
            make.centerY.equalTo(self.chatLinkBackView);
            make.width.mas_equalTo(noticeTitleWidth + DWScale(28));
            make.height.mas_equalTo(DWScale(24));
        }];
    } else {
        self.noticeBtn.hidden = YES;
        [self.chatLinkBackView addSubview:self.noticeBtn];
        [self.noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.chatLinkBackView).offset(DWScale(16)+msgTitleWidth + DWScale(28));
            make.centerY.equalTo(self.chatLinkBackView);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(DWScale(24));
        }];
    }
    
    // 网络检测
    _netDetectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_netDetectionBtn setImage:ImgNamed(@"iccnavnetwork_detection") forState:UIControlStateNormal];
    _netDetectionBtn.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [_netDetectionBtn addTarget:self action:@selector(btnChatLinkNetworkDetectClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.chatLinkBackView addSubview:_netDetectionBtn];
    [_netDetectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.chatLinkBackView).offset(-DWScale(16));
        make.centerY.equalTo(self.chatLinkBackView);
        make.width.mas_equalTo(DWScale(18));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    //设置
    _settingBtn = [[UIButton alloc] init];
    [_settingBtn setImage:ImgNamed(@"remsg_icon_chat_link_setting") forState:UIControlStateNormal];
    _settingBtn.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [_settingBtn addTarget:self action:@selector(btnChatLinkSettingClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.chatLinkBackView addSubview:_settingBtn];
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_netDetectionBtn.mas_leading).offset(-DWScale(16));
        make.centerY.equalTo(self.chatLinkBackView);
        make.width.mas_equalTo(DWScale(18));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    //添加
    _addBtn = [[UIButton alloc] init];
    [_addBtn setImage:ImgNamed(@"remsg_icon_chat_link_add") forState:UIControlStateNormal];
    _addBtn.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [_addBtn addTarget:self action:@selector(btnChatLinkAddClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.chatLinkBackView addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_settingBtn.mas_leading).offset(-DWScale(6));
        make.centerY.equalTo(self.chatLinkBackView);
        make.width.mas_equalTo(DWScale(18));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    //CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [_collectionView registerClass:[ZChatLinkCollectCell class] forCellWithReuseIdentifier:NSStringFromClass([ZChatLinkCollectCell class])];
    [self.chatLinkBackView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.chatLinkBackView);
        make.leading.equalTo(self.noticeBtn.mas_trailing).offset(DWScale(10));
        make.trailing.equalTo(_netDetectionBtn.mas_leading).offset(-DWScale(10));
    }];
}

#pragma mark - Setter
- (void)setChatName:(NSString *)chatName {
    _chatName = chatName;
    _chatNameLbl.text = _chatName;
}

- (void)setShowCancel:(BOOL)showCancel {
    _showCancel = showCancel;
    if (_showCancel) {
        self.btnCancel.hidden = NO;
        self.rightBtn.hidden = YES;
    } else {
        self.btnCancel.hidden = YES;
        self.rightBtn.hidden = NO;
    }
}

- (void)setChatLinkArr:(NSMutableArray *)chatLinkArr {
    _chatLinkArr = chatLinkArr;
    [self.collectionView reloadData];
}


- (void)setIsShowGroupNotice:(BOOL)isShowGroupNotice {
    _isShowGroupNotice = isShowGroupNotice;
    
    CGFloat msgTitleWidth = [MultilingualTranslation(@"消息") widthForFont:FONTN(14)];
    if (_isShowGroupNotice) {
        //群公告
        CGFloat noticeTitleWidth = [MultilingualTranslation(@"群公告") widthForFont:FONTN(14)];
        self.noticeBtn.hidden = NO;
        [self.noticeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.chatLinkBackView).offset(DWScale(16 + 10) + msgTitleWidth + DWScale(28));
            make.centerY.equalTo(self.chatLinkBackView);
            make.width.mas_equalTo(noticeTitleWidth + DWScale(28));
            make.height.mas_equalTo(DWScale(24));
        }];
    } else {
        self.noticeBtn.hidden = YES;
        [self.noticeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.chatLinkBackView).offset(DWScale(16) + msgTitleWidth + DWScale(28));
            make.centerY.equalTo(self.chatLinkBackView);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(DWScale(24));
        }];
    }
}

- (void)setIsShowTagTool:(BOOL)isShowTagTool {
    _isShowTagTool = isShowTagTool;
    if (_isShowTagTool) {
        self.messageBtn.hidden = NO;
        self.noticeBtn.hidden = NO;
        self.collectionView.hidden = NO;
        self.chatLinkBackView.hidden = NO;
        
        //
        if (_chatType == CIMChatType_GroupChat) {
            // 群聊需要判断是否是管理员、群主，如果不是管理员、群主，则不显示添加链接、设置链接按钮(先隐藏，通过groupInfo属性传入后，再判断是否有权限，再放开展示)
            _addBtn.hidden = YES;
            _settingBtn.hidden = YES;
        }else {
            _settingBtn.hidden = NO;
            _addBtn.hidden = NO;
        }
        
    } else {
        self.messageBtn.hidden = YES;
        self.noticeBtn.hidden = YES;
        self.collectionView.hidden = YES;
        self.settingBtn.hidden = YES;
        self.addBtn.hidden = YES;
        self.chatLinkBackView.hidden = YES;
    }
}

- (void)setGroupInfo:(LingIMGroup *)groupInfo {
    if (!groupInfo) {
        return;
    }
    _groupInfo = groupInfo;
    if (!self.isShowTagTool) {
        // 本身就不展示的，不再修改隐藏、显示状态
        return;
    }
    
    if (groupInfo.userGroupRole == 1 || groupInfo.userGroupRole == 2) {
        // 只有管理员跟群主能添加、设置
        _settingBtn.hidden = NO;
        _addBtn.hidden = NO;
    }else {
        // 普通用户无添加、设置
        _addBtn.hidden = YES;
        _settingBtn.hidden = YES;
    }
}

- (void)connectStateChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSInteger connectType = [[userInfo objectForKeySafe:@"connectType"] integerValue];
    if (connectType == 0) {
        //正在连接...
        self.tipExplainLbl.text = MultilingualTranslation(@"正在连接...");
    } else if (connectType == 1) {
        //连接成功
        self.tipExplainLbl.text = MultilingualTranslation(@"当前消息已被加密");
    } else if (connectType == 2) {
        //连接失败
        self.tipExplainLbl.text = MultilingualTranslation(@"当前无法连接网络，请检查网络设置是否正常");
    } else {
        self.tipExplainLbl.text = MultilingualTranslation(@"当前消息已被加密");
    }
}


#pragma mark - Medth
- (void)chatRoomAddNewTagActionWithTagName:(NSString *)tagName tagUrl:(NSString *)tagUrl {
    //新增
    [self requestAddChatTagWithTagName:tagName tagUrl:tagUrl];
}

#pragma mark - Request
//新增tag
- (void)requestAddChatTagWithTagName:(NSString *)tagName tagUrl:(NSString *)tagUrl {
    NSInteger tagType = (self.chatType == 0 ? 1 : 2);
    WeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:self.sessionId forKey:@"dialog"];
    [dict setObjectSafe:tagName forKey:@"tagName"];
    [dict setObjectSafe:[NSNumber numberWithInteger:tagType] forKey:@"tagType"];
    [dict setObjectSafe:tagUrl forKey:@"tagUrl"];
    if (![NSString isNil:UserManager.userInfo.userUID]) {
          [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    }
    [IMSDKManager MessageChatTagAddWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            if (data) {
                [HUD showMessage:MultilingualTranslation(@"添加成功")];
                NSDictionary *dataDict = (NSDictionary *)data;
                ZChatTagModel *newTagModel = [ZChatTagModel mj_objectWithKeyValues:dataDict];
                [weakSelf.chatLinkArr addObject:newTagModel];
                [weakSelf.collectionView reloadData];
            }
        }
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//更新tag
- (void)requestUpdateChatTagWithTagName:(NSString *)tagName tagUrl:(NSString *)tagUrl tagId:(NSInteger)tagId handleIndex:(NSInteger)handleIndex {
    NSInteger tagType = (self.chatType == 0 ? 1 : 2);
    WeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:self.sessionId forKey:@"dialog"];
    [dict setObjectSafe:[NSNumber numberWithInteger:tagId] forKey:@"tagId"];
    [dict setObjectSafe:tagName forKey:@"tagName"];
    [dict setObjectSafe:[NSNumber numberWithInteger:tagType] forKey:@"tagType"];
    [dict setObjectSafe:tagUrl forKey:@"tagUrl"];
    if (![NSString isNil:UserManager.userInfo.userUID]) {
          [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    }
    [IMSDKManager MessageChatTagUpdateWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if (data) {
            BOOL isSuccess = [data boolValue];
            if (isSuccess) {
                [HUD showMessage:MultilingualTranslation(@"编辑成功")];
                ZChatTagModel *updateTagModel = (ZChatTagModel *)[weakSelf.chatLinkArr objectAtIndex:handleIndex];
                updateTagModel.tagName = tagName;
                updateTagModel.tagUrl = tagUrl;
                [weakSelf.chatLinkArr replaceObjectAtIndex:handleIndex withObject:updateTagModel];
                [weakSelf.collectionView reloadData];
            }
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}


//删除tag
- (void)requestChatTagRemoveWithModel:(NSInteger)tagId withIndex:(NSInteger)index {
    NSInteger tagType = (self.chatType == 0 ? 1 : 2);
    WeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:self.sessionId forKey:@"dialog"];
    [dict setObjectSafe:[NSNumber numberWithInteger:tagId] forKey:@"tagId"];
    [dict setObjectSafe:[NSNumber numberWithInteger:tagType] forKey:@"tagType"];
    if (![NSString isNil:UserManager.userInfo.userUID]) {
          [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    }
    [IMSDKManager MessageChatTagRemoveWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if (data) {
            [weakSelf.chatLinkArr removeObjectAtIndex:weakSelf.isShowGroupNotice ? index - 2 : index - 1];
            [weakSelf.collectionView reloadData];
            [HUD showMessage:MultilingualTranslation(@"删除成功")];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _chatLinkArr.count;
}

- (CGSize)collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *)indexPath {
    ZChatTagModel *tempTagModel = (ZChatTagModel *)[_chatLinkArr objectAtIndex:indexPath.row];
    NSString *titleStr = tempTagModel.tagName;
    CGFloat itemTitleWidth = [titleStr widthForFont:FONTN(14)];
    CGSize size = CGSizeMake(DWScale(6+18+3+itemTitleWidth+3), DWScale(30));//每个cell的宽度自适应
    return size;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZChatLinkCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZChatLinkCollectCell class]) forIndexPath:indexPath];
    ZChatTagModel *tempTagModel = (ZChatTagModel *)[_chatLinkArr objectAtIndex:indexPath.row];
    cell.tagModel = tempTagModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navLinkBlock) {
        self.navLinkBlock(indexPath.row);
    }
}

#pragma mark - ZChatNavLinkSettingDelegate
//删除
- (void)deleteAction:(NSInteger)index {
    WeakSelf
    ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeTitle supView:nil];
    msgAlertView.lblTitle.text = MultilingualTranslation(@"删除链接");
    msgAlertView.lblTitle.font = FONTB(18);
    msgAlertView.lblTitle.textAlignment = NSTextAlignmentLeft;
    msgAlertView.lblContent.text = MultilingualTranslation(@"确定要删除此链接吗？");
    msgAlertView.lblContent.font = FONTN(14);
    msgAlertView.lblContent.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    msgAlertView.lblContent.textAlignment = NSTextAlignmentLeft;
    [msgAlertView.btnSure setTitle:MultilingualTranslation(@"删除") forState:UIControlStateNormal];
    [msgAlertView.btnSure setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
    msgAlertView.btnSure.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF_DARK];
    [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
    [msgAlertView.btnCancel setTkThemeTitleColor:@[COLOR_66, COLOR_66_DARK] forState:UIControlStateNormal];
    msgAlertView.btnCancel.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F6F6F6_DARK];
    [msgAlertView alertShow];
    msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
        [weakSelf.linkSettingView linkSettingViewDismiss];
        weakSelf.linkSettingView.delegate = nil;
        weakSelf.linkSettingView = nil;
        ZChatTagModel *removeTagModel = (ZChatTagModel *)[weakSelf.chatLinkArr objectAtIndex:(weakSelf.isShowGroupNotice ? index - 2 : index - 1)];
        [weakSelf requestChatTagRemoveWithModel:removeTagModel.tagId withIndex:index];
    };
}

//编辑
- (void)editAction:(NSInteger)index {
    ZChatNavLinkAddView *addView = [[ZChatNavLinkAddView alloc] init];
    addView.updateIndex = index;
    addView.viewType = ChatLinkAddViewTypeEdit;
    addView.editTagModel = (ZChatTagModel *)[self.chatLinkArr objectAtIndex:self.isShowGroupNotice ? index - 2 : index - 1];
    [addView linkAddViewShow];
    WeakSelf
    [addView setNewTagFinsihBlock:^(NSInteger tagId, NSString * _Nonnull tagName, NSString * _Nonnull tagUrl, NSInteger updateIndex) {
        [weakSelf.linkSettingView linkSettingViewDismiss];
        weakSelf.linkSettingView.delegate = nil;
        weakSelf.linkSettingView = nil;
        //更新
        NSInteger handleIndex = (weakSelf.isShowGroupNotice ? updateIndex - 2 : updateIndex - 1);
        [weakSelf requestUpdateChatTagWithTagName:tagName tagUrl:tagUrl tagId:tagId handleIndex:handleIndex];
    }];
    
}

#pragma mark - Action
- (void)navBtnBackClicked {
    if (self.navBackBlock) {
        self.navBackBlock();
    }
}

- (void)navBtnRightClicked {
    if (self.navRightBlock) {
        self.navRightBlock();
    }
}

- (void)btnTimeClicked {
    if (self.navTimeBlock) {
        self.navTimeBlock();
    }
}

- (void)btnCancelClicked {
    self.showCancel = NO;
    if (self.navCancelBlock) {
        self.navCancelBlock();
    }
}

- (void)btnChatLinkNoticeClicked {
    if (self.navLinkBlock) {
        self.navLinkBlock(Chat_Top_Nav_Link_Notice);
    }
}

- (void)btnChatLinkSettingClicked {
    NSMutableArray *allTagArr = [NSMutableArray arrayWithArray:self.chatLinkArr];
    ZChatTagModel *messageTagModel = [[ZChatTagModel alloc] init];
    messageTagModel.tagIcon = @"icon_chat_link_message";
    messageTagModel.tagName = MultilingualTranslation(@"消息");
    messageTagModel.tagUrl = @"";
    messageTagModel.localType = 1;
    [allTagArr insertObject:messageTagModel atIndex:0];
    if (_isShowGroupNotice) {
        //群公告
        ZChatTagModel *noticeTagModel = [[ZChatTagModel alloc] init];
        noticeTagModel.tagIcon = @"icon_chat_link_notice";
        noticeTagModel.tagName = MultilingualTranslation(@"群公告");
        noticeTagModel.tagUrl = @"";
        noticeTagModel.localType = 1;
        [allTagArr insertObject:noticeTagModel atIndex:1];
    }
    
    [self.linkSettingView configLinkListData:allTagArr];
    [self.linkSettingView linkSettingViewShow];
}

- (void)btnChatLinkAddClicked {
    ZChatNavLinkAddView *addView = [[ZChatNavLinkAddView alloc] init];
    addView.viewType = ChatLinkAddViewTypeAdd;
    [addView linkAddViewShow];
    WeakSelf
    [addView setNewTagFinsihBlock:^(NSInteger tagId, NSString * _Nonnull tagName, NSString * _Nonnull tagUrl, NSInteger updateIndex) {
        //新增
        [weakSelf requestAddChatTagWithTagName:tagName tagUrl:tagUrl];
    }];
}

- (void)btnChatLinkNetworkDetectClicked {
    if (self.navNetworkDetectBlock) {
        self.navNetworkDetectBlock();
    }
}

#pragma mark - Lazy
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.adjustsImageWhenHighlighted = NO;
        [_backBtn setTkThemeImage:@[ImgNamed(@"icon_nav_back"),ImgNamed(@"nav_back_white")] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(navBtnBackClicked) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setEnlargeEdge:DWScale(10)];
    }
    return _backBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.adjustsImageWhenHighlighted = NO;
        [_rightBtn setTkThemeImage:@[ImgNamed(@"remsg_icon_chat_seetting"),ImgNamed(@"remsg_icon_chat_seetting_dark")] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(navBtnRightClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setEnlargeEdge:DWScale(10)];
    }
    return _rightBtn;
}

- (UILabel *)chatNameLbl {
    if (!_chatNameLbl) {
        _chatNameLbl = [[UILabel alloc] init];
        _chatNameLbl.text = @"";
        _chatNameLbl.font = FONTB(16);
        _chatNameLbl.textAlignment = NSTextAlignmentCenter;
        _chatNameLbl.preferredMaxLayoutWidth = DWScale(220);
        _chatNameLbl.tkThemetextColors = @[COLOR_33, COLORWHITE];
    }
    return _chatNameLbl;
}

- (UILabel *)tipExplainLbl {
    if (!_tipExplainLbl) {
        _tipExplainLbl = [[UILabel alloc] init];
        if ([[NetWorkStatusManager shared] getConnectStatus]) {
            _tipExplainLbl.text = MultilingualTranslation(@"当前消息已被加密");
        }else {
            _tipExplainLbl.text = MultilingualTranslation(@"当前无法连接网络，请检查网络设置是否正常");
        }
        _tipExplainLbl.font = FONTN(12);
        _tipExplainLbl.textAlignment = NSTextAlignmentCenter;
        _tipExplainLbl.tkThemetextColors = @[COLOR_99, COLOR_99];
        [_tipExplainLbl sizeToFit];
    }
    return _tipExplainLbl;
}

- (UIImageView *)tipLockImgView {
    if (!_tipLockImgView) {
        _tipLockImgView = [[UIImageView alloc] init];
        _tipLockImgView.image = ImgNamed(@"recat_img_chat_lock");
    }
    return _tipLockImgView;
}

- (UIButton *)btnTime {
    if (!_btnTime) {
        _btnTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnTime setImage:ImgNamed(@"remsg_icon_time") forState:UIControlStateNormal];
        [_btnTime addTarget:self action:@selector(btnTimeClicked) forControlEvents:UIControlEventTouchUpInside];
        [_btnTime setEnlargeEdge:DWScale(10)];
        _btnTime.hidden = YES;
    }
    return _btnTime;
}

- (UIButton *)btnCancel {
    if (!_btnCancel) {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
        [_btnCancel setTkThemeTitleColor:@[COLOR_33, COLOR_33_DARK] forState:UIControlStateNormal];
        _btnCancel.titleLabel.font = FONTN(16);
        [_btnCancel addTarget:self action:@selector(btnCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [_btnCancel setEnlargeEdge:DWScale(10)];
        _btnCancel.hidden = YES;
    }
    return _btnCancel;
}

- (UIView *)chatLinkBackView {
    if (!_chatLinkBackView) {
        _chatLinkBackView = [[UIView alloc] init];
        _chatLinkBackView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    }
    return _chatLinkBackView;
}

- (ChatZZNavLinkSettingView *)linkSettingView {
    if (!_linkSettingView) {
        _linkSettingView = [[ChatZZNavLinkSettingView alloc] init];
        _linkSettingView.delegate = self;
    }
    return _linkSettingView;
}

- (UIButton *)noticeBtn {
    if (!_noticeBtn) {
        _noticeBtn = [[UIButton alloc] init];
        _noticeBtn.hidden = YES;
        [_noticeBtn setTitle:MultilingualTranslation(@"群公告") forState:UIControlStateNormal];
        [_noticeBtn setTkThemeTitleColor:@[COLOR_33, COLORWHITE] forState:UIControlStateNormal];
        [_noticeBtn setImage:ImgNamed(@"remsg_icon_chat_link_notice") forState:UIControlStateNormal];
        _noticeBtn.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        _noticeBtn.titleLabel.font = FONTN(14);
        [_noticeBtn setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:2];
        [_noticeBtn addTarget:self action:@selector(btnChatLinkNoticeClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noticeBtn;
}

@end
