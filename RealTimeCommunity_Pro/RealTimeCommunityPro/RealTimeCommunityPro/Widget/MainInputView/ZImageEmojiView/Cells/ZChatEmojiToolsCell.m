//
//  ZChatEmojiToolsCell.m
//  CIMKit
//
//  Created by cusPro on 2023/8/10.
//

#import "ZChatEmojiToolsCell.h"

@interface ZChatEmojiToolsCell()

@property (nonatomic, strong) UIButton *packageItem;

@end

@implementation ZChatEmojiToolsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    _packageItem = [UIButton new];
    _packageItem.userInteractionEnabled = NO;
    _packageItem.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [_packageItem rounded:DWScale(6)];
    [self.contentView addSubview:_packageItem];
    [_packageItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(DWScale(8));
        make.trailing.equalTo(self.contentView).offset(-DWScale(8));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(DWScale(30), DWScale(30)));
    }];
}

#pragma mark - 数据赋值
- (void)setItemModel:(LingIMStickersPackageModel *)itemModel {
    _itemModel = itemModel;
    
    if (_itemModel.isSelected) {
        _packageItem.tkThemebackgroundColors = @[COLOR_F2F3F5, COLOR_F2F3F5];
    } else {
        _packageItem.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    }
    if (![NSString isNil:itemModel.itemAssetCoverName]) {
        [_packageItem setImage:[UIImage imageNamed:itemModel.itemAssetCoverName] forState:UIControlStateNormal];
    } else {
        [_packageItem sd_setImageWithURL:[itemModel.thumbUrl getImageFullUrl] forState:UIControlStateNormal placeholderImage:DefaultGroup options:SDWebImageAllowInvalidSSLCertificates];
    }
}

@end
