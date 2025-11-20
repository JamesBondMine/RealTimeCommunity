//
//  NVContactHeaderView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/23.
//

#import "NVContactHeaderView.h"
#import "UIImage+YYImageHelper.h"
@interface NVContactHeaderView ()

@property (nonatomic, strong) UILabel *lblRedNum;
@property (nonatomic, strong) UIButton *btnNew;
@property (nonatomic, strong) UIButton *btnFile;
@property (nonatomic, strong) UIButton *btnGroupHelper;

@end

@implementation NVContactHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tkThemebackgroundColors = @[COLORWHITE,COLOR_33];
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    //新朋友
    _btnNew = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnNew setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
    [_btnNew addTarget:self action:@selector(btnNewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnNew];
    [_btnNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(DWScale(54));
    }];
    
    UILabel *lblNewFriend = [UILabel new];
    lblNewFriend.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    lblNewFriend.font = FONTR(16);
    lblNewFriend.text = MultilingualTranslation(@"新朋友");
    [_btnNew addSubview:lblNewFriend];
    [lblNewFriend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_btnNew).offset(DWScale(16));
        make.top.equalTo(_btnNew);
        make.height.mas_equalTo(DWScale(54));
    }];
    
    UIImageView *ivNew = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
    [_btnNew addSubview:ivNew];
    [ivNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblNewFriend);
        make.trailing.equalTo(_btnNew).offset(-DWScale(16));
        make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
    }];
    
    _lblRedNum = [UILabel new];
    _lblRedNum.textColor = COLORWHITE;
    _lblRedNum.font = FONTR(12);
    _lblRedNum.text = @" 0 ";
    _lblRedNum.backgroundColor = COLOR_F93A2F;
    _lblRedNum.layer.cornerRadius = DWScale(9);
    _lblRedNum.layer.masksToBounds = YES;
    _lblRedNum.hidden = YES;
    _lblRedNum.textAlignment = NSTextAlignmentCenter;
    [_btnNew addSubview:_lblRedNum];
    [_lblRedNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblNewFriend);
        make.trailing.equalTo(ivNew.mas_leading).offset(-DWScale(10));
        make.height.mas_equalTo(DWScale(18));
        make.width.mas_greaterThanOrEqualTo(DWScale(18));
    }];
    
    //文件助手
    _btnFile = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnFile setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
    [_btnFile addTarget:self action:@selector(btnFileClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnFile];
    
    UILabel *lblFile = [UILabel new];
    lblFile.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    lblFile.font = FONTR(16);
    lblFile.text = MultilingualTranslation(@"文件助手");
    [_btnFile addSubview:lblFile];
    [lblFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_btnFile).offset(DWScale(16));
        make.top.equalTo(_btnFile);
        make.height.mas_equalTo(DWScale(54));
    }];
    
    UIImageView *ivFile = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
    [_btnFile addSubview:ivFile];
    [ivFile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblFile);
        make.trailing.equalTo(_btnFile).offset(-DWScale(16));
        make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
    }];
    if ([UserManager.userRoleAuthInfo.isShowFileAssistant.configValue isEqualToString:@"true"]) {
        _btnFile.hidden = NO;
        [_btnFile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(DWScale(54));
            make.top.equalTo(_btnNew.mas_bottom);
        }];
    } else {
        _btnFile.hidden = YES;
        [_btnFile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(0);
            make.top.equalTo(_btnNew.mas_bottom);
        }];
    }
    
    //群助手
    _btnGroupHelper = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnGroupHelper setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
    [_btnGroupHelper addTarget:self action:@selector(btnHelperClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnGroupHelper];
    [_btnGroupHelper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.mas_equalTo(DWScale(54));
        make.top.equalTo(_btnFile.mas_bottom);
    }];
    
    UILabel *lblGroupHelper = [UILabel new];
    lblGroupHelper.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    lblGroupHelper.font = FONTR(16);
    lblGroupHelper.text = MultilingualTranslation(@"群助手");
    [_btnGroupHelper addSubview:lblGroupHelper];
    [lblGroupHelper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_btnGroupHelper).offset(DWScale(16));
        make.top.equalTo(_btnGroupHelper);
        make.height.mas_equalTo(DWScale(54));
    }];
    
    UIImageView *ivGroupHelper = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
    [_btnGroupHelper addSubview:ivGroupHelper];
    [ivGroupHelper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_btnGroupHelper);
        make.trailing.equalTo(_btnGroupHelper).offset(-DWScale(16));
        make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
    }];
}

- (void)updateUI {
    if ([UserManager.userRoleAuthInfo.isShowFileAssistant.configValue isEqualToString:@"true"]) {
        _btnFile.hidden = NO;
        [_btnFile mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(DWScale(54));
            make.top.equalTo(_btnNew.mas_bottom);
        }];
    } else {
        _btnFile.hidden = YES;
        [_btnFile mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.mas_equalTo(0);
            make.top.equalTo(_btnNew.mas_bottom);
        }];
    }
}

#pragma mark - 数据赋值
- (void)setNewFriendApplyNum:(NSInteger)newFriendApplyNum {
    _newFriendApplyNum = newFriendApplyNum;
    if (newFriendApplyNum > 0) {
        _lblRedNum.hidden = NO;
        if (newFriendApplyNum > 99) {
            _lblRedNum.text = @" 99+ ";
        }else {
            _lblRedNum.text = [NSString stringWithFormat:@"%ld",newFriendApplyNum];
        }
    }else {
        _lblRedNum.hidden = YES;
    }
}

#pragma mark - 交互事件
- (void)btnNewClick {
    if (_delegate && [_delegate respondsToSelector:@selector(contactHeaderAction:)]) {
        [_delegate contactHeaderAction:0];
    }
}
- (void)btnFileClick {
    if (_delegate && [_delegate respondsToSelector:@selector(contactHeaderAction:)]) {
        [_delegate contactHeaderAction:1];
    }
}
- (void)btnHelperClick {
    if (_delegate && [_delegate respondsToSelector:@selector(contactHeaderAction:)]) {
        [_delegate contactHeaderAction:2];
    }
}

@end
