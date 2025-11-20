//
//  EMChatImgEmojiContentView.m
//  CIMKit
//
//  Created by cusPro on 2024/3/25.
//

#import "EMChatImgEmojiContentView.h"
#import "ZChatEmojiContentCell.h"

@interface EMChatImgEmojiContentView()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, ZChatEmojiContentCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation EMChatImgEmojiContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(DScreenWidth, DWScale(258));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [_collectionView registerClass:[ZChatEmojiContentCell class] forCellWithReuseIdentifier:NSStringFromClass([ZChatEmojiContentCell class])];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.height.mas_equalTo(DWScale(258));
    }];
}

- (void)reloadMyCollectionStickers {
    ZChatEmojiContentCell *collectionCell = (ZChatEmojiContentCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [collectionCell reloadMyCollectionStickers];
}

#pragma mark - Data
- (void)setIndex:(NSInteger)index {
    _index = index;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)setContentItemList:(NSMutableArray *)contentItemList {
    if (contentItemList.count > 0) {
        [contentItemList removeObjectAtIndex:0];
        _contentItemList = contentItemList;
        [_collectionView reloadData];
    }
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _contentItemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZChatEmojiContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZChatEmojiContentCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.cellIndexRow = indexPath.row;
    LingIMStickersPackageModel *stickersPackageModel = (LingIMStickersPackageModel *)[_contentItemList objectAtIndexSafe:indexPath.row];
    cell.stickersPackageModel = stickersPackageModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentPage = floorf((scrollView.contentOffset.x - DScreenWidth / 2) / DScreenWidth) + 1;
    NSLog(@"========= %d =========", currentPage);
    if (_delegate && [_delegate respondsToSelector:@selector(scrollToPage:)]) {
        [_delegate scrollToPage:currentPage];
    }
}

#pragma mark - ZChatEmojiContentCellDelegate
/** Emoji */
//选中表情Emoji
- (void)inputEmojiViewSelected:(NSString *)emojiName {
    if (_delegate && [_delegate respondsToSelector:@selector(inputEmojiViewSelected:)]) {
        [_delegate inputEmojiViewSelected:emojiName];
    }
}
//删除Emoji
- (void)inputEmojiViewDelete {
    if (_delegate && [_delegate respondsToSelector:@selector(inputEmojiViewDelete)]) {
        [_delegate inputEmojiViewDelete];
    }
}

/** 收藏的表情 */
//打开相册(添加相册图片到收藏的表情里)
- (void)addCollectionGifImgAction {
    if (_delegate && [_delegate respondsToSelector:@selector(addCollectionGifImgAction)]) {
        [_delegate addCollectionGifImgAction];
    }
}

//游戏表情：石头剪刀布、摇骰子
- (void)chatGameStickerAction:(ZChatGameStickerType)gameType {
    if (_delegate && [_delegate respondsToSelector:@selector(chatGameStickerAction:)]) {
        [_delegate chatGameStickerAction:gameType];
    }
}

//发送收藏的表情
- (void)inputCollectGifImgSelected:(LingIMStickersModel *)sendStickersModel {
    if (_delegate && [_delegate respondsToSelector:@selector(inputCollectGifImgSelected:)]) {
        [_delegate inputCollectGifImgSelected:sendStickersModel];
    }
}

/** 表情包 */
//点击表情包表情发送
- (void)stickerPackageItemSelected:(LingIMStickersModel *)sendStickersModel {
    if (_delegate && [_delegate respondsToSelector:@selector(stickerPackageItemSelected:)]) {
        [_delegate stickerPackageItemSelected:sendStickersModel];
    }
}

//删除当前表情包
- (void)deleteStickersPackageWithStickersSetId:(NSString *)stickersSetId {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteStickersPackageWithStickersSetId:)]) {
        [_delegate deleteStickersPackageWithStickersSetId:stickersSetId];
    }
}


@end
