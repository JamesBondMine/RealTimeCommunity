//
//  NMMyQRCodeViewController.m
//  CIMKit
//
//  Created by cusPro on 2023/4/3.
//

#import "NMMyQRCodeViewController.h"
#import "BBBaseImageView.h"
#import "UIImage+YYImageHelper.h"
#import "NHChatMultiSelectViewController.h"

@interface NMMyQRCodeViewController ()

@property (nonatomic,strong)UIImageView *qrCodeBgView;
@property (nonatomic,strong)BBBaseImageView * ivQrcode;

@end

@implementation NMMyQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self setupNavUI];
    [self setupUI];
}

#pragma mark - 界面布局
- (void)setupNavUI {
    self.navTitleStr = MultilingualTranslation(@"我的二维码");
    self.navBtnRight.hidden = YES;
}

- (void)setupUI {
    self.qrCodeBgView = [[UIImageView alloc] initWithImage:ImgNamed(@"regro_g_qrcode_bgiew")];
    [self.view addSubview:self.qrCodeBgView];
    [self.qrCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(DWScale(30));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DWScale(300), DWScale(400)));
    }];
    
    BBBaseImageView * userAvatar = [BBBaseImageView new] ;
    [userAvatar rounded:DWScale(25) width:2 color:COLORWHITE];
    [userAvatar sd_setImageWithURL:[UserManager.userInfo.avatar getImageFullUrl]  placeholderImage:DefaultAvatar options:SDWebImageAllowInvalidSSLCertificates];
    [self.qrCodeBgView addSubview:userAvatar];
    [userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(DWScale(22));
        make.leading.mas_equalTo(DWScale(25));
        make.size.mas_equalTo(CGSizeMake(DWScale(50), DWScale(50)));
    }];
    
    UILabel * userNameLabel = [UILabel new];
    userNameLabel.font = FONTB(18);
    userNameLabel.text = [NSString stringWithFormat:@"%@",UserManager.userInfo.nickname];
    userNameLabel.tkThemetextColors = @[COLORWHITE, COLORWHITE];
    [self.qrCodeBgView addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(userAvatar.mas_trailing).offset(DWScale(10));
        make.trailing.equalTo(self.qrCodeBgView.mas_trailing).offset(-DWScale(10));
        make.top.equalTo(userAvatar.mas_top).offset(DWScale(5));
        make.height.mas_equalTo(DWScale(25));
    }];
    
    UILabel * accountLbl = [UILabel new];
    accountLbl.font = FONTN(12);
    accountLbl.text = [NSString stringWithFormat:MultilingualTranslation(@"账号:%@"), UserManager.userInfo.userName];
    accountLbl.tkThemetextColors = @[[COLORWHITE colorWithAlphaComponent:0.7], [COLORWHITE
                                                                                colorWithAlphaComponent:0.7]];
    [self.qrCodeBgView addSubview:accountLbl];
    [accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(userAvatar.mas_trailing).offset(DWScale(10));
        make.leading.equalTo(userAvatar.mas_trailing).offset(DWScale(10));
        make.trailing.equalTo(self.qrCodeBgView.mas_trailing).offset(-DWScale(10));
        make.top.equalTo(userNameLabel.mas_bottom);
        make.height.mas_equalTo(DWScale(17));
    }];
    
    UIImageView * codeBgview =[UIImageView new];
    [self.qrCodeBgView addSubview:codeBgview];
    [codeBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrCodeBgView);
        make.bottom.mas_equalTo(self.qrCodeBgView).offset(-DWScale(26));
        make.size.mas_equalTo(CGSizeMake(DWScale(250), DWScale(250)));
    }];
    
    _ivQrcode = [BBBaseImageView new] ;
    UIImage *qrcodeImage = [UIImage getQRCodeImageWithString:self.qrcodeContent qrCodeColor:COLOR_00 inputCorrectionLevel:QRCodeInputCorrectionLevel_M];
    _ivQrcode.image = qrcodeImage;
    [codeBgview addSubview:_ivQrcode];
    [_ivQrcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(codeBgview);
        make.size.mas_equalTo(CGSizeMake(DWScale(230), DWScale(230)));
    }];
    
    UILabel * tipLbl1 = [UILabel new];
    tipLbl1.font = FONTR(14);
    tipLbl1.text = MultilingualTranslation(@"扫一扫我的二维码，添加我为好友。");
    tipLbl1.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    tipLbl1.textAlignment = NSTextAlignmentCenter;
    tipLbl1.numberOfLines = 0;
    [self.view addSubview:tipLbl1];
    [tipLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.qrCodeBgView);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.qrCodeBgView.mas_bottom).offset(DWScale(16));
    }];
    
    CGFloat btn_space = (DScreenWidth - DWScale(48)*2) / 3;
    //保存相册
    UIButton * savePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [savePhotoBtn setBackgroundColor:[UIColor whiteColor]];
    savePhotoBtn.layer.cornerRadius = DWScale(48/2);
    savePhotoBtn.clipsToBounds = YES;
    [savePhotoBtn setImage:ImgNamed(@"regro_g_savephoto_logo") forState:UIControlStateNormal];
    [savePhotoBtn addTarget:self action:@selector(savePhotoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savePhotoBtn];
    [savePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLbl1.mas_bottom).offset(DWScale(40));
        make.leading.equalTo(self.view).offset(btn_space);
        make.size.mas_equalTo(CGSizeMake(DWScale(48), DWScale(48)));
    }];
    
    UILabel * savetipLabel = [UILabel new];
    savetipLabel.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    savetipLabel.font = FONTR(13);
    savetipLabel.text = MultilingualTranslation(@"保存相册");
    savetipLabel.numberOfLines = 2;
    savetipLabel.textAlignment = NSTextAlignmentCenter;
    savetipLabel.preferredMaxLayoutWidth = DWScale(80);
    [self.view addSubview:savetipLabel];
    [savetipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(savePhotoBtn.mas_bottom).offset(DWScale(10));
        make.centerX.equalTo(savePhotoBtn);
    }];
    
    //分享二维码
    UIButton * shanerQRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shanerQRBtn setBackgroundColor:[UIColor whiteColor]];
    shanerQRBtn.layer.cornerRadius = DWScale(48/2);
    shanerQRBtn.clipsToBounds = YES;
    [shanerQRBtn setImage:ImgNamed(@"regro_g_share_logo") forState:UIControlStateNormal];
    [shanerQRBtn addTarget:self action:@selector(shareQRcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shanerQRBtn];
    [shanerQRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLbl1.mas_bottom).offset(DWScale(40));
        make.centerX.equalTo(savePhotoBtn.mas_trailing).offset(btn_space);
        make.size.mas_equalTo(CGSizeMake(DWScale(48), DWScale(48)));
    }];
    
    UILabel * sharetipLabel = [UILabel new];
    sharetipLabel.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    sharetipLabel.font = FONTR(13);
    sharetipLabel.text = MultilingualTranslation(@"分享");
    sharetipLabel.numberOfLines = 2;
    sharetipLabel.textAlignment = NSTextAlignmentCenter;
    sharetipLabel.preferredMaxLayoutWidth = DWScale(80);
    [self.view addSubview:sharetipLabel];
    [sharetipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shanerQRBtn.mas_bottom).offset(DWScale(10));
        make.centerX.equalTo(shanerQRBtn);
    }];
}

- (void)savePhotoBtnAction {
    UIGraphicsBeginImageContextWithOptions(self.qrCodeBgView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.qrCodeBgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)shareQRcodeBtnClick {
    UIGraphicsBeginImageContextWithOptions(self.qrCodeBgView.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.qrCodeBgView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //分享二维码
    NHChatMultiSelectViewController *vc = [NHChatMultiSelectViewController new];
    vc.multiSelectType = ZMultiSelectTypeShareQRImg;
    vc.fromSessionId = @"";
    vc.qrCodeImg = image;
    [self.navigationController pushViewController:vc animated:YES];
}
 
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = MultilingualTranslation(@"已保存至相册");
    } else {
        message = [error description];
    }
    [HUD showMessage:message];
}

@end
