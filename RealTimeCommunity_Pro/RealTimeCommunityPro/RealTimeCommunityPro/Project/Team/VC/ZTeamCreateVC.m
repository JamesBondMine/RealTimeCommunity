//
//  ZTeamCreateVC.m
//  CIMKit
//
//  Created by cusPro on 2023/7/20.
//

#import "ZTeamCreateVC.h"

@interface ZTeamCreateVC ()
@property (nonatomic, strong) UITextField *tfTeam;
@end

@implementation ZTeamCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavUI];
    [self setupUI];
}

#pragma mark - 界面布局
- (void)setupNavUI {
    self.navTitleStr = MultilingualTranslation(@"新建团队");

    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:MultilingualTranslation(@"确定") forState:UIControlStateNormal];
    [self.navBtnRight setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
    [self.navBtnRight setTkThemebackgroundColors:@[COLORWHITE, COLOR_33]];
    [self.navBtnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBtnBack);
        make.trailing.equalTo(self.navView).offset(-DWScale(16));
        make.height.mas_equalTo(DWScale(28));
        make.width.mas_equalTo(DWScale(60));
    }];
}

- (void)setupUI {
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    
    UILabel *lblTip = [[UILabel alloc] init];
    lblTip.text = MultilingualTranslation(@"团队名称");
    lblTip.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    lblTip.font = FONTR(14);
    [self.view addSubview:lblTip];
    [lblTip mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(DWScale(10));
        make.leading.equalTo(self.view).offset(DWScale(23));
        make.width.mas_equalTo(DWScale(80));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    UIView *teamNameBackView = [[UIView alloc] init];
    teamNameBackView.tkThemebackgroundColors = @[COLORWHITE, COLORWHITE_DARK];
    [self.view addSubview:teamNameBackView];
    [teamNameBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTip.mas_bottom).offset(DWScale(8));
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    _tfTeam = [[UITextField alloc] init];
    _tfTeam.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tfTeam.text = @"";
    NSAttributedString * attr = [[NSAttributedString alloc]initWithString:MultilingualTranslation(@"团队名称")];
    _tfTeam.attributedPlaceholder = attr;
    _tfTeam.font = FONTR(14);
    _tfTeam.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    [teamNameBackView addSubview:_tfTeam];
    [_tfTeam mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(teamNameBackView);
        make.leading.equalTo(self.view).offset(DWScale(20));
        make.trailing.equalTo(self.view).offset(-DWScale(20));
        make.height.mas_equalTo(DWScale(40));
    }];
}
#pragma mark - 交互事件
- (void)navBtnRightClicked {
    //新建团队
    [self requestCreateNewTeam];
}

#pragma mark - Request
//新建团队
- (void)requestCreateNewTeam {
    NSString *teamNaem = [_tfTeam.text trimString];
    if (![NSString isNil:teamNaem]) {
        WeakSelf
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObjectSafe:teamNaem forKey:@"teamName"];
        [dict setObjectSafe:@(0) forKey:@"isDefaultTeam"];
        [IMSDKManager imTeamCreateWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            [HUD showMessage:MultilingualTranslation(@"操作成功")];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
    }
}

@end
