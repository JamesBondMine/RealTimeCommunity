//
//  ZSystemFooterView.m
//  CIMKit
//
//  Created by cusPro on 2023/4/17.
//

#import "ZSystemFooterView.h"

@interface ZSystemFooterView ()

@property (nonatomic, strong) UILabel *contentInfoLal;

@end

@implementation ZSystemFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
        [self setupUI];
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    _contentInfoLal = [UILabel new];
    _contentInfoLal.font = FONTR(12); // 商务风格：更小、更精致的提示文字
    _contentInfoLal.numberOfLines = 0;
    _contentInfoLal.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    _contentInfoLal.tkThemetextColors = @[[UIColor colorWithWhite:0 alpha:0.45], [UIColor colorWithWhite:1 alpha:0.45]]; // 更淡的提示色
    [self.contentView addSubview:_contentInfoLal];
    [_contentInfoLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(DWScale(8));
        make.bottom.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(DWScale(16));
        make.trailing.equalTo(self.contentView).offset(-DWScale(16));
    }];
}

- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    _contentInfoLal.text = _contentStr;
}

@end
