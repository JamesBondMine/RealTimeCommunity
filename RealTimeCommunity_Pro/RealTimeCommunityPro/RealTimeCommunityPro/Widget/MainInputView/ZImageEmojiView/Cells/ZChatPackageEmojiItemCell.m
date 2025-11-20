//
//  ZChatPackageEmojiItemCell.m
//  CIMKit
//
//  Created by cusPro on 2023/8/14.
//

#import "ZChatPackageEmojiItemCell.h"

@interface ZChatPackageEmojiItemCell()

@property (nonatomic, strong) UIImageView *emojiItemImgView;

@end

@implementation ZChatPackageEmojiItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    _emojiItemImgView = [[UIImageView alloc] init];
    _emojiItemImgView.contentMode = UIViewContentModeScaleAspectFit;
    [_emojiItemImgView rounded:DWScale(8)];
    [self.contentView addSubview:_emojiItemImgView];
    [_emojiItemImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(DWScale(10));
        make.trailing.equalTo(self.contentView).offset(-DWScale(10));
        make.top.equalTo(self.contentView).offset(DWScale(8));
        make.bottom.equalTo(self.contentView).offset(-DWScale(8));
    }];
}

#pragma mark - Model
- (void)setStickerModel:(LingIMStickersModel *)stickerModel {
    _stickerModel = stickerModel;
    
    [_emojiItemImgView sd_setImageWithURL:[_stickerModel.thumbUrl getImageFullUrl] placeholderImage:DefaultImage options:SDWebImageAllowInvalidSSLCertificates];
}

@end
