//
//  ZSignInViewController.m
//  CIMKit
//
//  Created by Apple on 2023/8/8.
//

#import "ZSignInViewController.h"
#import "ZRuleViewController.h" //签到规则
#import "ZSignRecordsViewController.h" //签到记录
#import "ZIntegralDetailViewController.h" //积分明细
#import "KLSICalendarView.h"
#import "KLSignInTool.h"
#import "KLConst.h"
#import "KLSignInModel.h"
#import "ZSignInRuleModel.h"

@interface ZSignInViewController ()
//@property (nonatomic, strong) SNBMHomeignInView *signInView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) KLSICalendarView *calendarView;
@property (nonatomic, strong) NSMutableArray *signedArray;
@property (nonatomic, strong) UILabel * signViewAtOneLabel;
@property (nonatomic, strong) UILabel * signViewAtOneTipLabel;
@property (nonatomic, strong) UILabel * signTotalCountLabel;
@property (nonatomic, strong) UILabel * pointLabelCountLabel;
@property (nonatomic, strong) UILabel * signPointsCountLabel;
@property(nonatomic,assign) NSInteger isSignIn;
@property(nonatomic,strong) NSArray * signInRecords;
@property(nonatomic,copy) NSString * totalLoyalty;
@property(nonatomic,strong)UILabel * todayGetPointLabel;//进入可领积分

@end

@implementation ZSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    self.navTitleStr = MultilingualTranslation(@"每日签到");
    [self signSetUI];
    [self requestGetSignInfo];
    [self requestSignWithRecord];
}

-(void)signSetUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DNavStatusBarH);
        make.leading.bottom.trailing.mas_equalTo(self.view);
    }];
    
    UIView *contentBackView = [[UIView alloc] init];
    contentBackView.backgroundColor = COLOR_CLEAR;
    [self.scrollView addSubview:contentBackView];
    [contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(DScreenWidth);
    }];
    
    //顶部背景图片
    UIImageView * signInBgImageView = [[UIImageView alloc] init];
    signInBgImageView.image = ImgNamed(@"remi_signIn_bg");
    [contentBackView addSubview:signInBgImageView];
    [signInBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(contentBackView);
        make.height.mas_equalTo(DWScale(293));
    }];
    
    //中间线
    UIView * lineSpaceView = [[UIView alloc] init];
    lineSpaceView.backgroundColor = HEXCOLOR(@"927BF7");
    [contentBackView addSubview:lineSpaceView];
    [lineSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentBackView);
        make.top.mas_equalTo(contentBackView.mas_top).offset(DWScale(33));
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(DWScale(27));
    }];
    
    //累计签到
    UILabel * signTotalCountLabel = [[UILabel alloc] init];
    signTotalCountLabel.text = @"-";
    signTotalCountLabel.textAlignment = NSTextAlignmentCenter;
    signTotalCountLabel.textColor = HEXCOLOR(@"FFFFFF");
    signTotalCountLabel.font = FONTB(20); // 商务风格：数字加粗放大
    [contentBackView addSubview:signTotalCountLabel];
    self.signTotalCountLabel = signTotalCountLabel;
    [signTotalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentBackView);
        make.trailing.mas_equalTo(lineSpaceView.mas_leading);
        make.top.mas_equalTo(contentBackView).offset(DWScale(20));
        make.height.mas_equalTo(DWScale(24));
    }];
    
    UILabel * signTotalLabel = [[UILabel alloc] init];
    signTotalLabel.text = MultilingualTranslation(@"累计签到");
    signTotalLabel.textColor = HEXCOLOR(@"FFFFFF");
    signTotalLabel.font = FONTR(14);
    signTotalLabel.textAlignment = NSTextAlignmentCenter;
    [contentBackView addSubview:signTotalLabel];
    [signTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentBackView);
        make.trailing.mas_equalTo(lineSpaceView.mas_leading);
        make.top.mas_equalTo(signTotalCountLabel.mas_bottom).offset(DWScale(8));
        make.height.mas_equalTo(DWScale(18));
    }];
    //累计签到-点击事件-跳转到签到记录
    UIControl *signTotalControl = [[UIControl alloc] init];
    [signTotalControl addTarget:self action:@selector(signInRecordListAction) forControlEvents:UIControlEventTouchUpInside];
    [contentBackView addSubview:signTotalControl];
    [signTotalControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentBackView);
        make.trailing.mas_equalTo(lineSpaceView.mas_leading);
        make.top.mas_equalTo(contentBackView).offset(DWScale(23));
        make.height.mas_equalTo(DWScale(44));
    }];
    
    //积分
    UILabel * signPointsCountLabel = [[UILabel alloc] init];
    signPointsCountLabel.text = @"-";
    signPointsCountLabel.textAlignment = NSTextAlignmentCenter;
    signPointsCountLabel.textColor = HEXCOLOR(@"FFFFFF");
    signPointsCountLabel.font = FONTB(20); // 商务风格：数字加粗放大
    [contentBackView addSubview:signPointsCountLabel];
    self.signPointsCountLabel = signPointsCountLabel;
    [signPointsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentBackView);
        make.leading.mas_equalTo(lineSpaceView.mas_trailing);
        make.top.mas_equalTo(contentBackView).offset(DWScale(20));
        make.height.mas_equalTo(DWScale(24));
    }];
    
    UILabel * signPointsLabel = [[UILabel alloc] init];
    signPointsLabel.text = MultilingualTranslation(@"积分");
    signPointsLabel.textColor = HEXCOLOR(@"FFFFFF");
    signPointsLabel.font = FONTR(14);
    signPointsLabel.textAlignment = NSTextAlignmentCenter;
    [contentBackView addSubview:signPointsLabel];
    [signPointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentBackView);
        make.leading.mas_equalTo(lineSpaceView.mas_trailing);
        make.top.mas_equalTo(signPointsCountLabel.mas_bottom).offset(DWScale(8));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    //积分-点击事件-跳转到积分明细
    UIControl *signIntergralControl = [[UIControl alloc] init];
    [signIntergralControl addTarget:self action:@selector(signInIntergralDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [contentBackView addSubview:signIntergralControl];
    [signIntergralControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentBackView).offset(DWScale(23));
        make.leading.mas_equalTo(lineSpaceView.mas_trailing);
        make.trailing.mas_equalTo(contentBackView);
        make.height.mas_equalTo(DWScale(44));
    }];
    
    //中间签到领积分区域
    UIView * middleView = [[UIView alloc] init];
    middleView.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
    // 商务风格：更小的圆角
    middleView.layer.cornerRadius = 6;
    middleView.layer.masksToBounds = NO; // 允许显示阴影
    // 商务风格：添加卡片阴影
    middleView.layer.shadowColor = [UIColor blackColor].CGColor;
    middleView.layer.shadowOffset = CGSizeMake(0, 2);
    middleView.layer.shadowOpacity = 0.08;
    middleView.layer.shadowRadius = 6;
    [contentBackView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentBackView).offset(16);
        make.trailing.mas_equalTo(contentBackView).offset(-16);
        make.top.mas_equalTo(signPointsLabel.mas_bottom).offset(DWScale(27));
        make.height.mas_equalTo(DWScale(274));
    }];
    
    UIButton * ruleAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [ruleAction setTitle:MultilingualTranslation(@"规则") forState:UIControlStateNormal];
    [ruleAction setTkThemeTitleColor:@[HEXCOLOR(@"7154F5"), HEXCOLOR(@"7154F5")] forState:UIControlStateNormal]; // 商务风格：使用品牌色
    ruleAction.titleLabel.font = FONTB(13); // 商务风格：加粗字体
    // 商务风格：添加按钮背景和圆角
    ruleAction.layer.cornerRadius = DWScale(4);
    ruleAction.layer.borderWidth = 1;
    ruleAction.layer.borderColor = [HEXCOLOR(@"7154F5") CGColor];
    ruleAction.contentEdgeInsets = UIEdgeInsetsMake(DWScale(4), DWScale(12), DWScale(4), DWScale(12));
    [ruleAction addTarget:self action:@selector(ruleGotoAction) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:ruleAction];
    [ruleAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(middleView.mas_trailing).offset(-12);
        make.top.mas_equalTo(middleView.mas_top).offset(12);
        make.height.mas_equalTo(DWScale(28));
    }];
    
    //签到盒子logo
    UIImageView * SignInGiftImgView = [[UIImageView alloc] init];
    SignInGiftImgView.image = ImgNamed(@"remi_Sign-in_gift_icon");
    [contentBackView addSubview:SignInGiftImgView];
    [SignInGiftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(contentBackView);
        make.top.mas_equalTo(lineSpaceView.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(DWScale(154), DWScale(138)));
    }];
    //签到领积分
    UILabel * signGetPointLabel = [[UILabel alloc] init];
    signGetPointLabel.text = MultilingualTranslation(@"签到领积分");
    signGetPointLabel.tkThemetextColors = @[HEXCOLOR(@"4B4B4C"), COLORWHITE];
    signGetPointLabel.font = FONTB(18); // 商务风格：加粗，字体更大
    signGetPointLabel.textAlignment = NSTextAlignmentCenter;
    [middleView addSubview:signGetPointLabel];
    [signGetPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_top).offset(DWScale(112));
        make.leading.mas_equalTo(middleView);
        make.trailing.mas_equalTo(middleView);
        make.height.mas_equalTo(DWScale(20));
    }];
    
    //今日可领积分
    UILabel * todayGetPointLabel = [[UILabel alloc] init];
    todayGetPointLabel.text = MultilingualTranslation(@"今日可领积分");
    float todayGetPointWidth = [todayGetPointLabel.text widthForFont:FONTR(12)] + 10;
    todayGetPointLabel.tkThemetextColors = @[COLOR_99, COLORWHITE];
    todayGetPointLabel.font = FONTR(12);
    todayGetPointLabel.textAlignment = NSTextAlignmentCenter;
    [middleView addSubview:todayGetPointLabel];
    self.todayGetPointLabel = todayGetPointLabel;
    [todayGetPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(middleView);
        make.top.mas_equalTo(signGetPointLabel.mas_bottom).offset(DWScale(12));
        make.width.mas_equalTo(DWScale(todayGetPointWidth));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    UIView * leftLineSpaceView = [[UIView alloc] init];
    leftLineSpaceView.tkThemebackgroundColors = @[HEXCOLOR(@"F7F3F9"), COLOR_99];
    [middleView addSubview:leftLineSpaceView];
    
    UIView * rightLineSpaceView = [[UIView alloc] init];
    rightLineSpaceView.tkThemebackgroundColors = @[HEXCOLOR(@"F7F3F9"), COLOR_99];
    [middleView addSubview:rightLineSpaceView];
    
    [leftLineSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(middleView.mas_leading).offset(DWScale(16));
        make.trailing.mas_equalTo(self.todayGetPointLabel.mas_leading).offset(DWScale(-10));
        make.centerY.mas_equalTo(self.todayGetPointLabel);
        make.height.mas_equalTo(1);
    }];
    [rightLineSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.todayGetPointLabel.mas_trailing).offset(DWScale(10));
        make.trailing.mas_equalTo(middleView.mas_trailing).offset(DWScale(-16));
        make.centerY.mas_equalTo(self.todayGetPointLabel);
        make.height.mas_equalTo(1);
    }];
    
    UILabel * pointLabelCountLabel = [[UILabel alloc] init];
    pointLabelCountLabel.text = @"--";
    pointLabelCountLabel.tkThemetextColors = @[HEXCOLOR(@"7154F5"), HEXCOLOR(@"7154F5")]; // 商务风格：使用品牌色，更醒目
    pointLabelCountLabel.textAlignment = NSTextAlignmentCenter;
    pointLabelCountLabel.font = FONTB(24); // 商务风格：字体更大更粗，突出重点
    [middleView addSubview:pointLabelCountLabel];
    self.pointLabelCountLabel = pointLabelCountLabel;
    [pointLabelCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(middleView);
        make.trailing.mas_equalTo(middleView);
        make.top.mas_equalTo(self.todayGetPointLabel.mas_bottom).offset(DWScale(8)); // 减小间距
        make.height.mas_equalTo(DWScale(28));
    }];
    
    UIView * signViewAction = [[UIView alloc] init];
    signViewAction.backgroundColor = HEXCOLOR(@"7154F5");
    // 商务风格：更小的圆角，更方正专业
    signViewAction.layer.cornerRadius = DWScale(6);
    signViewAction.layer.masksToBounds = NO; // 允许显示阴影
    // 商务风格：添加按钮阴影和高光效果
    signViewAction.layer.shadowColor = [HEXCOLOR(@"7154F5") CGColor];
    signViewAction.layer.shadowOffset = CGSizeMake(0, 3);
    signViewAction.layer.shadowOpacity = 0.3;
    signViewAction.layer.shadowRadius = 6;
    [middleView addSubview:signViewAction];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(atOnceSignAction)];
    [signViewAction addGestureRecognizer:tap];
    [signViewAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(middleView);
        make.bottom.equalTo(middleView.mas_bottom).offset(DWScale(-12)); // 增加底部间距
        make.width.mas_equalTo(DWScale(200)); // 按钮略宽一些，更有视觉冲击力
        make.height.mas_equalTo(DWScale(48)); // 固定高度，更规范
    }];
    
    UILabel * signViewAtOneLabel = [[UILabel alloc] init];
    signViewAtOneLabel.text = MultilingualTranslation(@"立即签到");
    signViewAtOneLabel.textColor = HEXCOLOR(@"FFFFFF");
    signViewAtOneLabel.font = FONTB(16); // 商务风格：加粗字体，更醒目
    signViewAtOneLabel.textAlignment = NSTextAlignmentCenter;
    signViewAtOneLabel.numberOfLines = 2;
    [signViewAction addSubview:signViewAtOneLabel];
    self.signViewAtOneLabel = signViewAtOneLabel;
    [signViewAtOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signViewAction.mas_top).offset(DWScale(8));
        make.leading.mas_equalTo(signViewAction.mas_leading).offset(DWScale(8));
        make.trailing.mas_equalTo(signViewAction.mas_trailing).offset(DWScale(-8));
    }];
    UILabel * signViewAtOneTipLabel = [[UILabel alloc] init];
    signViewAtOneTipLabel.textColor = HEXACOLOR(@"FFFFFF", 0.7); // 提高透明度，更易读
    signViewAtOneTipLabel.font = FONTR(11); // 字体稍大一点
    signViewAtOneTipLabel.textAlignment = NSTextAlignmentCenter;
    signViewAtOneTipLabel.numberOfLines = 2;
    [signViewAction addSubview:signViewAtOneTipLabel];
    self.signViewAtOneTipLabel = signViewAtOneTipLabel;
    [signViewAtOneTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signViewAtOneLabel.mas_bottom).offset(DWScale(2));
        make.bottom.mas_equalTo(signViewAction.mas_bottom).offset(DWScale(-8));
        make.leading.mas_equalTo(signViewAction.mas_leading).offset(DWScale(8));
        make.trailing.mas_equalTo(signViewAction.mas_trailing).offset(DWScale(-8));
    }];
    
    UILabel * currentDataLabel = [[UILabel alloc] init];
    currentDataLabel.text = [NSString stringWithFormat:@"%ld-%ld",[NSDate getYearWithCurrentDate],[NSDate getMonthWithCurrentDate]];
    currentDataLabel.tkThemetextColors = @[COLOR_00, COLORWHITE];
    currentDataLabel.font = FONTB(16); // 商务风格：加粗字体
    [contentBackView addSubview:currentDataLabel];
    
    UILabel * signInstructionsLabel = [[UILabel alloc] init];
    signInstructionsLabel.text = MultilingualTranslation(@"明天签到，您将会获得连签奖励");
    signInstructionsLabel.tkThemetextColors = @[COLOR_99, COLORWHITE];
    signInstructionsLabel.font = FONTR(12);
    signInstructionsLabel.textAlignment = NSTextAlignmentRight;
    [contentBackView addSubview:signInstructionsLabel];
    signInstructionsLabel.numberOfLines = 2;
    
    [currentDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentBackView.mas_leading).offset(16);
        make.top.mas_equalTo(middleView.mas_bottom).offset(DWScale(20));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    [signInstructionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentBackView.mas_trailing).offset(-16);
        make.centerY.mas_equalTo(currentDataLabel);
        make.leading.mas_equalTo(currentDataLabel.mas_trailing).offset(DWScale(16));
    }];
    
    UIView * spaceLineView = [[UIView alloc] init];
    spaceLineView.tkThemebackgroundColors = @[HEXCOLOR(@"7154F5"), HEXCOLOR(@"7154F5")];
    [contentBackView addSubview:spaceLineView];
    [spaceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(contentBackView.mas_leading).offset(16);
        make.trailing.mas_equalTo(contentBackView.mas_trailing).offset(-16);
        make.top.mas_equalTo(currentDataLabel.mas_bottom).offset(DWScale(7));
        make.height.mas_equalTo(1);
    }];
    self.calendarView.frame = CGRectMake(0, DWScale(413) +DNavStatusBarH , DScreenWidth, DWScale(310));
    [contentBackView addSubview:self.calendarView];
    self.calendarView.date = [NSDate date];
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(contentBackView);
        make.top.mas_equalTo(spaceLineView.mas_bottom);
        make.bottom.mas_equalTo(contentBackView.mas_bottom);
        make.height.mas_equalTo(DWScale(310));
    }];
}

// 签到记录
- (void)requestSignWithRecord
{
    WeakSelf;
    NSInteger year = [NSDate getYearWithCurrentDate];
    NSInteger month = [NSDate getMonthWithCurrentDate];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [dict setValue:@(year) forKey:@"year"];
    [dict setValue:@(month) forKey:@"month"];
    [IMSDKManager imSignInWithRecord:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        DLog(@"签到记录======%@",data);
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *signRecordDict = (NSDictionary *)data;
            NSArray * signInRecords = [signRecordDict objectForKey:@"signInRecords"];
            weakSelf.signInRecords = signInRecords;
            weakSelf.totalLoyalty = [signRecordDict objectForKey:@"totalLoyalty"];
            for (NSDictionary * signDict in signInRecords) {
                long long createTime = [[signDict objectForKey:@"createTime"] longLongValue];
                NSString * createTimeStr = [NSDate transTimeStrToDateMethod2:createTime];
                NSString *numberStr = [createTimeStr substringFromIndex:8];
                int signedNum = [numberStr intValue];
                [weakSelf.signedArray addObject:[NSNumber numberWithInt:signedNum]];
            }
            //设置已经签到的天数日期
            weakSelf.calendarView.signArray = weakSelf.signedArray;
        }
        weakSelf.calendarView.date = [NSDate date];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        //设置已经签到的天数日期
        weakSelf.calendarView.signArray = weakSelf.signedArray;
        weakSelf.calendarView.date = [NSDate date];
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//签到详情
-(void)requestGetSignInfo{
    WeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [IMSDKManager imSignInWithInfo:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        //DLog(@"签到详情=========%@",data);
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *signInfoDict = (NSDictionary *)data;
            //是否签到
            NSInteger isSignIn = [[signInfoDict objectForKey:@"isSignIn"] integerValue];
            weakSelf.isSignIn = isSignIn;
            if(isSignIn == 1){
                weakSelf.signViewAtOneLabel.text = MultilingualTranslation(@"今日已签到");
                weakSelf.todayGetPointLabel.text = MultilingualTranslation(@"今日已领积分");
            }
            weakSelf.pointLabelCountLabel.text = [NSString stringWithFormat:@"%@",[signInfoDict objectForKey:@"loyalty"]];
            weakSelf.signTotalCountLabel.text = [NSString stringWithFormat:@"%@",[signInfoDict objectForKey:@"signTotalDay"]];
            weakSelf.signPointsCountLabel.text = [NSString stringWithFormat:@"%@",[signInfoDict objectForKey:@"signTotalLoyalty"]];
            weakSelf.signViewAtOneTipLabel.text = [NSString stringWithFormat:MultilingualTranslation(@"本月已累计签到%@天"), [signInfoDict objectForKey:@"monthTotalDay"]];
        }
        [weakSelf requestSignWithRecord];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//获取签到规则
- (void)requestGetSignRule {
    WeakSelf;
    [HUD showActivityMessage:@""];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [IMSDKManager imSignInWithRule:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD hideHUD];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *ruleInfoDic = (NSDictionary *)data;
            ZSignInRuleModel *signRuleModel = [ZSignInRuleModel mj_objectWithKeyValues:ruleInfoDic];
            NSString *ruleContent = @"";
            if (signRuleModel.signMode == 1) {
                //随机签到
                ruleContent = [NSString stringWithFormat:MultilingualTranslation(@"1、每日签到积分由管理员设置一个最低值和最高值（例如区间值%d～%d），点击签到按钮后，即可获得本日签到积分。\n2、每日最多可签到1次，重复签到不会重复计数。\n3、积分只限本人使用，不可转移至其他账户。"), signRuleModel.signMinMoney, signRuleModel.signMaxMoney] ;
            }
            if (signRuleModel.signMode == 2) {
                //连续签到
                ruleContent = [NSString stringWithFormat:MultilingualTranslation(@"1、每日签到可以获得固定日签积分(%d分)，连续签到可以获得连签奖励。\n2、每日最多可签到1次，重复签到不会重复计数。\n3、当连续签到中断后，之前攒下的积分会保留，不会清零，但会重新累计连续签到天数。\n4、只要连签天数满足当月连续签到成功天数设置最大值，之后用户连签的每一天都将额外获得连签最大值的奖励积分。\n5、积分只限用户本人使用，不可转移至其他账户。"), signRuleModel.signDayMoney];
            }
            NSMutableAttributedString *ruleContentAttStr = [[NSMutableAttributedString alloc] initWithString:ruleContent];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 5;
            NSDictionary *dict = @{NSFontAttributeName:FONTR(14),NSParagraphStyleAttributeName:[style copy]};
            [ruleContentAttStr addAttributes:dict range:NSMakeRange(0, ruleContent.length)];
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(DScreenWidth - 16*2, CGFLOAT_MAX) text:ruleContentAttStr];
            //跳转
            ZRuleViewController * ruleVc = [[ZRuleViewController alloc] init];
            ruleVc.ruleContentAtt = ruleContentAttStr;
            ruleVc.ruleContentAttHeight = layout.textBoundingSize.height;
            ruleVc.signRuleModel = signRuleModel;
            [weakSelf.navigationController pushViewController:ruleVc animated:YES];
        } else {
            [HUD showMessage:MultilingualTranslation(@"操作失败")];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//- (void)configSignRuleContentWithSignModel:(NSInteger)signModel {
//    //signModel: 1：签到随机 2：连签模式
//    if (signModel == 1) {
//        //签到随机
//        self.signRule = MultilingualTranslation(@"1.每日签到积分由管理员设置一个最低值和最高值（例如区间值1～199），点击签到按钮后，即可获得本日签到积分。\n2.每日最多可签到1次，重复签到不会重复计数。\n3.积分只限本人使用，不可转移至其他账户。");
//    }
//    if (signModel == 2) {
//        //连签模式
//        self.signRule = MultilingualTranslation(@"1.每日签到可以获得固定日签积分，连续签到可以获得连签奖励。\n2.每日最多可签到1次，重复签到不会重复计数。\n3.当连续签到中断后，之前攒下的积分会保留，不会清零，但会重新累计连续签到天数。\n4.积分只限用户本人使用，不可转移至其他账户。");
//    }
//}


#pragma mark - Action
//积分明细
- (void)signInIntergralDetailAction {
    ZIntegralDetailViewController * signIntergralVC = [[ZIntegralDetailViewController alloc] init];
    [self.navigationController pushViewController:signIntergralVC animated:YES];
}

//签到记录
- (void)signInRecordListAction {
    ZSignRecordsViewController * signRecordsVC = [[ZSignRecordsViewController alloc] init];
    signRecordsVC.totalLoyalty = self.totalLoyalty;
    signRecordsVC.signInRecords = self.signInRecords;
    [self.navigationController pushViewController:signRecordsVC animated:YES];
}

//签到规则
-(void)ruleGotoAction{
    [self requestGetSignRule];
}

//签到
-(void)atOnceSignAction{
    //签到过后 不能再点击。
    if(self.isSignIn == 1){
        return;
    }
    
    WeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [IMSDKManager imSignInRecordWithSign:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        DLog(@"签到接口>>>>>>>%@",data);
        @try {
            //设置已经签到的天数日期
            NSDate *currentDate = [NSDate date]; // 当前时间
            NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setTimeZone:GTMzone];
            [dateFormat setLocale:[NSLocale currentLocale]];
            [dateFormat setDateFormat:@"yyyy-MM-d"];
            NSString *currentDateStr = [dateFormat stringFromDate:currentDate];
            int signedNum = [[currentDateStr substringFromIndex:8] intValue];
            [weakSelf.signedArray addObject:[NSNumber numberWithInt:signedNum]];
            weakSelf.calendarView.signArray = weakSelf.signedArray;
            weakSelf.calendarView.date = [NSDate date];
            [weakSelf requestGetSignInfo];
            NSString * showText = MultilingualTranslation(@"签到成功");
            if(data){
                NSDictionary * sDate = (NSDictionary*)data;
                NSInteger loyalty = [[sDate objectForKey:@"loyalty"] integerValue];
                showText= [NSString stringWithFormat:@"%@,+%ld",MultilingualTranslation(@"签到成功"),loyalty];
            }
            [HUD showMessage:showText];
        } @catch (NSException *exception) {
            KLog(@"查看崩溃日志");
        } @finally {
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
- (KLSICalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[KLSICalendarView alloc] init];
        _calendarView.date = [NSDate date];
    }
    return _calendarView;
}
-(NSMutableArray*)signedArray{
    if(_signedArray == nil){
        _signedArray = [NSMutableArray arrayWithCapacity:31];
    }
    return _signedArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
