//
//  ZMessageAlertView.m
//  CIMKit
//
//  Created by cusPro on 2022/10/12.
//

#import "ZMessageAlertView.h"
#import "ZToolManager.h"

@interface ZMessageAlertView()

@property (nonatomic, assign) ZMessageAlertType alertType;
@property (nonatomic, strong) UIView *alertBackView;
@property (nonatomic, strong) UIButton *btnCheckBox;    //复选框
@property (nonatomic, strong) UIControl *checkBoxTap;
@property (nonatomic, strong) UIButton *btnClose;    //关闭按钮
@property (nonatomic, assign)UIView *supView;           //父视图

@end

@implementation ZMessageAlertView

- (instancetype)initWithMsgAlertType:(ZMessageAlertType)alertType supView:(UIView * _Nullable)supView {
    self = [super init];
    if (self) {
        _alertType = alertType;
        _isSelectCheckBox = NO;
        _supView = supView;
        [self setupUI];
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    self.frame = CGRectMake(0, 0, DScreenWidth, DScreenHeight);
    self.tkThemebackgroundColors = @[[COLOR_00 colorWithAlphaComponent:0.3],[COLOR_00 colorWithAlphaComponent:0.6]];
    if (_supView) {
        [_supView addSubview:self];
    } else {
        [CurrentWindow addSubview:self];
    }

    
    //白色背景
    _alertBackView = [UIView new];
    _alertBackView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [_alertBackView rounded:DWScale(14)];
    _alertBackView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
    [self addSubview:_alertBackView];
    
    //关闭按钮
    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnClose setImage:ImgNamed(@"relogimg_icon_sso_help_close_reb") forState:UIControlStateNormal];
    _btnClose.hidden = YES;
    [_btnClose addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertBackView addSubview:_btnClose];
    [_btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_alertBackView).offset(-DWScale(14));
        make.top.equalTo(_alertBackView).offset(DWScale(14));
        make.width.mas_equalTo(DWScale(15));
        make.height.mas_equalTo(DWScale(15));
    }];
    
    //标题
    _lblTitle = [UILabel new];
    _lblTitle.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    _lblTitle.font = FONTB(16);
    _lblTitle.numberOfLines = 0;
    _lblTitle.preferredMaxLayoutWidth = DWScale(255);
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    [_alertBackView addSubview:_lblTitle];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_alertBackView).offset(DWScale(30));
        make.leading.equalTo(_alertBackView).offset(DWScale(30));
        make.trailing.equalTo(_alertBackView).offset(-DWScale(30));
//        make.height.mas_equalTo(DWScale(22));
    }];
    
    //内容
    _lblContent = [UILabel new];
    _lblContent.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    _lblContent.font = FONTR(15);
    _lblContent.numberOfLines = 4;
    _lblContent.preferredMaxLayoutWidth = DWScale(255);
    _lblContent.textAlignment = NSTextAlignmentCenter;
    [_lblContent sizeToFit];
    [_alertBackView addSubview:_lblContent];
    [_lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_alertBackView);
        make.top.equalTo(_lblTitle.mas_bottom).offset(DWScale(17));
    }];
    
    //取消按钮
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
    [_btnCancel setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
    _btnCancel.tkThemebackgroundColors = @[COLOR_4791FF,COLOR_4791FF_DARK];
    [_btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
    [_btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
    _btnCancel.titleLabel.font = FONTN(17);
    [_btnCancel rounded:DWScale(22)];
    [_btnCancel addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertBackView addSubview:_btnCancel];
    [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_alertBackView).offset(DWScale(20));
        make.top.equalTo(_lblContent.mas_bottom).offset(DWScale(30));
        make.width.mas_equalTo(DWScale(99));
        make.height.mas_equalTo(DWScale(44));
    }];
    
    //确定按钮
    _btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSure setTitle:MultilingualTranslation(@"是") forState:UIControlStateNormal];
    [_btnSure setTkThemeTitleColor:@[COLOR_FF3333, COLOR_FF3333] forState:UIControlStateNormal];
    _btnSure.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F5F6F9_DARK];
    [_btnSure setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
    [_btnSure setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
    _btnSure.titleLabel.font = FONTN(17);
    [_btnSure rounded:DWScale(22)];
    [_btnSure addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_alertBackView addSubview:_btnSure];
    [_btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_alertBackView.mas_trailing).offset(DWScale(-20));
        make.top.equalTo(_lblContent.mas_bottom).offset(DWScale(30));
        make.width.mas_equalTo(DWScale(146));
        make.height.mas_equalTo(DWScale(44));
    }];
    
    //复选框 + 复选框后面的文字说明
    _checkboxLblContent = [UILabel new];
    _checkboxLblContent.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    _checkboxLblContent.font = FONTR(14);
    _checkboxLblContent.preferredMaxLayoutWidth = DWScale(255);
    _checkboxLblContent.textAlignment = NSTextAlignmentCenter;
    [_checkboxLblContent sizeToFit];
    [_alertBackView addSubview:_checkboxLblContent];
    [_checkboxLblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_alertBackView);
        make.top.equalTo(_btnSure.mas_bottom).offset(DWScale(17));
        make.height.mas_equalTo(DWScale(22));
        make.bottom.equalTo(_alertBackView).offset(DWScale(-17));
    }];
    
    _btnCheckBox = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCheckBox setImage:ImgNamed(@"relogimg_checkbox_unselected_reb") forState:UIControlStateNormal];
    [_btnCheckBox setImage:ImgNamed(@"relogimg_checkbox_selected_reb") forState:UIControlStateSelected];
    _btnCheckBox.selected = NO;
    [_alertBackView addSubview:_btnCheckBox];
    [_btnCheckBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_checkboxLblContent);
        make.trailing.equalTo(_checkboxLblContent.mas_leading).offset(-4);
        make.width.height.mas_equalTo(DWScale(16));
    }];
    
    _checkBoxTap = [[UIControl alloc] init];
    [_checkBoxTap addTarget:self action:@selector(checkboxBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _checkBoxTap.backgroundColor = COLOR_CLEAR;
    [_alertBackView addSubview:_checkBoxTap];
    [_checkBoxTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_checkboxLblContent);
        make.leading.equalTo(_btnCheckBox.mas_leading);
        make.trailing.equalTo(_checkboxLblContent);
        make.height.mas_equalTo(DWScale(22));
    }];
    
    //是否显示复选框及文本内容或者标题
    switch (_alertType) {
        case ZMessageAlertTypeNomal:
        {
            [_lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(0));
            }];
            [_lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lblTitle.mas_top);
            }];
            [_checkboxLblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(0));
            }];
            [_btnCheckBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(0));
            }];
        }
            break;
        case ZMessageAlertTypeCheckBox:
        {
            [_lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(0));
            }];
            [_lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lblTitle.mas_top);
            }];
            [_checkboxLblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(22));
            }];
            [_btnCheckBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(16));
            }];
        }
            break;
        case ZMessageAlertTypeTitle:
        {
//            [_lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(DWScale(22));
//            }];
            [_lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lblTitle.mas_bottom).offset(DWScale(17));
            }];
            [_checkboxLblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(0));
            }];
            [_btnCheckBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(0));
            }];
        }
            break;
        case ZMessageAlertTypeSingleBtn:
        {
//            [_lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(DWScale(22));
//            }];
            [_lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lblTitle.mas_bottom).offset(DWScale(17));
            }];
            [_checkboxLblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(0));
            }];
            [_btnCheckBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(0));
            }];
            
            [_btnCancel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(DWScale(0));
            }];
            
            [_btnSure mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_alertBackView).offset(DWScale(20));
                make.trailing.equalTo(_alertBackView).offset(DWScale(-20));
                make.top.equalTo(_lblContent.mas_bottom).offset(DWScale(30));
                make.height.mas_equalTo(DWScale(44));
            }];
        }
            break;
        case ZMessageAlertTypeTitleCheckBox:
        {
//            [_lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(DWScale(22));
//            }];
            [_lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lblTitle.mas_bottom).offset(DWScale(17));
            }];
            [_checkboxLblContent mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(22));
            }];
            [_btnCheckBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(DWScale(16));
            }];
        }
        default:
            break;
    }
    
    [_alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(DWScale(295));
        make.top.equalTo(_lblTitle.mas_top).offset(DWScale(-30));
        make.bottom.equalTo(_checkboxLblContent.mas_bottom).offset(17);
    }];
}

- (void)setShowClose:(BOOL)showClose {
    _showClose = showClose;
    
    _btnClose.hidden = !_showClose;
}

//显示
- (void)alertShow {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alertBackView.transform = CGAffineTransformIdentity;
    }];
    self.isShow = YES;
}

//消失
- (void)alertDismiss {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alertBackView.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
    } completion:^(BOOL finished) {
        [weakSelf.alertBackView removeFromSuperview];
        weakSelf.alertBackView = nil;
        [weakSelf removeFromSuperview];
    }];
    self.isShow = NO;
}

- (void)setIsSizeDivide:(BOOL)isSizeDivide {
    _isSizeDivide = isSizeDivide;
    if (isSizeDivide) {
        [_btnCancel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_alertBackView).offset(DWScale(20));
            make.top.equalTo(_lblContent.mas_bottom).offset(DWScale(30));
            make.trailing.mas_equalTo(_alertBackView.mas_centerX).offset(DWScale(-10));
            make.height.mas_equalTo(DWScale(44));
        }];
        
        [_btnSure mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(_alertBackView.mas_trailing).offset(DWScale(-20));
            make.top.equalTo(_lblContent.mas_bottom).offset(DWScale(30));
            make.width.mas_equalTo(_btnCancel);
            make.height.mas_equalTo(DWScale(44));
        }];
    }
}

#pragma mark - 交互事件
- (void)sureBtnAction {
    if (self.sureBtnBlock) {
        self.sureBtnBlock(self.isSelectCheckBox);
    }
    [self alertDismiss];
}

- (void)cancelBtnAction {
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
    if (_showClose == NO) {
        [self alertDismiss];
    }
}

- (void)closeBtnAction {
    [self alertDismiss];
}

- (void)checkboxBtnAction {
    self.btnCheckBox.selected = !self.btnCheckBox.selected;
    self.isSelectCheckBox = self.btnCheckBox.selected;
}


@end
