//
//  EMChatGitImgCollectionView.m
//  CIMKit
//
//  Created by cusPro on 2023/8/10.
//

#import "EMChatGitImgCollectionView.h"
#import "ZChatGitImgCollectionCell.h"
#import "ZImagePickerVC.h"
#import "EMEmojiMenuPopView.h"

// 添加默认图片
#define kAddIconImgName @"emoji_collect_add"
// 石头剪刀布默认
#define kStoneScissorClothIconImgName @"emoji_collect_stoneScissorCloth"
// 筛子默认
#define kPlayDiceIconImgName @"emoji_collect_playDice"

@interface EMChatGitImgCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource, ZChatGitImgCollectionCellDelegate>

@property (nonatomic, strong) NSMutableArray *collectionList;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger pageNumber;//起始页
@property (nonatomic, strong) MJRefreshNormalHeader  *refreshHeader;//下拉刷新
@property (nonatomic, strong) MJRefreshBackNormalFooter  *refreshFooter;//上拉加载

@end

@implementation EMChatGitImgCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tkThemebackgroundColors = @[COLOR_F2F3F5, COLOR_33];
        [self defaultAddData];
        [self defaultGameStickersData];
        [self setupUI];
        [self setupData];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tkThemebackgroundColors = @[COLOR_F2F3F5, COLOR_33];
        [self setupUI];
        [self setupData];
    }
    return self;
}

- (void)setupData {
    _pageNumber = 1;
    [self requestCollectionStickersList];
}

- (void)setupUI {
    UILabel *lblTip = [UILabel new];
    lblTip.text = MultilingualTranslation(@"添加的单个表情");
    lblTip.tkThemetextColors = @[COLOR_66, COLOR_66];
    lblTip.font = FONTR(12);
    [self addSubview:lblTip];
    [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(DWScale(16));
        make.top.equalTo(self).offset(DWScale(8));
        make.height.mas_equalTo(DWScale(20));
    }];
    
    CGFloat itemWH = (int)(DScreenWidth - DWScale(8)*2 - DWScale(8)*2) / 4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.mj_header = self.refreshHeader;
    _collectionView.mj_footer = self.refreshFooter;
    _collectionView.tkThemebackgroundColors = @[COLOR_F2F3F5, COLOR_33];
    _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [_collectionView registerClass:[ZChatGitImgCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([ZChatGitImgCollectionCell class])];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTip.mas_bottom);
        make.leading.equalTo(self).offset(DWScale(8));
        make.trailing.equalTo(self).offset(-DWScale(8));
        make.bottom.equalTo(self);
    }];
}

//每一次点击表情按钮，都从第1页重新拉取接口数据
- (void)reloadMyCollectionStickers {
    _pageNumber = 1;
    [self requestCollectionStickersList];
}

//下拉刷新
- (void)headerRefreshData {
    _pageNumber = 1;
    [self requestCollectionStickersList];
}

//上拉加载更多
- (void)footerRefreshData {
    _pageNumber++;
    [self requestCollectionStickersList];
}

#pragma mark - 默认数据
- (void)defaultAddData {
    //Add
    LingIMStickersModel *addModel = [[LingIMStickersModel alloc] init];
    addModel.assetAddIcon = kAddIconImgName;
    [self.collectionList addObject:addModel];
}

- (void)defaultGameStickersData {
    //石头剪刀布
    LingIMStickersModel *stoneScissorClothModel = [[LingIMStickersModel alloc] init];
    stoneScissorClothModel.assetAddIcon = kStoneScissorClothIconImgName;
    [self.collectionList addObject:stoneScissorClothModel];
    
    //摇色子
    LingIMStickersModel *playDiceModel = [[LingIMStickersModel alloc] init];
    playDiceModel.assetAddIcon = kPlayDiceIconImgName;
    [self.collectionList addObject:playDiceModel];
}

#pragma mark - Request

/// 清空数据源，并重置数据
- (void)resetCollectionList {
    // 清空数据源
    [self.collectionList removeAllObjects];
    // 添加默认add
    [self defaultAddData];
}

//请求收藏的表情列表(分页)
- (void)requestCollectionStickersList {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:@(_pageNumber) forKey:@"pageNumber"];
    [dict setObjectSafe:@(20) forKey:@"pageSize"];
    [dict setObjectSafe:@((_pageNumber - 1) * 20) forKey:@"pageStart"];
    [dict setObjectSafe:@(0) forKey:@"lastUpdateTime"];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    
    @weakify(self)
    [IMSDKManager imSdkUserGetCollectStickersList:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        
        if (![data isKindOfClass:[NSDictionary class]]) {
            if (self.pageNumber < 2) {
                // 清空缓存的收藏表情
                [DBTOOL deleteAllCollectionStickersModels];
                // 清空数据源，并重置数据
                [self resetCollectionList];
                // 添加游戏表情到最后(筛子+石头剪刀布)
                [self defaultGameStickersData];
                // 刷新UI
                [self.collectionView reloadData];
            }else {
                // 保持原样,因为本次获取的数据异常,但是需要将pageNumber-1,因为本次获取失败
                self.pageNumber -= 1;
                // 数据无需处理，也无需刷新UI
            }
            return;
        }
        
        if (self.pageNumber < 2) {
            // 第一页时重置数据
            // 清空缓存的收藏表情
            [DBTOOL deleteAllCollectionStickersModels];
            // 清空数据源，并重置数据
            [self resetCollectionList];
        }else {
            // 非第一页时，移除最后两个游戏表情数据(筛子+石头剪刀布)，以便后续添加新数据后，再添加游戏表情数据到最后
            // 使用 removeObjectsAtIndexes 或收集索引后删除
            NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];
            
            [self.collectionList enumerateObjectsUsingBlock:^(LingIMStickersModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.assetAddIcon isEqualToString:kStoneScissorClothIconImgName] ||
                    [obj.assetAddIcon isEqualToString:kPlayDiceIconImgName]) {
                    [indexesToRemove addIndex:idx];
                }
            }];
            
            [self.collectionList removeObjectsAtIndexes:indexesToRemove];
        }
        
        // 数据处理
        NSDictionary *dataDict = (NSDictionary *)data;
        NSArray *rowList = [dataDict objectForKeySafe:@"rows"];
        if (rowList && rowList.count > 0 && [rowList isKindOfClass:[NSArray class]]) {
            // 解析rowList
            NSArray *tempGifImgList = [LingIMStickersModel mj_objectArrayWithKeyValuesArray:rowList];
            // 添加收藏的表情
            [self.collectionList addObjectsFromArray:tempGifImgList];
            
            //保存接口返回的收藏表情到本地数据库
            [DBTOOL batchInsertCollectionStickersModelWith:tempGifImgList];
        }
        
        //添加游戏表情到最后
        [self defaultGameStickersData];
            
        //分页处理
        NSInteger totalPage = [[dataDict objectForKeySafe:@"pages"] integerValue];
        if (self.pageNumber < totalPage) {
            if (!self.collectionView.mj_footer) {
                self.collectionView.mj_footer = self.refreshFooter;
            }
        } else {
            self.collectionView.mj_footer = nil;
        }
        [self.collectionView reloadData];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        
        // 保持原样,因为本次获取的数据异常,但是需要将pageNumber-1,因为本次获取失败
        self.pageNumber -= 1;
        // 避免出现self.pageNumber < 1的存在，保证最小为1
        self.pageNumber = MAX(1, self.pageNumber);
        
        // 从数据库中读取
        NSArray *dbCollectionList = [DBTOOL getMyCollectionStickersList];
        if (dbCollectionList && dbCollectionList.count > 0) {
            // 清空数据源，并重置数据
            [self resetCollectionList];
            // 添加本地数据库收藏的表情
            [self.collectionList addObjectsFromArray:dbCollectionList];
            // 添加游戏表情到最后(筛子+石头剪刀布)
            [self defaultGameStickersData];
            // 刷新UI
            self.collectionView.mj_footer = nil;
            [self.collectionView reloadData];
        } else {
            if (!self.collectionView.mj_footer) {
                self.collectionView.mj_footer = self.refreshFooter;
            }
        }
    }];
}

//删除收藏的表情
- (void)requestDeleteMyCollectionStickersWithIndexpath:(NSIndexPath *)indexPath {
    //长按表情
    LingIMStickersModel *deleteStickersModel = (LingIMStickersModel *)[self.collectionList objectAtIndex:indexPath.row];
    
    NSArray *idList = @[deleteStickersModel.stickersId];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:idList forKey:@"idList"];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    WeakSelf
    [IMSDKManager imSdkUserRemoveStickersFromCollectList:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD showMessage:MultilingualTranslation(@"删除成功")];
        [DBTOOL deleteCollectionStickersModelWith:deleteStickersModel.stickersId];
        [weakSelf.collectionList removeObjectAtIndexSafe:indexPath.row];
        [weakSelf.collectionView reloadData];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - ZChatGitImgCollectionCellDelegate
//删除
- (void)collectionStickersLongTapAction:(NSIndexPath *)indexPath {
    ZChatGitImgCollectionCell *longTapCell = (ZChatGitImgCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    //计算消息的坐标位置,确定菜单弹窗弹出的位置的坐标
    CGRect targetRect = [self.collectionView convertRect:longTapCell.frame toView:CurrentVC.view];
    
    EMEmojiMenuPopView *menuPopView = [[EMEmojiMenuPopView alloc] initWithMenuTitle:MultilingualTranslation(@"删除") targetRect:targetRect];
    [menuPopView ZEmojiMenuShow];
    WeakSelf
    [menuPopView setMenuClickBlock:^(void) {
        [weakSelf deleteCollectionStickersConfirmWithRect:targetRect indexPath:indexPath];
    }];
}

//确认删除
- (void)deleteCollectionStickersConfirmWithRect:(CGRect)targetRect indexPath:(NSIndexPath *)indexPath {
    EMEmojiMenuPopView *menuPopView = [[EMEmojiMenuPopView alloc] initWithMenuTitle:MultilingualTranslation(@"确认删除") targetRect:targetRect];
    [menuPopView ZEmojiMenuShow];
    WeakSelf
    [menuPopView setMenuClickBlock:^(void) {
        [weakSelf requestDeleteMyCollectionStickersWithIndexpath:indexPath];
    }];
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZChatGitImgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZChatGitImgCollectionCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.cellIndexPath = indexPath;
    cell.cellTotalIndex = self.collectionList.count;
    LingIMStickersModel *cellModel = (LingIMStickersModel *)[self.collectionList objectAtIndex:indexPath.row];
    cell.collectModel = cellModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //Add
        if (_delegate && [_delegate respondsToSelector:@selector(addCollectionGifImgAction)]) {
            [_delegate addCollectionGifImgAction];
        }
    } else if (indexPath.row == self.collectionList.count - 2) {
        //石头剪刀布
        if (_delegate && [_delegate respondsToSelector:@selector(chatGameStickerAction:)]) {
            [_delegate chatGameStickerAction:ZChatGameStickerTypeFingerGuessing];
        }
    } else if (indexPath.row == self.collectionList.count - 1) {
        //摇骰子
        if (_delegate && [_delegate respondsToSelector:@selector(chatGameStickerAction:)]) {
            [_delegate chatGameStickerAction:ZChatGameStickerTypePlayDice];
        }
    } else {
        //发送收藏的表情
        LingIMStickersModel *model = (LingIMStickersModel *)[self.collectionList objectAtIndex:indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(inputCollectGifImgSelected:)]) {
            [_delegate inputCollectGifImgSelected:model];
        }
    }
}

#pragma mark - Lazy
- (NSMutableArray *)collectionList {
    if (!_collectionList) {
        _collectionList= [[NSMutableArray alloc] init];
    }
    return _collectionList;
}

- (MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        WeakSelf
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefreshData];
        }];
        
        _refreshHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        _refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14];
        [_refreshHeader setTitle:MultilingualTranslation(@"下拉刷新") forState:MJRefreshStateIdle];
        [_refreshHeader setTitle:MultilingualTranslation(@"下拉刷新") forState:MJRefreshStatePulling];
        [_refreshHeader setTitle:MultilingualTranslation(@"正在加载...") forState:MJRefreshStateRefreshing];
        [_refreshHeader setTitle:MultilingualTranslation(@"正在加载...") forState:MJRefreshStateWillRefresh];
        
    }
    return _refreshHeader;
}
- (MJRefreshBackNormalFooter *)refreshFooter {
    if (!_refreshFooter) {
        WeakSelf
        _refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf footerRefreshData];
        }];
        _refreshFooter.stateLabel.font = [UIFont systemFontOfSize:14];
        [_refreshFooter setTitle:MultilingualTranslation(@"上拉加载更多") forState:MJRefreshStateIdle];
        [_refreshFooter setTitle:MultilingualTranslation(@"上拉加载更多") forState:MJRefreshStatePulling];
        [_refreshFooter setTitle:MultilingualTranslation(@"正在加载...") forState:MJRefreshStateRefreshing];
        [_refreshFooter setTitle:MultilingualTranslation(@"正在加载...") forState:MJRefreshStateWillRefresh];
        [_refreshFooter setTitle:MultilingualTranslation(@"我是有底线的") forState:MJRefreshStateNoMoreData];
    }
    return _refreshFooter;
}

#pragma mark - LiftCycle
- (void)dealloc{
    [self endEditing:YES];
}

@end
