//
//  SpecConfigMiniAppView.m
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

#import "SpecConfigMiniAppView.h"
#import "ZToolManager.h"
#import "ZImagePickerVC.h"
#import "ZFileUploadManager.h"
//#import "ZFileNetProgressManager.h"

@interface SpecConfigMiniAppView () <UIGestureRecognizerDelegate, ZImagePickerVCDelegate>
@property (nonatomic, assign) ZConfigMiniAppType configType;

@property (nonatomic, strong) UIView *viewContent;

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnHeader;
@property (nonatomic, assign) BOOL localImage;

@property (nonatomic, strong) UITextField *tfMiniAppName;
@property (nonatomic, strong) UITextField *tfMiniAppUrl;

@property (nonatomic, strong) UIButton *btnPassword;
@property (nonatomic, strong) UIView *viewPassword;
@property (nonatomic, strong) UITextField *tfPassword;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnSave;

//@property (nonatomic, strong)ZFileNetProgressManager *fileUploader;//图片上传
@end

@implementation SpecConfigMiniAppView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (instancetype)initMiniAppWith:(ZConfigMiniAppType)configType {
    self = [super init];
    if (self) {
        _configType = configType;
        
        self.tkThemebackgroundColors = @[HEXACOLOR(@"000000", 0.3), HEXACOLOR(@"000000", 0.3)];
        self.frame = CGRectMake(0, 0, DScreenWidth, DScreenHeight);
        [CurrentWindow addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(configMiniAppDismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        
        [self setupUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configMiniAppViewShow:) name:@"MiniAppSelectImage" object:nil];
    
    }
    return self;
}

#pragma mark - 通知监听
- (void)configMiniAppViewShow:(NSNotification *)notification {
    NSDictionary *userInfoDict = notification.userInfo;
    BOOL showMiniView = [[userInfoDict objectForKeySafe:@"OpenImagePicker"] boolValue];
    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.hidden = showMiniView;
    });
}

#pragma mark - 界面布局
- (void)setupUI {
    _viewContent = [[UIView alloc] initWithFrame:CGRectMake(DWScale(40), (DScreenHeight - DWScale(352)) / 2.0, DWScale(295), DWScale(352))];
    _viewContent.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    _viewContent.layer.cornerRadius = DWScale(15);
    _viewContent.layer.masksToBounds = YES;
    _viewContent.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
    [self addSubview:_viewContent];
    
    _lblTitle = [UILabel new];
    _lblTitle.text = _configType == ZConfigMiniAppTypeAdd ? MultilingualTranslation(@"新增应用") : MultilingualTranslation(@"编辑应用");
    _lblTitle.font = FONTB(18);
    _lblTitle.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    [_viewContent addSubview:_lblTitle];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_viewContent).offset(DWScale(20));
        make.top.equalTo(_viewContent).offset(DWScale(28));
        make.height.mas_equalTo(DWScale(28));
    }];
    
    _btnHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnHeader setImage:ImgNamed(@"remini_mini_app_add_gray") forState:UIControlStateNormal];
    _btnHeader.layer.cornerRadius = DWScale(16);
    _btnHeader.layer.masksToBounds = YES;
    [_btnHeader addTarget:self action:@selector(btnHeaderClick) forControlEvents:UIControlEventTouchUpInside];
    [_viewContent addSubview:_btnHeader];
    [_btnHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_viewContent).offset(DWScale(20));
        make.top.equalTo(_lblTitle.mas_bottom).offset(DWScale(11));
        make.size.mas_equalTo(CGSizeMake(DWScale(32), DWScale(32)));
    }];
    
    UILabel *lblHeader = [UILabel new];
    lblHeader.text = MultilingualTranslation(@"设置头像");
    lblHeader.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    lblHeader.font = FONTR(14);
    [_viewContent addSubview:lblHeader];
    [lblHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnHeader);
        make.leading.equalTo(_btnHeader.mas_trailing).offset(DWScale(9));
    }];
    lblHeader.textAlignment = NSTextAlignmentLeft;
    lblHeader.numberOfLines = 2;
    
    UILabel *lblHeaderTip = [UILabel new];
    lblHeaderTip.text = MultilingualTranslation(@"不设置头像自动生成");
    lblHeaderTip.font = FONTR(12);
    lblHeaderTip.tkThemetextColors = @[COLOR_99, COLOR_99_DARK];
    [_viewContent addSubview:lblHeaderTip];
    [lblHeaderTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnHeader);
        make.leading.equalTo(lblHeader.mas_trailing).offset(DWScale(20));
        make.trailing.equalTo(_viewContent).offset(-DWScale(20));
    }];
    lblHeader.textAlignment = NSTextAlignmentRight;
    lblHeaderTip.numberOfLines = 2;

    UIView *viewMiniAppName = [UIView new];
    viewMiniAppName.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_F5F6F9_DARK];
    viewMiniAppName.layer.cornerRadius = DWScale(8);
    viewMiniAppName.layer.masksToBounds = YES;
    [_viewContent addSubview:viewMiniAppName];
    [viewMiniAppName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnHeader.mas_bottom).offset(DWScale(9));
        make.centerX.equalTo(_viewContent);
        make.size.mas_equalTo(CGSizeMake(DWScale(255), DWScale(38)));
    }];
    
    _tfMiniAppName = [UITextField new];
    _tfMiniAppName.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    _tfMiniAppName.font = FONTR(14);
    NSAttributedString * attr = [[NSAttributedString alloc]initWithString:MultilingualTranslation(@"请输入应用名称")];
    _tfMiniAppName.attributedPlaceholder = attr;
    _tfMiniAppName.textAlignment = NSTextAlignmentLeft;
    [viewMiniAppName addSubview:_tfMiniAppName];
    [_tfMiniAppName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewMiniAppName);
        make.size.mas_equalTo(CGSizeMake(DWScale(235), DWScale(30)));
    }];
    
    UIView *viewMiniAppUrl = [UIView new];
    viewMiniAppUrl.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_F5F6F9_DARK];
    viewMiniAppUrl.layer.cornerRadius = DWScale(8);
    viewMiniAppUrl.layer.masksToBounds = YES;
    [_viewContent addSubview:viewMiniAppUrl];
    [viewMiniAppUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewMiniAppName.mas_bottom).offset(DWScale(12));
        make.centerX.equalTo(_viewContent);
        make.size.mas_equalTo(CGSizeMake(DWScale(255), DWScale(38)));
    }];
    
    _tfMiniAppUrl = [UITextField new];
    _tfMiniAppUrl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    _tfMiniAppUrl.font = FONTR(14);
    NSAttributedString * attrAppUrl = [[NSAttributedString alloc]initWithString:MultilingualTranslation(@"请输入链接")];
    _tfMiniAppUrl.attributedPlaceholder = attrAppUrl;
    _tfMiniAppUrl.textAlignment = NSTextAlignmentLeft;
    [viewMiniAppUrl addSubview:_tfMiniAppUrl];
    [_tfMiniAppUrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(viewMiniAppUrl);
        make.size.mas_equalTo(CGSizeMake(DWScale(235), DWScale(30)));
    }];
    
    UILabel *lblPassword = [UILabel new];
    lblPassword.text = MultilingualTranslation(@"开启密码");
    lblPassword.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    lblPassword.font = FONTR(14);
    [_viewContent addSubview:lblPassword];
    [lblPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_viewContent).offset(DWScale(20));
        make.top.equalTo(viewMiniAppUrl.mas_bottom).offset(DWScale(15));
        make.height.mas_equalTo(DWScale(19));
    }];
    
    _btnPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnPassword setImage:ImgNamed(@"remini_mini_app_switch_off") forState:UIControlStateNormal];
    [_btnPassword setImage:ImgNamed(@"remini_mini_app_switch_on") forState:UIControlStateSelected];
    _btnPassword.selected = NO;
    [_btnPassword addTarget:self action:@selector(btnPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [_viewContent addSubview:_btnPassword];
    [_btnPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblPassword);
        make.leading.equalTo(lblPassword.mas_trailing).offset(DWScale(9));
        make.size.mas_equalTo(CGSizeMake(DWScale(40), DWScale(19)));
    }];
    
    _viewPassword = [UIView new];
    _viewPassword.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_F5F6F9_DARK];
    _viewPassword.layer.cornerRadius = DWScale(8);
    _viewPassword.layer.masksToBounds = YES;
    _viewPassword.hidden = YES;
    [_viewContent addSubview:_viewPassword];
    [_viewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btnPassword.mas_bottom).offset(DWScale(10));
        make.centerX.equalTo(_viewContent);
        make.size.mas_equalTo(CGSizeMake(DWScale(255), DWScale(38)));
    }];
    
    _tfPassword = [UITextField new];
    _tfPassword.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    _tfPassword.font = FONTR(14);
    _tfPassword.placeholder = MultilingualTranslation(@"请输入访问密码");
    [_viewPassword addSubview:_tfPassword];
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_viewPassword);
        make.size.mas_equalTo(CGSizeMake(DWScale(235), DWScale(30)));
    }];
    
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
    [_btnCancel setTkThemeTitleColor:@[COLOR_66, COLOR_66_DARK] forState:UIControlStateNormal];
    [_btnCancel setTkThemebackgroundColors:@[HEXCOLOR(@"F6F6F6"), HEXCOLOR(@"F6F6F6")]];
    _btnCancel.titleLabel.font = FONTR(17);
    _btnCancel.layer.cornerRadius = DWScale(22);
    _btnCancel.layer.masksToBounds = YES;
    [_btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
    [_btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
    [_viewContent addSubview:_btnCancel];
    [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_viewContent).offset(DWScale(20));
        make.bottom.equalTo(_viewContent).offset(-DWScale(20));
        make.size.mas_equalTo(CGSizeMake(DWScale(99), DWScale(44)));
    }];
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSave setTitle:MultilingualTranslation(@"保存") forState:UIControlStateNormal];
    [_btnSave setTkThemeTitleColor:@[COLORWHITE, COLORWHITE_DARK] forState:UIControlStateNormal];
    [_btnSave setTkThemebackgroundColors:@[COLOR_81D8CF, COLOR_81D8CF_DARK]];
    _btnSave.titleLabel.font = FONTR(17);
    _btnSave.layer.cornerRadius = DWScale(22);
    _btnSave.layer.masksToBounds = YES;
    [_btnSave addTarget:self action:@selector(btnSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnSave setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
    [_btnSave setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
    [_viewContent addSubview:_btnSave];
    [_btnSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_viewContent).offset(-DWScale(20));
        make.bottom.equalTo(_viewContent).offset(-DWScale(20));
        make.size.mas_equalTo(CGSizeMake(DWScale(146), DWScale(44)));
    }];
    
}

- (void)configMiniAppShow {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.viewContent.transform = CGAffineTransformIdentity;
    }];
}

- (void)configMiniAppDismiss {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.viewContent.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
    } completion:^(BOOL finished) {
        [weakSelf.viewContent removeFromSuperview];
        weakSelf.viewContent = nil;
        
        [weakSelf removeFromSuperview];
    }];
}
#pragma mark - 界面赋值
- (void)setMiniAppModel:(LingIMMiniAppModel *)miniAppModel {
    if (miniAppModel) {
        _miniAppModel = miniAppModel;
        
        if (![NSString isNil:miniAppModel.qaAppPic]) {
            [_btnHeader sd_setImageWithURL:[miniAppModel.qaAppPic getImageFullUrl] forState:UIControlStateNormal placeholderImage:ImgNamed(@"remini_mini_app_icon") options:SDWebImageAllowInvalidSSLCertificates];
        }else {
            [_btnHeader setImage:ImgNamed(@"remini_mini_app_add_gray") forState:UIControlStateNormal];
        }
        
        _tfMiniAppName.text = miniAppModel.qaName;
        
        _tfMiniAppUrl.text = miniAppModel.qaAppUrl;
        
        if (miniAppModel.qaPwdOpen == 1) {
            //开启密码
            _viewPassword.hidden = NO;
            _tfPassword.text = miniAppModel.qaPwd;
            _btnPassword.selected = YES;
        }else {
            //关闭密码
            _viewPassword.hidden = YES;
            _tfPassword.text = @"";
            _btnPassword.selected = NO;
        }
        
    }
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_viewContent]) {
        return NO;
    }
    return YES;
}

#pragma mark - ZImagePickerVCDelegate
- (void)imagePickerVCCancel {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:@(NO) forKey:@"OpenImagePicker"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MiniAppSelectImage" object:nil userInfo:dict];
}

- (void)imagePickerClipImage:(UIImage *)resultImg localIdenti:(NSString *)localIdenti {
    [_btnHeader setImage:resultImg forState:UIControlStateNormal];
    _localImage = YES;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:@(NO) forKey:@"OpenImagePicker"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MiniAppSelectImage" object:nil userInfo:dict];
}

#pragma mark - 交互事件
- (void)btnHeaderClick {
    //先检测权限，再进入相册，解决某些系统第一次不能获取照片，杀死进程后可以获取照片的问题
    [ZTOOL getPhotoLibraryAuth:^(BOOL granted) {
        if (granted) {
            [ZTOOL doInMain:^{
                ZImagePickerVC *vc = [ZImagePickerVC new];
                vc.isSignlePhoto = YES;
                vc.isNeedEdit = YES;
                vc.hasCamera = YES;
                vc.delegate = self;
                [vc setPickerType:ZImagePickerTypeImage];
                [CurrentVC.navigationController pushViewController:vc animated:YES];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObjectSafe:@(YES) forKey:@"OpenImagePicker"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MiniAppSelectImage" object:nil userInfo:dict];
            }];
        }else {
            [HUD showWarningMessage:MultilingualTranslation(@"相册权限未开启，请在设置中选择当前应用，开启相册权限")];
        }
    }];
}

- (void)btnPasswordClick {
    _btnPassword.selected = !_btnPassword.selected;
    _viewPassword.hidden = !_btnPassword.selected;
    _tfPassword.text = @"";
    [_tfPassword resignFirstResponder];
}

- (void)btnCancelClick {
    [self configMiniAppDismiss];
}

- (void)btnSaveClick {
    
    __block NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *miniAppName = [_tfMiniAppName.text trimString];
    NSString *miniAppUrl = [_tfMiniAppUrl.text trimString];
    NSString *passwordStr = [_tfPassword.text trimString];
    
    if ([NSString isNil:miniAppName]) {
        [HUD showMessage:MultilingualTranslation(@"应用名称不能为空")];
        return;
    }
    
    if ([NSString isNil:miniAppUrl]) {
        [HUD showMessage:MultilingualTranslation(@"链接不能为空")];
        return;
    }
    if (![miniAppUrl checkStringIsUrl]) {
        [HUD showMessage:MultilingualTranslation(@"链接地址无效")];
        return;
    }
    
    if (_btnPassword.selected) {
        if ([NSString isNil:passwordStr]) {
            [HUD showMessage:MultilingualTranslation(@"访问密码不能为空")];
            return;
        }
    }
    
    if (_configType == ZConfigMiniAppTypeAdd) {
        //创建小程序
        [dict setObjectSafe:miniAppName forKey:@"qaName"];
        [dict setObjectSafe:miniAppUrl forKey:@"qaAppUrl"];
        if (_btnPassword.selected) {
            [dict setObjectSafe:passwordStr forKey:@"qaPwd"];
            [dict setObjectSafe:@(1) forKey:@"qaPwdOpen"];
        }else {
            [dict setObjectSafe:@(0) forKey:@"qaPwdOpen"];
        }
        
        if (_localImage) {
            //先上传图片
            [HUD showActivityMessage:@""];
            WeakSelf
            NSData *imageData = UIImageJPEGRepresentation(_btnHeader.imageView.image, 1.0);//转成jpeg
            NSData *comMassImageData = [UIImage compressImageSize:[UIImage imageWithData:imageData] toByte:50*1024];//压缩到50KB
            NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%lld.%@", UserManager.userInfo.userUID, [NSDate currentTimeIntervalWithMillisecond], [NSString getImageFileFormat:comMassImageData]];
            NSString *customPath = [NSString stringWithFormat:@"%@-%@", UserManager.userInfo.userUID, @"mini_app"];
                        
            __block NSString *imagePath = @"";
            [ZTOOL doAsync:^{
                [NSString saveImageToSaxboxWithData:comMassImageData CustomPath:customPath ImgName:fileName];
                imagePath = [NSString getPathWithImageName:fileName CustomPath:customPath];
            } completion:^{
                ZFileUploadTask *task = [[ZFileUploadTask alloc] initWithTaskId:fileName filePath:imagePath originFilePath:@"" fileName:fileName fileType:@"" isEncrypt:YES dataLength:comMassImageData.length uploadType:ZHttpUploadTypeMiniApp beSendMessage:nil delegate:nil];
               NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:^{
                   if (task.status == FileUploadTaskStatus_Completed) {
                       [dict setObjectSafe:task.originUrl forKey:@"qaAppPic"];
                       [weakSelf createMiniAppWith:dict];
                   } else {
                       [ZTOOL doInMain:^{
                           [HUD showMessage:MultilingualTranslation(@"上传头像失败")];
                       }];
                   }
                }];
               
                ZFileUploadGetSTSTask *getSTSTask = [[ZFileUploadGetSTSTask alloc] init];
                [task addDependency:getSTSTask];
                [blockOperation addDependency:task];
                
                [[ZFileUploadManager sharedInstance].operationQueue addOperation:getSTSTask];
                [[ZFileUploadManager sharedInstance] addUploadTask:task];
                [[ZFileUploadManager sharedInstance].operationQueue addOperation:blockOperation];
            }];
            
           
        }else {
            [self createMiniAppWith:dict];
        }
        
    }else {
        //编辑小程序
        if (!_miniAppModel) return;;
        
        [dict setObjectSafe:miniAppName forKey:@"qaName"];
        [dict setObjectSafe:miniAppUrl forKey:@"qaAppUrl"];
        //图片地址
        if (![NSString isNil:_miniAppModel.qaAppPic]) {
            [dict setObjectSafe:_miniAppModel.qaAppPic forKey:@"qaAppPic"];
        }
        //密码开启
        if (_btnPassword.selected) {
            [dict setObjectSafe:passwordStr forKey:@"qaPwd"];
            [dict setObjectSafe:@(1) forKey:@"qaPwdOpen"];
        }else {
            [dict setObjectSafe:@(0) forKey:@"qaPwdOpen"];
        }
        
        if (_localImage) {
            //先上传图片
            WeakSelf
            [HUD showActivityMessage:@""];
            NSData *imageData = UIImageJPEGRepresentation(_btnHeader.imageView.image, 1.0);//转成jpeg
            NSData *comMassImageData = [UIImage compressImageSize:[UIImage imageWithData:imageData] toByte:50*1024];//压缩到50KB
            NSString *fileName = [[NSString alloc] initWithFormat:@"%@_%lld.%@", UserManager.userInfo.userUID, [NSDate currentTimeIntervalWithMillisecond], [NSString getImageFileFormat:comMassImageData]];
            NSString *customPath = [NSString stringWithFormat:@"%@-%@", UserManager.userInfo.userUID, @"mini_app"];
            
            __block NSString *imagePath = @"";
            [ZTOOL doAsync:^{
                [NSString saveImageToSaxboxWithData:comMassImageData CustomPath:customPath ImgName:fileName];
                imagePath = [NSString getPathWithImageName:fileName CustomPath:customPath];
            } completion:^{
                ZFileUploadTask *task = [[ZFileUploadTask alloc] initWithTaskId:fileName filePath:imagePath originFilePath:@"" fileName:fileName fileType:@"" isEncrypt:YES dataLength:comMassImageData.length uploadType:ZHttpUploadTypeMiniApp beSendMessage:nil delegate:nil];
               NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:^{
                   if (task.status == FileUploadTaskStatus_Completed) {
                       [dict setObjectSafe:task.originUrl forKey:@"qaAppPic"];
                       [weakSelf editMiniAppWith:dict];
                   } else {
                       [ZTOOL doInMain:^{
                           [HUD showMessage:MultilingualTranslation(@"上传头像失败")];
                       }];
                   }
               }];
                
                ZFileUploadGetSTSTask *getSTSTask = [[ZFileUploadGetSTSTask alloc] init];
                [task addDependency:getSTSTask];
                [blockOperation addDependency:task];
                
                [[ZFileUploadManager sharedInstance].operationQueue addOperation:getSTSTask];
                [[ZFileUploadManager sharedInstance] addUploadTask:task];
                [[ZFileUploadManager sharedInstance].operationQueue addOperation:blockOperation];
            }];
        } else {
            [self editMiniAppWith:dict];
        }
    }
}

- (void)createMiniAppWith:(NSMutableDictionary *)dict {
    WeakSelf
    [IMSDKManager imMiniAppCreateWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = (NSDictionary *)data;
            LingIMMiniAppModel *miniAppNew = [LingIMMiniAppModel mj_objectWithKeyValues:dataDict];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(configMiniAppCreateWith:)]) {
                [weakSelf.delegate configMiniAppCreateWith:miniAppNew];
            }
        }
        
        [HUD showMessage:MultilingualTranslation(@"操作成功")];
        [weakSelf configMiniAppDismiss];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

- (void)editMiniAppWith:(NSMutableDictionary *)dict {
    if (_miniAppModel) {
        WeakSelf
        [dict setObjectSafe:_miniAppModel.qaUuid forKey:@"qaUuid"];
        
        [IMSDKManager imMiniAppEditWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDict = (NSDictionary *)data;
                LingIMMiniAppModel *tempMiniApp = [LingIMMiniAppModel mj_objectWithKeyValues:dataDict];
                //更新数据
                weakSelf.miniAppModel.qaName = tempMiniApp.qaName;
                weakSelf.miniAppModel.qaAppPic = tempMiniApp.qaAppPic;
                weakSelf.miniAppModel.qaAppUrl = tempMiniApp.qaAppUrl;
                weakSelf.miniAppModel.qaPwd = tempMiniApp.qaPwd;
                weakSelf.miniAppModel.qaPwdOpen = tempMiniApp.qaPwdOpen;
                weakSelf.miniAppModel.qaUuid = tempMiniApp.qaUuid;
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(configMiniAppEditWith:)]) {
                    [weakSelf.delegate configMiniAppEditWith:weakSelf.miniAppModel];
                }
            }
            
            [HUD showMessage:MultilingualTranslation(@"操作成功")];
            [weakSelf configMiniAppDismiss];
            
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
        
    }
}

#pragma mark - 懒加载
//- (ZFileNetProgressManager *)fileUploader {
//    if (!_fileUploader) {
//        _fileUploader = [[ZFileNetProgressManager alloc] init];
//    }
//    return _fileUploader;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
