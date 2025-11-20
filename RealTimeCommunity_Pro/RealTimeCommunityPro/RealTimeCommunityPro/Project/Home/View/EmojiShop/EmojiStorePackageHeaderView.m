//
//  EmojiStorePackageHeaderView.m
//  CIMKit
//
//  Created by cusPro on 2023/10/25.
//

#import "EmojiStorePackageHeaderView.h"

@interface EmojiStorePackageHeaderView ()

@property (nonatomic, strong) UILabel *headerTitleLbl;

@end


@implementation EmojiStorePackageHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    _headerTitleLbl = [UILabel new];
    _headerTitleLbl.text = MultilingualTranslation(@"精选表情包");
    _headerTitleLbl.font = FONTR(14);
    _headerTitleLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    [self.contentView addSubview:_headerTitleLbl];
    [_headerTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(DWScale(16));
        make.trailing.equalTo(self.contentView).offset(-DWScale(16));
        make.height.mas_equalTo(DWScale(22));
    }];
}

#pragma mark - Setter
- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    
    _headerTitleLbl.hidden = !_isShow;
}

@end
