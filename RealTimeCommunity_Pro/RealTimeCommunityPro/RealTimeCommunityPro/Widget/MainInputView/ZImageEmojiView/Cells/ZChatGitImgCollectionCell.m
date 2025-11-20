//
//  ZChatGitImgCollectionCell.m
//  CIMKit
//
//  Created by cusPro on 2023/8/10.
//

#import "ZChatGitImgCollectionCell.h"

@interface ZChatGitImgCollectionCell()

@property (nonatomic, strong) UIImageView *collectionItem;

@end

@implementation ZChatGitImgCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.tkThemebackgroundColors = @[COLOR_F2F3F5, COLOR_33];
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    _collectionItem = [[UIImageView alloc] init];
    [_collectionItem rounded:DWScale(8)];
    _collectionItem.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_collectionItem];
    [_collectionItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(DWScale(8));
        make.trailing.equalTo(self.contentView).offset(-DWScale(8));
        make.top.equalTo(self.contentView).offset(DWScale(8));
        make.bottom.equalTo(self.contentView).offset(-DWScale(8));
    }];
    
    UILongPressGestureRecognizer *stickersLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(stickersLongTapClick:)];
    [self.contentView addGestureRecognizer:stickersLongTap];
}

#pragma mark - Model
- (void)setCollectModel:(LingIMStickersModel *)collectModel {
    _collectModel = collectModel;
    
    if (![NSString isNil:_collectModel.assetAddIcon]) {
        _collectionItem.image = ImgNamed(_collectModel.assetAddIcon);
    } else {
        [_collectionItem sd_setImageWithURL:[_collectModel.thumbUrl getImageFullUrl] placeholderImage:DefaultImage options:SDWebImageAllowInvalidSSLCertificates];
    }
}

#pragma mark - Action
- (void)stickersLongTapClick:(UILongPressGestureRecognizer *)longPressGesture {
    if (self.cellIndexPath.row == 0 || self.cellIndexPath.row == self.cellTotalIndex - 1 || self.cellIndexPath.row == self.cellTotalIndex - 2) {
        return;
    }
    if (longPressGesture.state == UIGestureRecognizerStateBegan){
        if ([self.delegate respondsToSelector:@selector(collectionStickersLongTapAction:)]) {
            [self.delegate collectionStickersLongTapAction:self.cellIndexPath];
        }
    }
}

@end
