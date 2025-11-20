//
//  NMTranslateSetDefaultViewController.m
//  CIMKit
//
//  Created by cusPro on 2024/2/18.
//

#import "NMTranslateSetDefaultViewController.h"
#import "HomeTranslateSettingCell.h"
#import "HomeTranslateChannelLanguageView.h"
#import "ZTranslateDefaultModel.h"

@interface NMTranslateSetDefaultViewController ()<UITableViewDelegate, UITableViewDataSource, ZBaseCellDelegate, HomeTranslateChannelLanguageViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZTranslateDefaultModel *defaultModel;
@property (nonatomic, strong) LingIMSessionModel * sessionModel;
@end

@implementation NMTranslateSetDefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //翻译设置默认值
    self.navTitleStr = MultilingualTranslation(@"翻译管理");
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self setupDefaultData];
    [self setupUI];
    [self requestDefaultData];
}

- (void)requestDefaultData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (![NSString isNil:UserManager.userInfo.userUID]) {
        [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    }
    WeakSelf
    [[LingIMSDKManager sharedTool] userTranslateDefaultWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if (data) {
            weakSelf.defaultModel = [ZTranslateDefaultModel mj_objectWithKeyValues:data];
            weakSelf.sessionModel.receiveTranslateChannel = weakSelf.defaultModel.receiveChannel;
            weakSelf.sessionModel.receiveTranslateChannelName = weakSelf.defaultModel.receiveChannelName;
            weakSelf.sessionModel.receiveTranslateLanguage = weakSelf.defaultModel.receiveTargetLang;
            weakSelf.sessionModel.receiveTranslateLanguageName = weakSelf.defaultModel.receiveTargetLangName;
            weakSelf.sessionModel.sendTranslateChannel = weakSelf.defaultModel.sendChannel;
            weakSelf.sessionModel.sendTranslateChannelName = weakSelf.defaultModel.sendChannelName ;
            weakSelf.sessionModel.sendTranslateLanguage = weakSelf.defaultModel.sendTargetLang;
            weakSelf.sessionModel.sendTranslateLanguageName = weakSelf.defaultModel.sendTargetLangName;
            [weakSelf.baseTableView reloadData];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

- (void)setupDefaultData {
    [self.dataArr removeAllObjects];
    [self.dataArr addObject: @[MultilingualTranslation(@"消息翻译默认值"), MultilingualTranslation(@"通道"), MultilingualTranslation(@"语种")]];
    [self.dataArr addObject:@[MultilingualTranslation(@"发送翻译默认值"), MultilingualTranslation(@"通道"), MultilingualTranslation(@"语种")]];
}

- (void)setupUI {
    self.baseTableViewStyle = UITableViewStyleGrouped;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.bounces = NO;
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DNavStatusBarH);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
    }];
    
    [self.baseTableView registerClass:[HomeTranslateSettingCell class] forCellReuseIdentifier:NSStringFromClass([HomeTranslateSettingCell class])];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *itemArr = (NSArray *)[self.dataArr objectAtIndex:section];
    return itemArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(54);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DWScale(16);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DWScale(16))];
    headerView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTranslateSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTranslateSettingCell class]) forIndexPath:indexPath];
    NSArray *itemArr = (NSArray *)[self.dataArr objectAtIndex:indexPath.section];
    if (indexPath.section == 0) {
        cell.leftTitleStr = (NSString *)[itemArr objectAtIndex:indexPath.row];
        if (indexPath.row == 1) {
            cell.rightTitleStr = ![NSString isNil:self.defaultModel.receiveChannelName] ? self.defaultModel.receiveChannelName : MultilingualTranslation(@"请选择");
        }
        if (indexPath.row == 2) {
            cell.rightTitleStr = ![NSString isNil:self.defaultModel.receiveTargetLangName] ? self.defaultModel.receiveTargetLangName : MultilingualTranslation(@"请选择");
        }
    }
    if (indexPath.section == 1) {
        cell.leftTitleStr = (NSString *)[itemArr objectAtIndex:indexPath.row];
        if (indexPath.row == 1) {
            cell.rightTitleStr = ![NSString isNil:self.defaultModel.sendChannelName] ? self.defaultModel.sendChannelName : MultilingualTranslation(@"请选择");
        }
        if (indexPath.row == 2) {
            cell.rightTitleStr = ![NSString isNil:self.defaultModel.sendTargetLangName] ? self.defaultModel.sendTargetLangName : MultilingualTranslation(@"请选择");
        }
    }
    [cell configCellRoundWithCellIndex:indexPath.row totalIndex:itemArr.count];
    cell.baseCellIndexPath = indexPath;
    cell.baseDelegate = self;
   
    return cell;
}

- (void)cellClickAction:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeTranslateChannelLanguageView *selectedView;
        if (indexPath.row == 1) {
            //接收消息翻译通道
            selectedView = [[HomeTranslateChannelLanguageView alloc] initWithTranslateType:ZReceiveMsgTranslateTypeChannel sessionModel:self.sessionModel];
            selectedView.delegate = self;
            [selectedView channelLanguageViewShow];
        }
        if (indexPath.row == 2) {
            //接收消息翻译语种
            if (![NSString isNil:self.defaultModel.receiveChannel]) {
                selectedView = [[HomeTranslateChannelLanguageView alloc] initWithTranslateType:ZReceiveMsgTranslateTypeLanguage sessionModel:self.sessionModel];
                selectedView.delegate = self;
                [selectedView channelLanguageViewShow];
            } else {
                //请先选择通道
                [HUD showMessage:MultilingualTranslation(@"请先选择消息翻译的通道")];
                selectedView = [[HomeTranslateChannelLanguageView alloc] initWithTranslateType:ZReceiveMsgTranslateTypeChannel sessionModel:self.sessionModel];
                selectedView.delegate = self;
                [selectedView channelLanguageViewShow];
            }
        }
    }
    
    if (indexPath.section == 1) {
        HomeTranslateChannelLanguageView *selectedView;
        if (indexPath.row == 1) {
            //发送消息翻译通道
            selectedView = [[HomeTranslateChannelLanguageView alloc] initWithTranslateType:ZSendMsgTranslateTypeChannel sessionModel:self.sessionModel];
            selectedView.delegate = self;
            [selectedView channelLanguageViewShow];
        }
        if (indexPath.row == 2) {
            //发送消息翻译语种
            if (![NSString isNil:self.defaultModel.sendChannel]) {
                selectedView = [[HomeTranslateChannelLanguageView alloc] initWithTranslateType:ZSendMsgTranslateTypeLanguage sessionModel:self.sessionModel];
                selectedView.delegate = self;
                [selectedView channelLanguageViewShow];
            } else {
                //请先选择通道
                [HUD showMessage:MultilingualTranslation(@"请先选择发送翻译的通道")];
                selectedView = [[HomeTranslateChannelLanguageView alloc] initWithTranslateType:ZSendMsgTranslateTypeChannel sessionModel:self.sessionModel];
                selectedView.delegate = self;
                [selectedView channelLanguageViewShow];
            }
        }
    }
}

#pragma mark - HomeTranslateChannelLanguageViewDelegate
- (void)selectActionFinishWithSessionModel:(nonnull LingIMSessionModel *)sessionModel translateType:(ZMsgTranslateType)translateType{
    self.sessionModel = sessionModel;
    switch (translateType) {
        case ZReceiveMsgTranslateTypeChannel:
            //接收-翻译通道
            self.defaultModel.receiveChannel        = self.sessionModel.receiveTranslateChannel;
            self.defaultModel.receiveChannelName    = self.sessionModel.receiveTranslateChannelName;
            self.defaultModel.receiveTargetLang     = @"";
            self.defaultModel.receiveTargetLangName = @"";
            break;
        case ZReceiveMsgTranslateTypeLanguage:
            self.defaultModel.receiveTargetLang     = self.sessionModel.receiveTranslateLanguage;
            self.defaultModel.receiveTargetLangName = self.sessionModel.receiveTranslateLanguageName;
            break;
        case ZSendMsgTranslateTypeChannel:
            self.defaultModel.sendChannel           = self.sessionModel.sendTranslateChannel;
            self.defaultModel.sendChannelName       = self.sessionModel.sendTranslateChannelName;
            self.defaultModel.sendTargetLang        = @"";
            self.defaultModel.sendTargetLangName    = @"";
            break;
        case ZSendMsgTranslateTypeLanguage:
            self.defaultModel.sendTargetLang        = self.sessionModel.sendTranslateLanguage;
            self.defaultModel.sendTargetLangName    = self.sessionModel.sendTranslateLanguageName;
            break;
        default:
            break;
    }
    [self.baseTableView reloadData];
    //调用接口
    [self requestUploadTranslateSetting];
}

- (void)requestUploadTranslateSetting {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:self.defaultModel.sendChannel forKey:@"sendChannel"];
    [dict setObjectSafe:self.defaultModel.sendChannelName forKey:@"sendChannelName"];
    [dict setObjectSafe:self.defaultModel.sendTargetLang forKey:@"sendTargetLang"];
    [dict setObjectSafe:self.defaultModel.sendTargetLangName forKey:@"sendTargetLangName"];
    [dict setObjectSafe:self.defaultModel.receiveChannel forKey:@"receiveChannel"];
    [dict setObjectSafe:self.defaultModel.receiveChannelName forKey:@"receiveChannelName"];
    [dict setObjectSafe:self.defaultModel.receiveTargetLang forKey:@"receiveTargetLang"];
    [dict setObjectSafe:self.defaultModel.receiveTargetLangName forKey:@"receiveTargetLangName"];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    
    [IMSDKManager userTranslateDefaultUpload:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD showMessage:MultilingualTranslation(@"设置成功")];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
       
    }];
}

#pragma mark - Lazy
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (LingIMSessionModel *)sessionModel {
    if (_sessionModel == nil) {
        _sessionModel = [[LingIMSessionModel alloc] init];
    }
    return _sessionModel;
}

- (ZTranslateDefaultModel *)defaultModel {
    if (_defaultModel == nil) {
        _defaultModel = [[ZTranslateDefaultModel alloc] init];
    }
    return _defaultModel;
}
@end
