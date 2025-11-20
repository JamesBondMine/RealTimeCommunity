//
//  ZCustomProxyTableViewCell.m
//  CIMKit
//
//  Created by 小梦雯 on 2025/4/16.
//

#import "ZCustomProxyTableViewCell.h"

@implementation ZCustomProxyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    // 勾选图标
    _checkmarkIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_icon_checkbox_unselect_reb")];
    [self.contentView addSubview:_checkmarkIcon];
    
    // 标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONTR(14);
    [self.contentView addSubview:_titleLabel];
    
    // 箭头图标
    _arrowIcon = [[UIImageView alloc] init];
    _arrowIcon.image = ImgNamed(@"retm_team_arrow_gray");
    [self.contentView addSubview:_arrowIcon];
    
    self.line = [UIView new];
    self.line.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_F5F6F9_DARK];
    [self.contentView addSubview:self.line];
    
    [self.checkmarkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(DWScale(12));
        make.height.width.mas_offset(DWScale(16));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.checkmarkIcon.mas_trailing).offset(DWScale(8));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-DWScale(18));
        make.width.height.mas_offset(DWScale(16));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.contentView);
        make.height.mas_offset(DWScale(1));
    }];
}

- (void)configureWithTitle:(NSString *)title
                isSelected:(BOOL)isSelected
                 showArrow:(BOOL)showArrow
                  showLine:(BOOL)showLine {
    _titleLabel.text = title;
    
    // 更新勾选状态
    if (isSelected) {
        _checkmarkIcon.image = ImgNamed(@"relogimg_icon_checkbox_net_selected_reb");
    } else {
        _checkmarkIcon.image = ImgNamed(@"relogimg_icon_checkbox_unselect_reb");
    }
    
    // 控制箭头显隐
    _arrowIcon.hidden = !showArrow;
    
    self.line.hidden = !showLine;
}

@end
