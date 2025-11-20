//
//  CMessageMoreItemView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/29.
//

#import "CMessageMoreItemView.h"
#import "CMessageMoreItem.h"

@interface CMessageMoreItemView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CMessageMoreItemView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tkThemebackgroundColors = @[COLOR_CLEAR, COLOR_CLEAR_DARK];
        [self setupUI];
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(DWScale(59), DWScale(56));
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(DWScale(6), 0, DWScale(6), 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.width, self.height - 10) collectionViewLayout:layout];
    _collectionView.tkThemebackgroundColors = @[[COLOR_262728 colorWithAlphaComponent:0.8], COLOR_22];
    _collectionView.layer.cornerRadius = DWScale(14);
    _collectionView.layer.masksToBounds = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[CMessageMoreItem class] forCellWithReuseIdentifier:NSStringFromClass([CMessageMoreItem class])];
    [self addSubview:_collectionView];
}

#pragma mark - 数据赋值
- (void)setMenuArr:(NSArray *)menuArr {
    _menuArr = menuArr;
    
    if (menuArr.count > 5) {
        _collectionView.height = DWScale(56) * 2 + DWScale(12);
    }
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menuArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMessageMoreItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CMessageMoreItem class]) forIndexPath:indexPath];
    NSDictionary *dict = [self getMsgMenuItemDataWithType:[[_menuArr objectAtIndexSafe:indexPath.row] integerValue]];
    cell.ivImage.image = ImgNamed([dict objectForKeySafe:@"imageName"]);
    cell.lblTitle.text = [dict objectForKeySafe:@"titleName"];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MessageMenuItemActionType clickMenuType = [[_menuArr objectAtIndexSafe:indexPath.row] integerValue];
    if (_delegate && [_delegate respondsToSelector:@selector(menuItemViewSelectedAction:)]) {
        [_delegate menuItemViewSelectedAction:clickMenuType];
    }
}

#pragma mark - 根据类型 获取对应菜单的图标和标题
- (NSDictionary *)getMsgMenuItemDataWithType:(MessageMenuItemActionType)menuType {
    switch (menuType) {
        case MessageMenuItemActionTypeCopy:
            return @{
                @"titleName" : MultilingualTranslation(@"复制"),
                @"imageName" : @"c_more_copy"
            };
            break;
        case MessageMenuItemActionTypeCopyContent:
            return @{
                @"titleName" : MultilingualTranslation(@"复制原文"),
                @"imageName" : @"c_more_copy"
            };
            break;
        case MessageMenuItemActionTypeCopyTranslate:
            return @{
                @"titleName" : MultilingualTranslation(@"复制译文"),
                @"imageName" : @"c_more_copy_translate"
            };
            break;
        case MessageMenuItemActionTypeForward:
            return @{
                @"titleName" : MultilingualTranslation(@"转发"),
                @"imageName" : @"c_more_forward"
            };
            break;
        case MessageMenuItemActionTypeDelete:
            return @{
                @"titleName" : MultilingualTranslation(@"删除"),
                @"imageName" : @"c_more_delete"
            };
            break;
        case MessageMenuItemActionTypeRevoke:
            return @{
                @"titleName" : MultilingualTranslation(@"撤回"),
                @"imageName" : @"c_more_revoke"
            };
            break;
        case MessageMenuItemActionTypeReference:
            return @{
                @"titleName" : MultilingualTranslation(@"引用"),
                @"imageName" : @"c_more_reference"
            };
            break;
        case MessageMenuItemActionTypeCollection:
            return @{
                @"titleName" : MultilingualTranslation(@"收藏"),
                @"imageName" : @"talk_more_collection"
            };
            break;
        case MessageMenuItemActionTypeMultiSelect:
            return @{
                @"titleName" : MultilingualTranslation(@"多选"),
                @"imageName" : @"c_more_multi_select"
            };
            break;
        case MessageMenuItemActionTypeAddTag:
            return @{
                @"titleName" : MultilingualTranslation(@"存为"),
                @"imageName" : @"c_more_url_tag"
            };
            break;
        case MessageMenuItemActionTypeShowTranslate:
            return @{
                @"titleName" : MultilingualTranslation(@"翻译"),
                @"imageName" : @"c_more_translate"
            };
            break;
        case MessageMenuItemActionTypeHiddenTranslate:
            return @{
                @"titleName" : MultilingualTranslation(@"隐藏译文"),
                @"imageName" : @"c_more_hidden_translate"
            };
            break;
        case MessageMenuItemActionTypeStickersAdd:
            return @{
                @"titleName" : MultilingualTranslation(@"添加"),
                @"imageName" : @"c_more_stickers_add"
            };
            break;
        case MessageMenuItemActionTypeStickersPackage:
            return @{
                @"titleName" : MultilingualTranslation(@"表情包"),
                @"imageName" : @"c_more_stickers_package"
            };
            break;
        case MessageMenuItemActionTypeMutePlayback:
            return @{
                @"titleName" : MultilingualTranslation(@"听筒播放"),
                @"imageName" : @"c_more_mute_playback"
            };
            break;
        default:
            return @{
                @"titleName" : @"",
                @"imageName" : @""
            };

            break;
    }
}

@end

