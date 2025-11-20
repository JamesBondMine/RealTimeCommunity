//
//  ZMineCenterCell.m
//  CIMKit
//
//  Created by cusPro on 2022/11/12.
//

#import "ZMineCenterCell.h"

@interface ZMineCenterCell ()

@property (nonatomic, strong) UIButton *backView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *lblTip;

@end

@implementation ZMineCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconImgView];
    [self.backView addSubview:self.contentLbl];
    [self.backView addSubview:self.arrowImgView];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.lblTip];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.leading.equalTo(self.backView).offset(18);
        make.width.height.mas_equalTo(DWScale(24));
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.trailing.equalTo(self.backView).offset(-16);
        make.width.mas_equalTo(DWScale(8));
        make.height.mas_equalTo(DWScale(16));
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(8);
        make.trailing.equalTo(self.arrowImgView.mas_leading).offset(-10);
        make.height.mas_equalTo(DWScale(22));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView);
        make.leading.equalTo(self.backView).offset(16);
        make.trailing.equalTo(self.backView).offset(-16);
        make.height.mas_equalTo(0.8);
    }];
 
    [self.lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.trailing.equalTo(self.arrowImgView.mas_leading).offset(-DWScale(12));
    }];
}

#pragma mark - Data
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.iconImgView.image = ImgNamed((NSString *)[_dataDic objectForKey:@"imageName"]);
    self.contentLbl.text = (NSString *)[_dataDic objectForKey:@"titleName"];
}
- (void)configCellCornerWith:(NSIndexPath *)cellIndexPath totalIndex:(NSInteger)totalIndex {
    
    //圆角配置
    if (cellIndexPath.row == 0) {
        if (totalIndex == 1) {
            //说明只有一行
            [self.backView round:12 RectCorners:UIRectCornerAllCorners];
            self.lineView.hidden = YES;
        }else {
            //开头
            [self.backView round:12 RectCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
            self.lineView.hidden = NO;
        }
    }else if (cellIndexPath.row == totalIndex - 1) {
        //结尾
        [self.backView round:12 RectCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        self.lineView.hidden = YES;
    }else {
        //中间
        [self.backView round:0 RectCorners:UIRectCornerAllCorners];
        self.lineView.hidden = NO;
    }
    
}
- (void)configCellTipWith:(NSIndexPath *)cellIndexPath {
    
    if (cellIndexPath.section == 3 && cellIndexPath.row == 0) {
        //多语言
        self.lblTip.hidden = NO;
        self.lblTip.text = [MainLanguageManager shareManager].currentLanguage.languageName;
    }else {
        self.lblTip.hidden = YES;
    }
}

#pragma mark - Action
- (void)cellTouchAction {
    if ([self.baseDelegate respondsToSelector:@selector(cellClickAction:)]) {
        [self.baseDelegate cellClickAction:self.baseCellIndexPath];
    }
}

#pragma mark - Lazy
- (UIButton *)backView {
    if (!_backView) {
        _backView = [[UIButton alloc] init];
        _backView.frame = CGRectMake(16, 0, DScreenWidth - 16*2, DWScale(54));
        _backView.tkThemebackgroundColors = @[COLORWHITE, COLOR_EEEEEE_DARK];
        [_backView setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
        [_backView setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
        [_backView addTarget:self action:@selector(cellTouchAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _backView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.text = @"";
        _contentLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        _contentLbl.font = FONTN(16);
    }
    return _contentLbl;
}

- (UIImageView *)arrowImgView {
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = ImgNamed(@"com_c_arrow_right_gray");
    }
    return _arrowImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.tkThemebackgroundColors = @[COLOR_EEEEEE,COLOR_555555];
    }
    return _lineView;
}
- (UILabel *)lblTip {
    if (!_lblTip) {
        _lblTip = [UILabel new];
        _lblTip.tkThemetextColors = @[COLOR_99, COLOR_99_DARK];
        _lblTip.font = FONTR(14);
    }
    return _lblTip;
}

#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
