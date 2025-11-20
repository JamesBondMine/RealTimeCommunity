//
//  NVGlobalSearchSectionFooterView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/15.
//

#import "NVGlobalSearchSectionFooterView.h"
#import "UIButton+Addition.h"

@interface NVGlobalSearchSectionFooterView ()
@property (nonatomic, strong) UIButton *btnMore;
@end

@implementation NVGlobalSearchSectionFooterView
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
    _btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnMore setTitleColor:COLOR_81D8CF forState:UIControlStateNormal];
    _btnMore.tkThemebackgroundColors = @[HEXCOLOR(@"EDF4FF"),COLOR_EEEEEE_DARK];
    _btnMore.titleLabel.font = FONTR(12);
    [_btnMore addTarget:self action:@selector(btnMoreClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnMore setImage:ImgNamed(@"com_c_right_blue_arrow") forState:UIControlStateNormal];
    _btnMore.layer.cornerRadius = DWScale(13);
    _btnMore.layer.masksToBounds = YES;
    [_btnMore sizeToFit];
    [self.contentView addSubview:_btnMore];
}
#pragma mark - 数据赋值
- (void)setFooterSection:(NSInteger)footerSection {
    _footerSection = footerSection;
    
    CGFloat btnTitleW = CGFLOAT_MIN;
    
    if (footerSection == 0) {
        [_btnMore setTitle:MultilingualTranslation(@"更多联系人") forState:UIControlStateNormal];
        btnTitleW = DWScale(90);
    }else if (footerSection == 1) {
        [_btnMore setTitle:MultilingualTranslation(@"更多群聊") forState:UIControlStateNormal];
        btnTitleW = DWScale(90);
    }else if (footerSection == 2) {
        [_btnMore setTitle:MultilingualTranslation(@"更多聊天记录") forState:UIControlStateNormal];
        btnTitleW = DWScale(112);
    }
    
    [_btnMore mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(btnTitleW, DWScale(26)));
    }];
    
    [_btnMore setBtnImageAlignmentType:ButtonImageAlignmentTypeRight imageSpace:DWScale(6)];
}

#pragma mark - 交互事件
- (void)btnMoreClick {
    if (_delegate && [_delegate respondsToSelector:@selector(sectionFooterShowMore:)]) {
        [_delegate sectionFooterShowMore:_footerSection];
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
