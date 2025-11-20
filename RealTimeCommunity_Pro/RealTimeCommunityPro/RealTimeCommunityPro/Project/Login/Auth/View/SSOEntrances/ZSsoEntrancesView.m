//
//  ZSsoEntrancesView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/1.
//

#import "ZSsoEntrancesView.h"
#import "LoginCusViewController.h"

@interface ZSsoEntrancesView()

@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIView *tipLineView;
@property (nonatomic, strong)UILabel *serverTitleLbl;
@property (nonatomic, strong)UILabel *serverContentLbl;
@property (nonatomic, strong)UIButton *changeBtn;
@property (nonatomic, strong) ZSsoInfoModel *ssoInfoModel;
@end

@implementation ZSsoEntrancesView

- (instancetype)init {
    if (self = [super init]) {
        
        self.height = DWScale(132);
        [self setupUI];
        [self setupConstraints];
        [self initSSODataFromLocal];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.backView];
    [self.backView addSubview:self.tipLineView];
    [self.backView addSubview:self.serverTitleLbl];
    [self.backView addSubview:self.serverContentLbl];
    [self.backView addSubview:self.changeBtn];
}

- (void)setupConstraints {

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.mas_equalTo(DWScale(72));
    }];
    
    [self.tipLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backView).offset(DWScale(16));
        make.centerY.equalTo(self.backView);
        make.width.mas_equalTo(DWScale(4));
        make.height.mas_equalTo(DWScale(43));
    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.backView).offset(DWScale(-20));
        make.centerY.equalTo(self.backView);
        make.width.mas_equalTo(DWScale(80));
        make.height.mas_equalTo(DWScale(35));
    }];
    
    [self.serverTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tipLineView.mas_trailing).offset(DWScale(12));
        make.top.equalTo(self.backView).offset(DWScale(12));
        make.trailing.equalTo(self.backView).offset(-DWScale(12));
//        make.height.mas_equalTo(DWScale(16));
    }];
    
    [self.serverContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tipLineView.mas_trailing).offset(DWScale(12));
        make.top.equalTo(self.serverTitleLbl.mas_bottom).offset(DWScale(8));
        make.trailing.equalTo(self.changeBtn.mas_leading).offset(DWScale(-10));
//        make.height.mas_equalTo(DWScale(24));
    }];
}

#pragma mark - initSSO
- (void)initSSODataFromLocal {
    ZSsoInfoModel *ssoModel = [ZSsoInfoModel getSSOInfo];
    [self configSsoInfo:ssoModel];
}

- (void)configSsoInfo:(ZSsoInfoModel *)model {
    self.ssoInfoModel = model;
    //企业号/IP/域名
    if (![NSString isNil:model.liceseId]) {
        _serverContentLbl.text = model.liceseId;
    } else if (![NSString isNil:model.ipDomainPortStr]) {
        _serverContentLbl.text = model.ipDomainPortStr;
    } else {
        _serverContentLbl.text = [NSString stringWithFormat:@"%@/%@",MultilingualTranslation(@"企业号"),MultilingualTranslation(@"IP/域名")];
    }
}

#pragma mark - Action
- (void)ssoChangeAction {
    if (![NSString isNil:self.ssoInfoModel.liceseId]) {
        [[MMKV defaultMMKV] removeValueForKey:[NSString stringWithFormat:@"%@%@",CONNECT_LOCAL_CACHE,self.ssoInfoModel.liceseId]];
        [ZSsoInfoModel clearSSOInfoWithLiceseId:self.ssoInfoModel.liceseId];
    }
    
    // 跳转到登录页面
    UIViewController *currentVC = [self getCurrentViewController];
    if (currentVC && currentVC.navigationController) {
        LoginCusViewController *loginVC = [[LoginCusViewController alloc] init];
        [currentVC.navigationController pushViewController:loginVC animated:YES];
    }
}

// 获取当前视图控制器
- (UIViewController *)getCurrentViewController {
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

#pragma mark - Lazy

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.tkThemebackgroundColors = @[COLOR_F6F8FA, COLOR_F5F6F9_DARK];
        [_backView rounded:14 width:1 color:COLOR_EAEAEA];
    }
    return _backView;
}

- (UIView *)tipLineView {
    if (!_tipLineView) {
        _tipLineView = [[UIView alloc] init];
        _tipLineView.backgroundColor = COLOR_81D8CF;
        [_tipLineView rounded:2];
    }
    return _tipLineView;
}

- (UILabel *)serverTitleLbl {
    if (!_serverTitleLbl) {
        _serverTitleLbl = [[UILabel alloc] init];
        _serverTitleLbl.text = [NSString stringWithFormat:@"%@/%@",MultilingualTranslation(@"企业号"),MultilingualTranslation(@"IP/域名")];
        _serverTitleLbl.tkThemetextColors = @[COLOR_99, COLOR_99_DARK];
        _serverTitleLbl.font = FONTN(15);
    }
    return _serverTitleLbl;
}

- (UILabel *)serverContentLbl {
    if (!_serverContentLbl) {
        _serverContentLbl = [[UILabel alloc] init];
        _serverContentLbl.text = [NSString stringWithFormat:@"%@/%@",MultilingualTranslation(@"企业号"),MultilingualTranslation(@"IP/域名")];
        _serverContentLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        _serverContentLbl.font = FONTB(20);
        _serverContentLbl.numberOfLines = 2;
    }
    return _serverContentLbl;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc] init];
        [_changeBtn setTitle:[NSString stringWithFormat:@"%@>",MultilingualTranslation(@"更换")] forState:UIControlStateNormal];
        [_changeBtn setTkThemeTitleColor:@[COLOR_99, COLOR_99_DARK] forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = FONTN(12);
        [_changeBtn addTarget:self action:@selector(ssoChangeAction) forControlEvents:UIControlEventTouchUpInside];
        if (ZLanguageTOOL.isRTL) {
            _changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _changeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        } else {
            _changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _changeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        }
    }
    return _changeBtn;
}

@end
