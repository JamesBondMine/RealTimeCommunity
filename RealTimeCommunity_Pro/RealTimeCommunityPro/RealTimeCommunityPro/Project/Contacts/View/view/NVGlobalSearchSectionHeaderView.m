//
//  NVGlobalSearchSectionHeaderView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/15.
//

#import "NVGlobalSearchSectionHeaderView.h"

@interface NVGlobalSearchSectionHeaderView ()
@property (nonatomic, strong) UILabel *lblTitle;
@end

@implementation NVGlobalSearchSectionHeaderView
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
    _lblTitle = [UILabel new];
    _lblTitle.font = FONTR(12);
    _lblTitle.tkThemetextColors = @[COLOR_99, COLOR_99_DARK];
    [self.contentView addSubview:_lblTitle];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(DWScale(16));
    }];
    
}
#pragma mark - 界面赋值
- (void)setHeaderSection:(NSInteger)headerSection {
    _headerSection = headerSection;
    
    if (headerSection == 0) {
        _lblTitle.text = MultilingualTranslation(@"联系人");
    }else if (headerSection == 1) {
        _lblTitle.text = MultilingualTranslation(@"群聊");
    }else if (headerSection == 2) {
        _lblTitle.text = MultilingualTranslation(@"聊天记录");
    }else {
        _lblTitle.text = @"";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
