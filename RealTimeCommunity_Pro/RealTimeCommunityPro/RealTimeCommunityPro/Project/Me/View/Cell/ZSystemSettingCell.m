//
//  ZSystemSettingCell.m
//  CIMKit
//
//  Created by cusPro on 2022/11/13.
//

#import "ZSystemSettingCell.h"

@interface ZSystemSettingCell ()

@property (nonatomic, strong)UIButton *backView;
@property (nonatomic, strong)UIButton *switchBtn;
@property (nonatomic, strong)UILabel *leftLbl;
@property (nonatomic, strong)UILabel *rightLbl;
@property (nonatomic, strong)UILabel *centerLbl;
@property (nonatomic, strong)UIImageView *arrowImgView;
@property (nonatomic, strong)UIView *lineView;

@end

@implementation ZSystemSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.switchBtn];
    [self.backView addSubview:self.leftLbl];
    [self.backView addSubview:self.rightLbl];
    [self.backView addSubview:self.centerLbl];
    [self.backView addSubview:self.arrowImgView];
    [self.backView addSubview:self.lineView];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.trailing.equalTo(self.backView).offset(-16);
        make.width.mas_equalTo(DWScale(8));
        make.height.mas_equalTo(DWScale(16));
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.trailing.equalTo(self.backView).offset(-16);
        make.width.mas_equalTo(DWScale(44));
        make.height.mas_equalTo(DWScale(44));
    }];
    
    [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.leading.equalTo(self.backView).offset(16);
        
        if ([ZLanguageTOOL.currentLanguage.languageName_zn isEqualToString:@"俄语"]) {
            make.width.mas_equalTo(DWScale(DScreenWidth - 120));
        } else {
            make.width.mas_equalTo(DWScale(150));
        }
        make.height.mas_equalTo(DWScale(22));
    }];
    
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.leading.equalTo(self.leftLbl.mas_trailing).offset(10);
        make.trailing.equalTo(self.arrowImgView.mas_leading).offset(-4);
        make.height.mas_equalTo(DWScale(20));
    }];
    
    [self.centerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.leading.equalTo(self.backView).offset(DWScale(15));
        make.trailing.equalTo(self.backView).offset(-DWScale(15));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView);
        make.leading.equalTo(self.backView).offset(16);
        make.trailing.equalTo(self.backView).offset(-16);
        make.height.mas_equalTo(0.8);
    }];
}

#pragma mark - Data
- (void)setLeftTitleStr:(NSString *)leftTitleStr {
    _leftTitleStr = leftTitleStr;
    self.leftLbl.text = _leftTitleStr;
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"新消息通知")]) {
        //新消息通知
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = NO;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = YES;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"声音")]) {
        //声音
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = NO;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = YES;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"震动")]) {
        //震动
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = NO;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = YES;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"内容翻译")]) {
        //内容翻译
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = YES;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = NO;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"字符管理")]) {
        //字符管理
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = YES;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = NO;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"检查更新")]) {
        //检查更新
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = YES;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = NO;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"清理缓存")]) {
        //清理缓存
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = YES;
        self.rightLbl.hidden = NO;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = NO;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"注销账号")]) {
        //注销账号
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = YES;
        self.rightLbl.hidden = NO;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = NO;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"翻译设置默认值")]) {
        //翻译设置默认值
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = YES;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = NO;
    }
    if ([leftTitleStr isEqualToString:MultilingualTranslation(@"翻译账户信息")]) {
        //翻译账户信息
        self.leftLbl.hidden = NO;
        self.switchBtn.hidden = YES;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = YES;
        self.arrowImgView.hidden = NO;
    }
}

- (void)setCenterTitleStr:(NSString *)centerTitleStr {
    _centerTitleStr = centerTitleStr;
    
    self.centerLbl.text = _centerTitleStr;
    if ([_centerTitleStr isEqualToString:MultilingualTranslation(@"退出登录")]) {
        //退出账号
        self.leftLbl.hidden = YES;
        self.switchBtn.hidden = YES;
        self.rightLbl.hidden = YES;
        self.centerLbl.hidden = NO;
        self.arrowImgView.hidden = YES;
    }
}

- (void)setRightTitleStr:(NSString *)rightTitleStr {
    _rightTitleStr = rightTitleStr;
    if ([self.leftLbl.text isEqualToString:MultilingualTranslation(@"清理缓存")] || [self.leftLbl.text isEqualToString:MultilingualTranslation(@"注销账号")]) {
        self.rightLbl.text = _rightTitleStr;
    }
}

- (void)setSwitchIsOn:(BOOL)switchIsOn {
    _switchIsOn = switchIsOn;
    self.switchBtn.selected = _switchIsOn;
}

- (void)configCellRoundWithCellIndex:(NSInteger)index totalIndex:(NSInteger)totalIndex {
    // 商务风格：更小的圆角(6)，添加阴影效果
    if (index == 0 && totalIndex == 1) {
        [self.backView round:6 RectCorners:UIRectCornerAllCorners];
        self.lineView.hidden = YES;
    } else {
        if (index == 0) {
            [self.backView round:6 RectCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
            self.lineView.hidden = NO;
        } else if (index == totalIndex - 1) {
            [self.backView round:6 RectCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
            self.lineView.hidden = YES;
        } else {
            [self.backView round:0 RectCorners:UIRectCornerAllCorners];
            self.lineView.hidden = NO;
        }
    }
    
    // 添加卡片阴影效果，增强层次感
    self.backView.layer.masksToBounds = NO;
    self.backView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0, 2);
    self.backView.layer.shadowOpacity = 0.06;
    self.backView.layer.shadowRadius = 4;
}

#pragma mark - Action
- (void)switchBtnAction {
    _switchBtn.selected = !_switchBtn.selected;
    if (self.switchBlock) {
        self.switchBlock(_switchBtn.selected);
    }
}

- (void)cellTouchAction {
    if ([self.baseDelegate respondsToSelector:@selector(cellClickAction:)]) {
        [self.baseDelegate cellClickAction:self.baseCellIndexPath];
    }
}

#pragma mark - Lazy
- (UIButton *)backView {
    if (!_backView) {
        _backView = [[UIButton alloc] init];
        _backView.frame = CGRectMake(16, 0, DScreenWidth - 16*2, DWScale(54));
        _backView.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [_backView setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
        [_backView setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
        [_backView addTarget:self action:@selector(cellTouchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backView;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] init];
        [_switchBtn setImage:ImgNamed(@"com_c_switch_off") forState:UIControlStateNormal];
        [_switchBtn setImage:ImgNamed(@"com_c_switch_on") forState:UIControlStateSelected];
        [_switchBtn addTarget:self action:@selector(switchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

- (UILabel *)leftLbl {
    if (!_leftLbl) {
        _leftLbl = [[UILabel alloc] init];
        _leftLbl.text = @"";
        _leftLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        _leftLbl.font = FONTN(15); // 商务风格：稍小字体
    }
    return _leftLbl;
}

- (UILabel *)rightLbl {
    if (!_rightLbl) {
        _rightLbl = [[UILabel alloc] init];
        _rightLbl.text = @"";
        _rightLbl.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
        _rightLbl.font = FONTN(14);
        _rightLbl.textAlignment = NSTextAlignmentRight;
    }
    return _rightLbl;
}

- (UILabel *)centerLbl {
    if (!_centerLbl) {
        _centerLbl = [[UILabel alloc] init];
        _centerLbl.text = @"";
        _centerLbl.tkThemetextColors = @[COLOR_FF3333, COLOR_FF3333_DARK];
        _centerLbl.font = FONTB(16); // 使用粗体，更突出
        _centerLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLbl;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = ImgNamed(@"com_c_arrow_right_gray");
    }
    return _arrowImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        // 商务风格：更淡的分隔线
        _lineView.tkThemebackgroundColors = @[[UIColor colorWithWhite:0 alpha:0.05], [UIColor colorWithWhite:1 alpha:0.05]];
    }
    return _lineView;
}

#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
