//
//  ZGroupSetBasicInfoCell.m
//  CIMKit
//
//  Created by cusPro on 2022/11/7.
//

#import "ZGroupSetBasicInfoCell.h"

@interface ZGroupSetBasicInfoCell ()


@property (nonatomic, strong) UILabel *lblMemberCount;
@end

@implementation ZGroupSetBasicInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        
        for (id obj in self.subviews)
        {
            if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
            {
                UIScrollView *scroll = (UIScrollView *) obj;
                scroll.delaysContentTouches =NO;
                break;
            }
        }
        
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    _viewBg = [[UIButton alloc] init];
    _viewBg.frame = CGRectMake(DWScale(16), 0, DScreenWidth - DWScale(32), DWScale(54));
    _viewBg.tkThemebackgroundColors =  @[COLORWHITE, COLOR_F5F6F9_DARK];
    [_viewBg setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE]] forState:UIControlStateSelected];
    [_viewBg setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE]] forState:UIControlStateHighlighted];
    // 商务风格：添加卡片阴影
    _viewBg.layer.shadowColor = [UIColor blackColor].CGColor;
    _viewBg.layer.shadowOffset = CGSizeMake(0, 2);
    _viewBg.layer.shadowOpacity = 0.06;
    _viewBg.layer.shadowRadius = 4;
    _viewBg.layer.masksToBounds = NO;
    [_viewBg addTarget:self action:@selector(cellTouchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_viewBg];
    
    _lblTypeName = [UILabel new];
    _lblTypeName.font = FONTR(16);
    _lblTypeName.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    [_viewBg addSubview:_lblTypeName];
    [_lblTypeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_viewBg);
        make.leading.equalTo(_viewBg).offset(DWScale(16));
    }];
    
    UIImageView *ivArrowTop = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
    [_viewBg addSubview:ivArrowTop];
    [ivArrowTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_viewBg);
        make.trailing.equalTo(_viewBg).offset(-DWScale(16));
        make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
    }];
    
    _ivGroup = [[BBBaseImageView alloc] initWithImage:DefaultAvatar];
    // 商务风格：更小的圆角
    _ivGroup.layer.cornerRadius = DWScale(8);
    _ivGroup.layer.masksToBounds = YES;
    // 商务风格：添加边框
    _ivGroup.layer.borderWidth = 0.5;
    _ivGroup.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.08].CGColor;
    [_viewBg addSubview:_ivGroup];
    [_ivGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_viewBg);
        make.trailing.equalTo(ivArrowTop.mas_leading).offset(DWScale(-4));
        make.size.mas_equalTo(CGSizeMake(DWScale(40), DWScale(40)));
    }];
    
    _lblGroupName = [UILabel new];
    _lblGroupName.font = FONTR(14);
    _lblGroupName.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    _lblGroupName.text = @"Harold、啊tui～、Almost、A12312";
    _lblGroupName.textAlignment = NSTextAlignmentRight;
    [_viewBg addSubview:_lblGroupName];
    [_lblGroupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_viewBg);
        make.trailing.equalTo(ivArrowTop.mas_leading).offset(DWScale(-4));
        make.width.mas_equalTo(DWScale(195));
    }];
    
    _ivQrCode = [[BBBaseImageView alloc] initWithImage:ImgNamed(@"s_qr_logo")];
    [_viewBg addSubview:_ivQrCode];
    [_ivQrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_viewBg);
        make.trailing.equalTo(ivArrowTop.mas_leading).offset(DWScale(-4));
        make.size.mas_equalTo(CGSizeMake(DWScale(16), DWScale(16)));
    }];
    
}
#pragma mark - 交互事件
- (void)cellTouchAction {
    if ([self.baseDelegate respondsToSelector:@selector(cellClickAction:)]) {
        [self.baseDelegate cellClickAction:self.baseCellIndexPath];
    }
}

+ (CGFloat)defaultCellHeight {
    return DWScale(54);
}

- (void)cellConfigWithTitle:(NSString *)cellTitle model:(LingIMGroup *)model{
    _ivGroup.hidden = YES;
    _lblGroupName.hidden = YES;
    _ivQrCode.hidden = YES;
    
    if ([cellTitle isEqualToString:MultilingualTranslation(@"群头像")]) {
        [_viewBg round:DWScale(6) RectCorners:UIRectCornerAllCorners]; // 商务风格：更小圆角
        _ivGroup.hidden = NO;
        _lblGroupName.hidden = YES;
        _ivQrCode.hidden = YES;
        _lblTypeName.text = MultilingualTranslation(@"群头像");
        [_ivGroup sd_setImageWithURL:[model.groupAvatar getImageFullUrl] placeholderImage:DefaultGroup options:SDWebImageAllowInvalidSSLCertificates];
    } else if ([cellTitle isEqualToString:MultilingualTranslation(@"群名称")]) {
        [_viewBg round:DWScale(6) RectCorners:UIRectCornerAllCorners]; // 商务风格：更小圆角
        _ivGroup.hidden = YES;
        _lblGroupName.hidden = NO;
        _ivQrCode.hidden = YES;
        _lblTypeName.text = MultilingualTranslation(@"群名称");
        _lblGroupName.text = model.groupName;
    } else if ([cellTitle isEqualToString:MultilingualTranslation(@"群二维码")]) {
        [_viewBg round:6 RectCorners:UIRectCornerTopLeft | UIRectCornerTopRight]; // 商务风格：更小圆角
        _ivGroup.hidden = YES;
        _lblGroupName.hidden = YES;
        _ivQrCode.hidden = NO;
        _lblTypeName.text = MultilingualTranslation(@"群二维码");
    }
    
}

@end
