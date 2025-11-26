//
//  ZAuthBannedAlertView.m
//  CIMKit
//
//  Created by cusPro on 2023/12/28.
//

#import "ZAuthBannedAlertView.h"

@interface ZAuthBannedAlertView()

@property (nonatomic, assign) ZAuthBannedAlertType alertType;
@property (nonatomic, strong) UIView *viewBg;

@end

@implementation ZAuthBannedAlertView

- (instancetype)initWithAlertType:(ZAuthBannedAlertType)alertType {
    self = [super init];
    if (self) {
        _alertType = alertType;
        [self setupUI];
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    self.frame = CGRectMake(0, 0, DScreenWidth, DScreenHeight);
    self.tkThemebackgroundColors = @[[COLOR_00 colorWithAlphaComponent:0.3],[COLOR_00 colorWithAlphaComponent:0.6]];
    [CurrentWindow addSubview:self];
    
    _viewBg = [UIView new];
    _viewBg.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    _viewBg.layer.cornerRadius = DWScale(8);
    _viewBg.layer.masksToBounds = YES;
    _viewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
    [self addSubview:_viewBg];
    
    //标题
    _lblTitle = [UILabel new];
    _lblTitle.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    _lblTitle.font = FONTR(16);
    _lblTitle.numberOfLines = 1;
    _lblTitle.preferredMaxLayoutWidth = DWScale(255);
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    [_viewBg addSubview:_lblTitle];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_viewBg);
        make.top.equalTo(_viewBg).offset(DWScale(26));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    //内容
    _lblContent = [UILabel new];
    _lblContent.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    _lblContent.font = FONTR(14);
    _lblContent.numberOfLines = 3;
    _lblContent.userInteractionEnabled = YES;
    _lblContent.backgroundColor = COLOR_CLEAR;
    _lblContent.preferredMaxLayoutWidth = DWScale(255);
    _lblContent.textAlignment = [ZTOOL RTLTextAlignment:NSTextAlignmentCenter];
    [_lblContent sizeToFit];
    [_viewBg addSubview:_lblContent];
    [_lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_viewBg);
        make.top.equalTo(_lblTitle.mas_bottom).offset(DWScale(16));
    }];
    
    //横线
    UIView *transverseLine = [[UIView alloc] init];
    transverseLine.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F6F6F6_DARK];
    [_viewBg addSubview:transverseLine];
    [transverseLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblContent.mas_bottom).offset(DWScale(26));
        make.leading.trailing.equalTo(_viewBg);
        make.height.mas_equalTo(0.5);
    }];
    
    if (_alertType == ZAuthBannedAlertTypeTwoBtn) {
        //竖线
        UIView *verticalLine = [[UIView alloc] init];
        verticalLine.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F6F6F6_DARK];
        [_viewBg addSubview:verticalLine];
        [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(transverseLine.mas_bottom);
            make.bottom.equalTo(_viewBg);
            make.centerX.equalTo(_viewBg);
            make.width.mas_equalTo(0.5);
        }];
        
        //退出登录
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCancel setTitle:MultilingualTranslation(@"退出登录") forState:UIControlStateNormal];
        [_btnCancel setTkThemeTitleColor:@[COLOR_33, COLOR_33_DARK] forState:UIControlStateNormal];
        [_btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
        [_btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
        _btnCancel.titleLabel.font = FONTN(12);
        _btnCancel.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        [_btnCancel addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_viewBg addSubview:_btnCancel];
        [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_viewBg);
            make.top.equalTo(transverseLine.mas_bottom);
            make.trailing.equalTo(verticalLine.mas_leading);
            make.height.mas_equalTo(DWScale(48));
            make.bottom.equalTo(_viewBg);
        }];
        
        //申请解封
        _btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSure setTitle:MultilingualTranslation(@"申请解封") forState:UIControlStateNormal];
        [_btnSure setTkThemeTitleColor:@[COLOR_4791FF, COLOR_4791FF_DARK] forState:UIControlStateNormal];
        [_btnSure setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
        [_btnSure setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
        _btnSure.titleLabel.font = FONTN(12);
        _btnSure.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        [_btnSure addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_viewBg addSubview:_btnSure];
        [_btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(verticalLine.mas_trailing);
            make.top.equalTo(transverseLine.mas_bottom);
            make.trailing.equalTo(_viewBg);
            make.height.mas_equalTo(DWScale(48));
            make.bottom.equalTo(_viewBg);
        }];
        
        [_viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(DWScale(295));
            make.top.equalTo(_lblTitle.mas_top).offset(-DWScale(26));
            make.bottom.equalTo(_btnCancel.mas_bottom);
        }];
    } else {
        //取消按钮
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCancel setTitle:MultilingualTranslation(@"退出登录") forState:UIControlStateNormal];
        [_btnCancel setTkThemeTitleColor:@[COLOR_33, COLOR_33_DARK] forState:UIControlStateNormal];
        [_btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
        [_btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
        _btnCancel.titleLabel.font = FONTN(12);
        _btnCancel.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        [_btnCancel addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_viewBg addSubview:_btnCancel];
        [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(_viewBg);
            make.top.equalTo(transverseLine.mas_bottom);
            make.height.mas_equalTo(DWScale(48));
            make.bottom.equalTo(_viewBg);
        }];
        
        [_viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(DWScale(295));
            make.top.equalTo(_lblTitle.mas_top).offset(-DWScale(26));
            make.bottom.equalTo(_btnCancel.mas_bottom);
        }];
    }
}

#pragma mark - 交互事件
- (void)alertTipViewSHow {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.viewBg.transform = CGAffineTransformIdentity;
    }];
}
- (void)alertTipViewDismiss {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.viewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
    } completion:^(BOOL finished) {
        [weakSelf.viewBg removeFromSuperview];
        weakSelf.viewBg = nil;
        [weakSelf removeFromSuperview];
    }];
}

- (void)sureBtnAction {
    if (self.sureBtnBlock) {
        self.sureBtnBlock();
    }
    [self alertTipViewDismiss];
}

- (void)cancelBtnAction {
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
    [self alertTipViewDismiss];
}


@end
