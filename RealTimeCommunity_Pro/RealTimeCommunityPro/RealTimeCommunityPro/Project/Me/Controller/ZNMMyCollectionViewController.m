//
//  ZNMMyCollectionViewController.m
//  CIMKit
//
//  Created by cusPro on 2023/4/19.
//

#import "ZNMMyCollectionViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "ZCollectionTextCell.h"
#import "ZCollectionImageCell.h"
#import "ZCollectionVideoCell.h"
#import "ZCollectionFileCell.h"
#import "ZCollectionGeoCell.h"
#import "ZMyCollectionModel.h"
#import "KNPhotoBrowser.h"
#import "ZToolManager.h"
#import "ZMessageAlertView.h"
#import "ZMessageTools.h"
#import "NHChatFileDetailViewController.h"

@interface ZNMMyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate, MGSwipeTableCellDelegate, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate, KNPhotoBrowserDelegate>

//黑名单列表
@property (nonatomic, strong) NSMutableArray *collectionList;
//起始页
@property (nonatomic, assign) NSInteger pageNumber;
//起始索引
@property (nonatomic, assign) NSInteger pageStart;
//查看大图或视频时，当前的model
@property (nonatomic, strong) ZMyCollectionModel *currentClickModel;

@end

@implementation ZNMMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self setupNavUI];
    [self setupUI];
    self.pageNumber = 1;
    self.pageStart = 0;
    //请求数据
    [self requestCollectionData];
}

#pragma mark - 界面布局
- (void)setupNavUI {
    self.navTitleStr = MultilingualTranslation(@"收藏");
    self.navBtnRight.hidden = YES;
}

- (void)setupUI {
    [self.view addSubview:self.baseTableView];
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.emptyDataSetSource = self;
    self.baseTableView.emptyDataSetDelegate = self;
    self.baseTableView.separatorColor = COLOR_CLEAR;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-DHomeBarH);
    }];
    //添加下拉加载
    self.baseTableView.mj_footer = self.refreshFooter;
    
    [self.baseTableView registerClass:[ZCollectionTextCell class] forCellReuseIdentifier:NSStringFromClass([ZCollectionTextCell class])];
    [self.baseTableView registerClass:[ZCollectionImageCell class] forCellReuseIdentifier:NSStringFromClass([ZCollectionImageCell class])];
    [self.baseTableView registerClass:[ZCollectionVideoCell class] forCellReuseIdentifier:NSStringFromClass([ZCollectionVideoCell class])];
    [self.baseTableView registerClass:[ZCollectionFileCell class] forCellReuseIdentifier:NSStringFromClass([ZCollectionFileCell class])];
    [self.baseTableView registerClass:[ZCollectionGeoCell class] forCellReuseIdentifier:NSStringFromClass([ZCollectionGeoCell class])];
}

//上拉加载更多数据
- (void)footerRefreshData {
    self.pageNumber += 1;
    [self requestCollectionData];
}

#pragma mark - 网络请求
- (void)requestCollectionData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:[NSNumber numberWithInteger:self.pageNumber] forKey:@"pageNumber"];
    [dict setObjectSafe:@(10) forKey:@"pageSize"];
    [dict setObjectSafe:[NSNumber numberWithInteger:self.collectionList.count] forKey:@"pageStart"];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    
    WeakSelf
    [HUD showActivityMessage:@""];
    [IMSDKManager userMyCollectionListWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD hideHUD];
        [weakSelf.baseTableView.mj_footer endRefreshing];
        
        NSDictionary *dataDic = (NSDictionary *)data;
        NSArray *itemArr = (NSArray *)[dataDic objectForKey:@"items"];
        NSInteger totalCount = [[dataDic objectForKey:@"totalCount"] integerValue];
        if (itemArr != nil && itemArr.count > 0) {
            NSArray *itemList = [ZMyCollectionItemModel mj_objectArrayWithKeyValuesArray:itemArr];
            __block NSMutableArray *newCollectionList = [[NSMutableArray alloc] init];
            [itemList enumerateObjectsUsingBlock:^(ZMyCollectionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZMyCollectionModel *collectionModel = [[ZMyCollectionModel alloc] initWithCollectionModel:obj];
                [newCollectionList addObject:collectionModel];
            }];
            [weakSelf.collectionList addObjectsFromArray:newCollectionList];
        }
        [weakSelf.baseTableView reloadData];
        if (weakSelf.collectionList.count == totalCount) {
            [weakSelf.baseTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD hideHUD];
        [HUD showMessageWithCode:code errorMsg:msg];
        return;
    }];
}

#pragma mark - Tableview delegate dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collectionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZMyCollectionModel *model = [self.collectionList objectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZMyCollectionModel *model = (ZMyCollectionModel *)[self.collectionList objectAtIndex:indexPath.row];
    if (model.itemModel.mtype == CIMChatMessageType_TextMessage || model.itemModel.mtype == CIMChatMessageType_AtMessage) {
        //文本消息
        ZCollectionTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCollectionTextCell class]) forIndexPath:indexPath];
        cell.model = model;
        cell.delegate = self;//设置代理
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    } else if (model.itemModel.mtype == CIMChatMessageType_ImageMessage) {
        //图片消息
        ZCollectionImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCollectionImageCell class]) forIndexPath:indexPath];
        cell.model = model;
        cell.delegate = self;//设置代理
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    } else if (model.itemModel.mtype == CIMChatMessageType_VideoMessage) {
        //视频消息
        ZCollectionVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCollectionVideoCell class]) forIndexPath:indexPath];
        cell.model = model;
        cell.delegate = self;//设置代理
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    } else if (model.itemModel.mtype == CIMChatMessageType_FileMessage) {
        //文件消息
        ZCollectionFileCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCollectionFileCell class]) forIndexPath:indexPath];
        cell.model = model;
        cell.delegate = self;//设置代理
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    } else if (model.itemModel.mtype == CIMChatMessageType_GeoMessage) {
        //地理位置消息
        ZCollectionGeoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZCollectionGeoCell class]) forIndexPath:indexPath];
        cell.model = model;
        cell.delegate = self;//设置代理
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
        
    } else {
        return [UITableViewCell new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZMyCollectionModel *model = (ZMyCollectionModel *)[self.collectionList objectAtIndex:indexPath.row];
    if (self.isFromChat) {
        //通过chatRoom进入收藏列表，点击收藏的消息直接发送到当前chatRoom里
        if (self.sendCollectionMsgBlock) {
            self.sendCollectionMsgBlock(model.itemModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.currentClickModel = model;
       //图片查看大图或者视频跳转播放
        NSMutableArray *browserMessages = [NSMutableArray array];
        KNPhotoItems *item = [[KNPhotoItems alloc] init];
        if (model.itemModel.mtype == CIMChatMessageType_ImageMessage) {
            //图片
            item.isVideo = false;
            item.url = [model.itemModel.body.name getImageFullString];
            //缩略图地址
            item.thumbnailUrl = [model.itemModel.body.iImg getImageFullString];
            
            [browserMessages addObjectIfNotNil:item];
        } else if (model.itemModel.mtype == CIMChatMessageType_VideoMessage) {
            //视频
            item.isVideo = true;
            //视频封面
            item.videoPlaceHolderImageUrl = [model.itemModel.body.cImg getImageFullString];
            //视频地址
            item.url = [model.itemModel.body.name getImageFullString];
        
            [browserMessages addObjectIfNotNil:item];
        } else if (model.itemModel.mtype == CIMChatMessageType_FileMessage) {
            NSString *collectionFileFullPath = [NSString stringWithFormat:@"%@/%@", [NSString getCollcetionMessageFileDiectoryPath], model.itemModel.body.name];
            NHChatFileDetailViewController *fileDetailVC = [[NHChatFileDetailViewController alloc] init];
            fileDetailVC.collectionMsgModel = model;
            fileDetailVC.localFilePath = collectionFileFullPath;
            fileDetailVC.isShowRightBtn = NO;
            fileDetailVC.isFromCollcet = YES;
            [self.navigationController pushViewController:fileDetailVC animated:YES];
            return;
        } else {
            return;
        }
        
        KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
        [KNPhotoBrowserConfig share].isNeedCustomActionBar = false;
        photoBrowser.delegate = self;
        photoBrowser.itemsArr = browserMessages;
        photoBrowser.placeHolderColor = UIColor.lightTextColor;
        photoBrowser.currentIndex = 0;
        photoBrowser.isSoloAmbient = true;//音频模式
        photoBrowser.isNeedPageNumView = false;//分页
        photoBrowser.isNeedRightTopBtn = true;//更多按钮
        photoBrowser.isNeedLongPress = false;//长按
        photoBrowser.isNeedPanGesture = true;//拖拽
        photoBrowser.isNeedPrefetch = true;//预取图像(最大8)
        photoBrowser.isNeedAutoPlay = true;//自动播放
        photoBrowser.isNeedOnlinePlay = false;//在线播放(先自动下载视频)
        [photoBrowser present];
    }
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point {
    return YES;
}

- (NSArray<UIView *> *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {
    
    if (direction == MGSwipeDirectionRightToLeft) {
        swipeSettings.transition = MGSwipeTransitionBorder;//动画效果
        expansionSettings.buttonIndex = 0;//可展开按钮索引
        expansionSettings.fillOnTrigger = NO;//是否填充
        expansionSettings.threshold = 10.0;//触发阈值
        
        NSIndexPath *cellIndex = [self.baseTableView indexPathForCell:cell];
      
        WeakSelf
        //从右到左滑动
        MGSwipeButton *btnDelete = [MGSwipeButton buttonWithTitle:@"" backgroundColor:COLOR_F5F6F9 insets:UIEdgeInsetsZero callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            [weakSelf deleteComfirmAlertWith:cellIndex];
            return NO;
        }];
        [btnDelete setImage:ImgNamed(@"com_icon_collection_delete") forState:UIControlStateNormal];
        btnDelete.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
        btnDelete.titleLabel.font = FONTN(0);
        btnDelete.buttonWidth = DWScale(66);
        [btnDelete centerIconOverTextWithSpacing:-20];
        return @[btnDelete];
    } else {
        return @[];
    }
}

#pragma mark - DZNEmptyDataSetSource
//图片距离中心偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return DWScale(-120);
}

//空态图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImgNamed(@"com_c_no_history_chat");
}

#pragma mark - DZNEmptyDataSetDelegate
//允许滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - KNPhotoBrowserDelegate
//图片浏览右侧按钮点击事件
- (void)photoBrowser:(KNPhotoBrowser *)photoBrowser rightBtnOperationActionWithIndex:(NSInteger)index {
    NSString *imageUrl;
    NSString *videoUrl;
    if (self.currentClickModel.itemModel.mtype == CIMChatMessageType_ImageMessage) {
        imageUrl = [self.currentClickModel.itemModel.body.name getImageFullString];
    } else if (self.currentClickModel.itemModel.mtype == CIMChatMessageType_VideoMessage) {
        //网络视频地址
        videoUrl = [self.currentClickModel.itemModel.body.name getImageFullString];
    }
    
    WeakSelf
    ZPresentItem *saveItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"保存到手机") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(54) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            saveItem.textColor = COLOR_33;
            saveItem.backgroundColor = COLORWHITE;
        }else {
            saveItem.textColor = COLORWHITE;
            saveItem.backgroundColor = COLOR_33;
        }
    };
    ZPresentItem *cancelItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"取消") textColor:COLOR_99 font:FONTR(17) itemHeight:DWScale(54) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            cancelItem.textColor = COLOR_99;
            cancelItem.backgroundColor = COLORWHITE;
        }else {
            cancelItem.textColor = COLOR_99;
            cancelItem.backgroundColor = COLOR_33;
        }
    };
    ZPresentView *viewAlert = [[ZPresentView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DScreenHeight) titleItem:nil selectItems:@[saveItem] cancleItem:cancelItem doneClick:^(NSInteger index) {
        if (![NSString isNil:imageUrl]) {
            [ZTOOL saveImageToAlbumWith:imageUrl Cusotm:@""];
        }
        if (![NSString isNil:videoUrl]) {
            [weakSelf saveVideoToAlbumWithUrl:videoUrl];
        }
        
    } cancleClick:^{
    }];
    [CurrentVC.view addSubview:viewAlert];
    [viewAlert showPresentView];
}

#pragma mark - Action
- (void)deleteComfirmAlertWith:(NSIndexPath *)indexPath {
    WeakSelf
    ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeNomal supView:nil];
    msgAlertView.lblContent.text = MultilingualTranslation(@"删除该条收藏");
    [msgAlertView.btnSure setTitle:MultilingualTranslation(@"确认") forState:UIControlStateNormal];
    [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
    [msgAlertView alertShow];
    msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
        [weakSelf deleteUserCollectionMessageWith:indexPath];
    };
}

- (void)deleteUserCollectionMessageWith:(NSIndexPath *)indexPath {
    //移除收藏
    ZMyCollectionModel *model = (ZMyCollectionModel *)[self.collectionList objectAtIndex:indexPath.row];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.itemModel.collectId forKey:@"collectId"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    
    WeakSelf
    [HUD showActivityMessage:@""];
    [IMSDKManager userCollectionMsgDeleteWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD hideHUD];
        BOOL result = [data boolValue];
        if (result) {
            [HUD showMessage:MultilingualTranslation(@"删除成功")];
            [weakSelf.collectionList removeObjectAtIndex:indexPath.row];
            [weakSelf.baseTableView reloadData];
        } else {
            [HUD showMessage:MultilingualTranslation(@"删除失败")];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD hideHUD];
        
    }];
}

//保存视频到相册
- (void)saveVideoToAlbumWithUrl:(NSString *)videoUrl {
    [HUD showActivityMessage:MultilingualTranslation(@"正在保存...")];
    //此处的逻辑应该是，先查询本地缓存有没有该视频
    //有的话，直接保存，没有的话先缓存到本地，再保存
    NSString *videoPath = [ZTOOL videoExistsWith:videoUrl];
    if (![NSString isNil:videoPath]) {
        //已有缓存，直接保存
        [ZTOOL saveVideoToAlbumWith:videoPath];
    }else {
        //先下载缓存，再保存
        [ZTOOL downloadVideoWith:videoUrl completion:^(BOOL success, NSString * _Nonnull videoPath) {
            if (success) {
                [ZTOOL saveVideoToAlbumWith:videoPath];
            }
        }];
    }
}

#pragma mark - Lazy
- (NSMutableArray *)collectionList {
    if (!_collectionList) {
        _collectionList = [[NSMutableArray alloc] init];
    }
    return _collectionList;
}


@end
