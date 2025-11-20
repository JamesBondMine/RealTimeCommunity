//
//  SpecMyMiniAppView.m
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

#import "SpecMyMiniAppView.h"
#import "ZToolManager.h"
#import "BBBaseCollectionView.h"
#import "SpecMyMiniAppItem.h"
#import <MJRefresh/MJRefresh.h>

#import "SpecMiniAppPasswordView.h"
#import "SpecConfigMiniAppView.h"
#import "NSMiniAppWebVC.h"
#import "SpecMiniAppDeleteTipView.h"

@interface SpecMyMiniAppView () <UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, BBBaseCollectionCellDelegate, SpecMyMiniAppItemDelete, SpecConfigMiniAppViewDelegate>

@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnManager;
@property (nonatomic, strong) BBBaseCollectionView *collection;
@property (nonatomic, strong) NSMutableArray *miniAppList;
@property (nonatomic, assign) NSInteger pageNumber;
@end

@implementation SpecMyMiniAppView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tkThemebackgroundColors = @[COLOR_CLEAR, COLOR_CLEAR_DARK];
        self.frame = CGRectMake(0, 0, DScreenWidth, DScreenHeight);
        [CurrentWindow addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myMiniAppDismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        _miniAppList = [NSMutableArray array];
        _pageNumber = 1;
        
        [self setupUI];
        [self requestMyMiniAppList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(miniAppViewShow:) name:@"MiniAppSelectImage" object:nil];
    }
    return self;
}

#pragma mark - 通知监听
- (void)miniAppViewShow:(NSNotification *)notification {
    
    NSDictionary *userInfoDict = notification.userInfo;
    BOOL showMiniView = [[userInfoDict objectForKeySafe:@"OpenImagePicker"] boolValue];
    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.hidden = showMiniView;
    });
}

#pragma mark - 界面布局
- (void)setupUI {
    _viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, -DWScale(282), DScreenWidth, DWScale(282))];
    _viewContent.tkThemebackgroundColors = @[HEXACOLOR(@"333333", 0.6), HEXACOLOR(@"333333", 0.6)];
    [_viewContent round:DWScale(12) RectCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    [self addSubview:_viewContent];
    
    UIBlurEffect *effectBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *viewEffect = [[UIVisualEffectView alloc] initWithEffect:effectBlur];
    viewEffect.alpha = 0.6;
    viewEffect.frame = CGRectMake(0, 0, DScreenWidth, DWScale(282));
    [_viewContent addSubview:viewEffect];
    
    _lblTitle = [UILabel new];
    _lblTitle.text = MultilingualTranslation(@"我的应用");
    _lblTitle.tkThemetextColors = @[COLORWHITE, COLORWHITE];
    _lblTitle.font = FONTR(16);
    [_viewContent addSubview:_lblTitle];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_viewContent);
        make.top.equalTo(_viewContent).offset(DWScale(52));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    _btnManager = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnManager setTitle:MultilingualTranslation(@"管理") forState:UIControlStateNormal];
    [_btnManager setTitle:MultilingualTranslation(@"完成") forState:UIControlStateSelected];
    _btnManager.selected = NO;
    [_btnManager setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
    _btnManager.titleLabel.font = FONTR(14);
    [_btnManager addTarget:self action:@selector(btnManagerClick) forControlEvents:UIControlEventTouchUpInside];
    [_viewContent addSubview:_btnManager];
    [_btnManager mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lblTitle);
        make.trailing.equalTo(_viewContent).offset(-DWScale(16));
        make.height.mas_equalTo(DWScale(20));
    }];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((DScreenWidth - DWScale(20)) / 6.0, DWScale(81));
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collection = [[BBBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collection.delaysContentTouches = NO;
    _collection.dataSource = self;
    _collection.delegate = self;
    _collection.tkThemebackgroundColors = @[COLOR_CLEAR, COLOR_CLEAR];
    _collection.showsVerticalScrollIndicator = NO;
    [_collection registerClass:[SpecMyMiniAppItem class] forCellWithReuseIdentifier:NSStringFromClass([SpecMyMiniAppItem class])];
    [_viewContent addSubview:_collection];
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTitle.mas_bottom);
        make.leading.equalTo(_viewContent).offset(DWScale(10));
        make.trailing.equalTo(_viewContent).offset(-DWScale(10));
        make.height.mas_equalTo(DWScale(162));
    }];
    
    WeakSelf
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNumber++;
        [weakSelf requestMyMiniAppList];
    }];
    _collection.mj_footer = refreshFooter;
}

- (void)myMiniAppShow {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.viewContent.top = 0;
    }];
}

- (void)myMiniAppDismiss {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.viewContent.top = -DWScale(282);
    } completion:^(BOOL finished) {
        [weakSelf.viewContent removeFromSuperview];
        weakSelf.viewContent = nil;
        
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_viewContent]) {
        return NO;
    }
    return YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _miniAppList.count + 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SpecMyMiniAppItem *cell = [_collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SpecMyMiniAppItem class]) forIndexPath:indexPath];
    LingIMMiniAppModel *model;
    if (indexPath.row < _miniAppList.count) {
        model = [_miniAppList objectAtIndexSafe:indexPath.row];
    }
    [cell configItemWith:model manage:_btnManager.isSelected];
    cell.baseCellDelegate = self;
    cell.baseCellIndexPath = indexPath;
    cell.delegate = self;
    return cell;
}
#pragma mark - UICollectionViewDelegate

#pragma mark - BBBaseCollectionCellDelegate
- (void)baseCellDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block LingIMMiniAppModel *model = [_miniAppList objectAtIndexSafe:indexPath.row];
    if (model) {
        if (model.qaPwdOpen) {
            //开启了密码验证
            WeakSelf
            SpecMiniAppPasswordView *viewPassword = [SpecMiniAppPasswordView new];
            viewPassword.miniAppModel = model;
            [viewPassword miniAppPasswordShow];
            viewPassword.sureBtnBlock = ^{
                [weakSelf viewOrManageMyMiniAppWith:model];
            };
        }else {
            [self viewOrManageMyMiniAppWith:model];
        }
    } else {
        //新增小程序
        SpecConfigMiniAppView *viewConfig = [[SpecConfigMiniAppView alloc] initMiniAppWith:ZConfigMiniAppTypeAdd];
        viewConfig.delegate = self;
        [viewConfig configMiniAppShow];
        if (_btnManager.isSelected) {
            _btnManager.selected = NO;
            [_collection reloadData];
        }
    }
}
//查看或管理小程序
- (void)viewOrManageMyMiniAppWith:(LingIMMiniAppModel *)miniAppModel {
    if (_btnManager.isSelected) {
        //管理小程序
        if(miniAppModel.appType == 0){
            return;
        }
        SpecConfigMiniAppView *viewConfig = [[SpecConfigMiniAppView alloc] initMiniAppWith:ZConfigMiniAppTypeEdit];
        viewConfig.miniAppModel = miniAppModel;
        viewConfig.delegate = self;
        [viewConfig configMiniAppShow];
    }else {
        //跳转小程序 - 通过block回调给父视图处理
        [self myMiniAppDismiss];
        
        if (self.miniAppJumpBlock) {
            NSLog(@"✅ 调用小程序跳转block: %@", miniAppModel.qaName);
            self.miniAppJumpBlock(miniAppModel);
        } else {
            NSLog(@"⚠️ 小程序跳转block未设置");
            [HUD showMessage:MultilingualTranslation(@"跳转失败，请稍后重试")];
        }
    }
}

#pragma mark - SpecMyMiniAppItemDelete
- (void)myMiniAppDelete:(NSIndexPath *)indexPath {
    
    LingIMMiniAppModel *miniAppModel = [_miniAppList objectAtIndexSafe:indexPath.row];
    if (miniAppModel) {
        WeakSelf
        SpecMiniAppDeleteTipView *viewTip = [SpecMiniAppDeleteTipView new];
        [viewTip tipViewSHow];
        viewTip.sureBtnBlock = ^{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObjectSafe:miniAppModel.qaUuid forKey:@"qaUuid"];
            [dict setObjectSafe:@(miniAppModel.appType) forKey:@"appType"];
            [IMSDKManager imMiniAppDeleteWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
                [weakSelf.miniAppList removeObjectAtIndexSafe:indexPath.row];
                [weakSelf.collection reloadData];
                [HUD showMessage:MultilingualTranslation(@"删除成功")];
            } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
                [HUD showMessageWithCode:code errorMsg:msg];
            }];
        };
        
    }
    
}
#pragma mark - SpecConfigMiniAppViewDelegate
- (void)configMiniAppCreateWith:(LingIMMiniAppModel *)miniApp {
    [_miniAppList addObjectIfNotNil:miniApp];
    [_collection reloadData];
}
- (void)configMiniAppEditWith:(LingIMMiniAppModel *)miniApp {
    [_collection reloadData];
}
#pragma mark - 交互事件
- (void)btnManagerClick {
    _btnManager.selected = !_btnManager.selected;
    [_collection reloadData];
}

#pragma mark - 数据请求
- (void)requestMyMiniAppList {
    WeakSelf
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    [dict setObjectSafe:@(_pageNumber) forKey:@"pageNumber"];
    [dict setObjectSafe:@(50) forKey:@"pageSize"];
    [dict setObjectSafe:@((_pageNumber - 1) * 50) forKey:@"pageStart"];
    
    [IMSDKManager imMiniAppListWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = (NSDictionary *)data;
            if (weakSelf.pageNumber == 1) {
                [weakSelf.miniAppList removeAllObjects];
            }
            //小程序列表
            NSArray *miniAppArr = (NSArray *)[dataDict objectForKeySafe:@"items"];
            [miniAppArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LingIMMiniAppModel *model = [LingIMMiniAppModel mj_objectWithKeyValues:obj];
                [weakSelf.miniAppList addObjectIfNotNil:model];
            }];
            [weakSelf.collection reloadData];
            
            //数据是否加载完毕
            NSInteger totalPage = [[dataDict objectForKeySafe:@"pages"] integerValue];
            if (weakSelf.pageNumber >= totalPage) {
                weakSelf.collection.mj_footer = nil;
            }
        }
        
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
    
}

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
