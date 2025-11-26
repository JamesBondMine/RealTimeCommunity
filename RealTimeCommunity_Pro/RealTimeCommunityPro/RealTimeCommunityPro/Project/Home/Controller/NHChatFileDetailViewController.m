//
//  NHChatFileDetailViewController.m
//  CIMKit
//
//  Created by cusPro on 2023/4/11.
//

#import "NHChatFileDetailViewController.h"
#import "ZProgressButton.h"
#import "NHChatMultiSelectViewController.h"   //转发选择接收对象
#import "ZFileDownloadManager.h"
//#import "ZFileNetProgressManager.h"

@interface NHChatFileDetailViewController () <ZFileDownloadTaskDelegate>

@property (nonatomic, strong)UIImageView *fileTypeImgView;
@property (nonatomic, strong)UILabel *fileTypeLbl;
@property (nonatomic, strong)UILabel *fileNameLbl;
@property (nonatomic, strong)UILabel *fileSizeLbl;
@property (nonatomic, strong)UILabel *fileProgressLbl;
@property (nonatomic, strong)UILabel *fileUnknowTipLbl;
@property (nonatomic, strong)ZProgressButton *fileHandleBtn;
//@property (nonatomic, strong)ZFileNetProgressManager * fileDownloadManager;//下载类
@property (nonatomic, assign)float testProgress;

@end

@implementation NHChatFileDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *originTitleStr = @"";
    if (_isFromCollcet) {
        originTitleStr = self.collectionMsgModel.itemModel.body.name;
    } else {
        originTitleStr = self.fileMsgModel.message.fileName;
    }
    NSRange range = [originTitleStr rangeOfString:@"-"];
    if (range.length == 0) {
        self.navTitleStr = originTitleStr;
    } else {
        self.navTitleStr = [originTitleStr safeSubstringWithRange:NSMakeRange(range.location+1, originTitleStr.length - (range.location+1))];
    }
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_EEEEEE_DARK];
//    self.fileDownloadManager = [[ZFileNetProgressManager alloc] init];
    [self setupNavUI];
    [self setupUI];
    
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:_localFilePath];
    if (existed) {
        self.fileProgressLbl.hidden = YES;
        self.fileHandleBtn.stopTitle = MultilingualTranslation(@"用其他应用打开");
    } else {
        self.fileProgressLbl.hidden = YES;
        [self.fileHandleBtn setTitle:MultilingualTranslation(@"下载") forState:UIControlStateNormal];
    }
    
    _testProgress = 0;
}

- (void)setupNavUI {
    self.navBtnRight.hidden = !self.isShowRightBtn;
    [self.navBtnRight setTkThemeImage:@[ImgNamed(@"remsg_icon_chat_seetting"),ImgNamed(@"remsg_icon_chat_seetting_dark")] forState:UIControlStateNormal];
    [self.navBtnRight setEnlargeEdge:DWScale(10)];
}

- (void)setupUI {
    [self.view addSubview:self.fileTypeImgView];
    [self.fileTypeImgView addSubview:self.fileTypeLbl];
    [self.view addSubview:self.fileNameLbl];
    [self.view addSubview:self.fileSizeLbl];
    [self.view addSubview:self.fileProgressLbl];
    [self.view addSubview:self.fileUnknowTipLbl];
    [self.view addSubview:self.fileHandleBtn];
    
    [self.fileTypeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(DWScale(78));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DWScale(73), DWScale(91)));
    }];
    
    [self.fileTypeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.fileTypeImgView.mas_bottom).offset(DWScale(-10));
        make.leading.equalTo(self.fileTypeImgView).offset(5);
        make.trailing.equalTo(self.fileTypeImgView).offset(-5);
        make.height.mas_equalTo(DWScale(22));
    }];
    
    [self.fileNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileTypeImgView.mas_bottom).offset(DWScale(30));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DWScale(210), DWScale(24)));
    }];
    
    [self.fileSizeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileNameLbl.mas_bottom).offset(DWScale(5));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DWScale(210), DWScale(20)));
    }];
    
    [self.fileProgressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileSizeLbl.mas_bottom).offset(DWScale(5));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DWScale(210), DWScale(20)));
    }];
    
    [self.fileUnknowTipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileProgressLbl.mas_bottom).offset(DWScale(15));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DWScale(210), DWScale(40)));
    }];
    
    [self.fileHandleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileUnknowTipLbl.mas_bottom).offset(DWScale(165));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DWScale(220), DWScale(48)));
    }];
}

#pragma mark - Action
- (void)navBtnRightClicked {
    WeakSelf
    ZPresentItem *forwardItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"转发给好友") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(54) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            forwardItem.textColor = COLOR_33;
            forwardItem.backgroundColor = COLORWHITE;
        }else {
            forwardItem.textColor = COLORWHITE;
            forwardItem.backgroundColor = COLOR_33;
        }
    };
    
    ZPresentItem *otherOpenItem;
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:_localFilePath];
    if (existed) {
        otherOpenItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"用其他应用打开") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(54) backgroundColor:COLORWHITE];
    } else {
        otherOpenItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"下载") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(54) backgroundColor:COLORWHITE];
    }
    
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            otherOpenItem.textColor = COLOR_33;
            otherOpenItem.backgroundColor = COLORWHITE;
        }else {
            otherOpenItem.textColor = COLORWHITE;
            otherOpenItem.backgroundColor = COLOR_33;
        }
    };
    ZPresentItem *cancelItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"取消") textColor:COLOR_99 font:FONTR(17) itemHeight:DWScale(54) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            cancelItem.textColor = COLOR_B3B3B3;
            cancelItem.backgroundColor = COLORWHITE;
        }else {
            cancelItem.textColor = COLOR_99;
            cancelItem.backgroundColor = COLOR_33;
        }
    };
    ZPresentView *viewAlert = [[ZPresentView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DScreenHeight) titleItem:nil selectItems:@[forwardItem, otherOpenItem] cancleItem:cancelItem doneClick:^(NSInteger index) {
        if (index == 0) {
            //转发给好友
            [weakSelf forwardFileMessage];
        }
        if (index == 1) {
            //用其他应用打开
            [self fileHandleClick];
        }
    } cancleClick:^{
    }];
    [self.view addSubview:viewAlert];
    [viewAlert showPresentView];
}

#pragma mark - Setter
- (void)setFileMsgModel:(ZMessageModel *)fileMsgModel {
    _fileMsgModel = fileMsgModel;
    
    //文件类型icon
    self.fileTypeImgView.image = [UIImage getFileMessageIconWithFileType:_fileMsgModel.message.fileType fileName:_fileMsgModel.message.fileName];
    self.fileTypeLbl.text = [NSString getFileTypeContentWithFileType:_fileMsgModel.message.fileType fileName:_fileMsgModel.message.fileName];
    
    //文件名称
    NSRange range = [_fileMsgModel.message.fileName rangeOfString:@"-"];
    if (range.length == 0) {
        self.fileNameLbl.text = _fileMsgModel.message.fileName;
    } else {
        self.fileNameLbl.text = [_fileMsgModel.message.fileName safeSubstringWithRange:NSMakeRange(range.location+1, _fileMsgModel.message.fileName.length - (range.location+1))];
    }
    //文件大小
    self.fileSizeLbl.text = [NSString stringWithFormat:MultilingualTranslation(@"文件大小：%@"),[NSString fileTranslateToSize:_fileMsgModel.message.fileSize]];
}

- (void)setCollectionMsgModel:(ZMyCollectionModel *)collectionMsgModel {
    _collectionMsgModel = collectionMsgModel;
    
    //文件类型icon
    self.fileTypeImgView.image = [UIImage getFileMessageIconWithFileType:_collectionMsgModel.itemModel.body.type fileName:_collectionMsgModel.itemModel.body.name];
    self.fileTypeLbl.text = [NSString getFileTypeContentWithFileType:_collectionMsgModel.itemModel.body.type fileName:_collectionMsgModel.itemModel.body.name];
    
    //文件名称
    NSRange range = [_collectionMsgModel.itemModel.body.name rangeOfString:@"-"];
    if (range.length == 0) {
        self.fileNameLbl.text = _collectionMsgModel.itemModel.body.name;
    } else {
        self.fileNameLbl.text = [_fileMsgModel.message.fileName safeSubstringWithRange:NSMakeRange(range.location+1, _collectionMsgModel.itemModel.body.name.length - (range.location+1))];
    }
    //文件大小
    self.fileSizeLbl.text = [NSString stringWithFormat:MultilingualTranslation(@"文件大小：%@"),[NSString fileTranslateToSize:_collectionMsgModel.itemModel.body.size]];
}

- (void)setLocalFilePath:(NSString *)localFilePath {
    _localFilePath = localFilePath;
    
    // 检查是否以 .ipa1 或 .apk1 结尾,这里的path是要读取的本地的，要删掉1
    if ([localFilePath hasSuffix:@".ipa1"] || [localFilePath hasSuffix:@".apk1"]) {
        _localFilePath = [localFilePath substringToIndex:localFilePath.length - 1];
    }
}

- (void)setFromSessionId:(NSString *)fromSessionId {
    _fromSessionId = fromSessionId;
}

#pragma mark - 转发文件消息
- (void)forwardFileMessage {
    NHChatMultiSelectViewController *vc = [NHChatMultiSelectViewController new];
    vc.multiSelectType = ZMultiSelectTypeSingleForward;
    vc.fromSessionId = self.fromSessionId;
    vc.forwardMsgList = @[self.fileMsgModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
- (void)fileHandleClick {
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:_localFilePath];
    if (existed) {
        NSURL *fileUrl = [NSURL fileURLWithPath:_localFilePath];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[fileUrl] applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypePrint];
        // 该控制器不能push，只能使用模态视图弹出
        [self presentViewController:activityVC animated:YES completion:nil];
    } else {
        self.fileProgressLbl.hidden = NO;
        NSString *fileUrl;
        if (_isFromCollcet) {
            fileUrl = [self.collectionMsgModel.itemModel.body.path getImageFullString];
        } else {
            fileUrl = [self.fileMsgModel.message.filePath getImageFullString];
        }
        
        ZFileDownloadTask *task = [[ZFileDownloadTask alloc] initWithTaskId:fileUrl fileUrl:fileUrl saveName:[self.localFilePath lastPathComponent] savePath:self.localFilePath delegate:self];
        [[ZFileDownloadManager sharedInstance] addDownloadTask:task];
    }
}
    
#pragma mark - ZFileDownloadTaskDelegate
//任务状态改变回调
-(void)fileDownloadTask:(ZFileDownloadTask *)task didChangTaskStatus:(FileDownloadTaskStatus)status error:(NSError *)error {
    if (task.status == FileDownloadTaskStatus_Completed) {
        self.fileHandleBtn.stopTitle = MultilingualTranslation(@"用其他应用打开");
        self.fileProgressLbl.hidden = YES;
    }
    if (task.status == FileDownloadTaskStatus_Failed) {
        self.fileProgressLbl.hidden = YES;
        [HUD showMessage:MultilingualTranslation(@"下载失败")];
    }
}

//任务上传进度回调
-(void)fileDownloadTask:(ZFileDownloadTask *)task didChangTaskProgress:(float)progress {
    self.fileHandleBtn.progress = progress;
    if (_fileMsgModel) {
        self.fileProgressLbl.text = [NSString stringWithFormat:@"%@/%@", [NSString fileTranslateToSize:_fileMsgModel.message.fileSize * progress], [NSString fileTranslateToSize:_fileMsgModel.message.fileSize]];
    }
    if (_collectionMsgModel) {
        self.fileProgressLbl.text = [NSString stringWithFormat:@"%@/%@", [NSString fileTranslateToSize:_collectionMsgModel.itemModel.body.size * progress], [NSString fileTranslateToSize:_collectionMsgModel.itemModel.body.size]];
    }
}

#pragma mark - Lazy
- (UIImageView *)fileTypeImgView {
    if (!_fileTypeImgView) {
        _fileTypeImgView = [[UIImageView alloc] init];
    }
    return _fileTypeImgView;
}

- (UILabel *)fileTypeLbl {
    if (!_fileTypeLbl) {
        _fileTypeLbl = [[UILabel alloc] init];
        _fileTypeLbl.text = @"";
        _fileTypeLbl.tkThemetextColors = @[COLORWHITE, COLORWHITE];
        _fileTypeLbl.font = FONTN(22);
        _fileTypeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _fileTypeLbl;
}

- (UILabel *)fileNameLbl {
    if (!_fileNameLbl) {
        _fileNameLbl = [[UILabel alloc] init];
        _fileNameLbl.text = @"文件名称";
        _fileNameLbl.tkThemetextColors = @[COLOR_33, COLORWHITE];
        _fileNameLbl.font = FONTN(16);
        _fileNameLbl.textAlignment = NSTextAlignmentCenter;
        _fileNameLbl.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _fileNameLbl;
}

- (UILabel *)fileSizeLbl {
    if (!_fileSizeLbl) {
        _fileSizeLbl = [[UILabel alloc] init];
        _fileSizeLbl.text = @"文件大小：";
        _fileSizeLbl.tkThemetextColors = @[COLOR_33, COLORWHITE];
        _fileSizeLbl.font = FONTN(14);
        _fileSizeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _fileSizeLbl;
}

- (UILabel *)fileProgressLbl {
    if (!_fileProgressLbl) {
        _fileProgressLbl = [[UILabel alloc] init];
        _fileProgressLbl.text = @"0KB/0KB";
        _fileProgressLbl.hidden = YES;
        _fileProgressLbl.tkThemetextColors = @[COLOR_99, COLOR_99];
        _fileProgressLbl.font = FONTN(14);
        _fileProgressLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _fileProgressLbl;
}

- (UILabel *)fileUnknowTipLbl {
    if (!_fileUnknowTipLbl) {
        _fileUnknowTipLbl = [[UILabel alloc] init];
        _fileUnknowTipLbl.text = MultilingualTranslation(@"暂不支持打开此类型文件，你可以使用其他应用打开");
        _fileUnknowTipLbl.tkThemetextColors = @[COLOR_99, COLOR_99];
        _fileUnknowTipLbl.font = FONTN(14);
        _fileUnknowTipLbl.numberOfLines = 2;
        _fileUnknowTipLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _fileUnknowTipLbl;
}

- (ZProgressButton *)fileHandleBtn {
    if (!_fileHandleBtn) {
        _fileHandleBtn = [ZProgressButton crearProgressButtonWithFrame:CGRectMake(0, 0, DWScale(220), DWScale(48)) title:@"" lineWidth:DWScale(48) lineColor:COLOR_4791FF textColor:COLORWHITE backColor:COLOR_4791FF isRound:NO];
        _fileHandleBtn.titleLabel.font = FONTN(17);
        [_fileHandleBtn addTarget:self action:@selector(fileHandleClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fileHandleBtn;
}

@end
