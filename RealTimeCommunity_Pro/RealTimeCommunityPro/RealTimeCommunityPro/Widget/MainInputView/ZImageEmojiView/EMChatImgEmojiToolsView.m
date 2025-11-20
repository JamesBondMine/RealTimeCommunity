//
//  EMChatImgEmojiToolsView.m
//  CIMKit
//
//  Created by cusPro on 2023/8/10.
//

#import "EMChatImgEmojiToolsView.h"
#import "ZChatEmojiToolsCell.h"

@interface EMChatImgEmojiToolsView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation EMChatImgEmojiToolsView

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
    layout.itemSize = CGSizeMake(DWScale(46), DWScale(46));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [_collectionView registerClass:[ZChatEmojiToolsCell class] forCellWithReuseIdentifier:NSStringFromClass([ZChatEmojiToolsCell class])];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(DWScale(22));
        make.trailing.equalTo(self).offset(-DWScale(22));
        make.height.mas_equalTo(DWScale(46));
    }];
}

#pragma mark - Setter
- (void)setToolsItemList:(NSMutableArray *)toolsItemList {
    _toolsItemList = toolsItemList;
    [_collectionView reloadData];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    
    if (_toolsItemList != nil && _toolsItemList.count > 0 && _toolsItemList.count > _pageIndex) {
        for (int i = 0; i < _toolsItemList.count; i++) {
            LingIMStickersPackageModel *tempItemModel = (LingIMStickersPackageModel *)[_toolsItemList objectAtIndexSafe:i];
            tempItemModel.isSelected = NO;
            [_toolsItemList replaceObjectAtIndex:i withObject:tempItemModel];
        }
        LingIMStickersPackageModel *tempItemModel = (LingIMStickersPackageModel *)[_toolsItemList objectAtIndexSafe:_pageIndex];
        tempItemModel.isSelected = YES;
        [_toolsItemList replaceObjectAtIndex:_pageIndex withObject:tempItemModel];
        [_collectionView reloadData];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _toolsItemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZChatEmojiToolsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZChatEmojiToolsCell class]) forIndexPath:indexPath];
    cell.itemModel = (LingIMStickersPackageModel *)[_toolsItemList objectAtIndexSafe:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LingIMStickersPackageModel *clickMdoel = (LingIMStickersPackageModel *)[_toolsItemList objectAtIndex:indexPath.row];
    if(indexPath.row != 0) {
        //全部设置为未选中
        for (int i = 0; i < _toolsItemList.count; i++) {
            LingIMStickersPackageModel *tempItemModel = (LingIMStickersPackageModel *)[_toolsItemList objectAtIndexSafe:i];
            tempItemModel.isSelected = NO;
            [_toolsItemList replaceObjectAtIndex:i withObject:tempItemModel];
        }
        if (clickMdoel.isSelected == NO) {
            clickMdoel.isSelected = YES;
        }
        [_toolsItemList replaceObjectAtIndex:indexPath.row withObject:clickMdoel];
        [_collectionView reloadData];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(toolsViewSelectedIndex:)]) {
        [_delegate toolsViewSelectedIndex:indexPath.row];
    }
}

@end
