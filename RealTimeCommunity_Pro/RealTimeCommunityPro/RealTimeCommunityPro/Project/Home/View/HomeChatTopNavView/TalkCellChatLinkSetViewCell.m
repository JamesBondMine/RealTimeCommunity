//
//  TalkCellChatLinkSetViewCell.m
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

#import "TalkCellChatLinkSetViewCell.h"

@interface TalkCellChatLinkSetViewCell()

@property (nonatomic, strong)UIButton *deleteBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UIButton *editBtn;
@property (nonatomic, strong)UIView *bottomLine;

@end


@implementation TalkCellChatLinkSetViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        [self setupUI];
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.editBtn];
    [self.contentView addSubview:self.bottomLine];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(DWScale(16));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(DWScale(30), DWScale(30)));
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.deleteBtn.mas_trailing).offset(DWScale(5));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(DWScale(22), DWScale(22)));
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-DWScale(16));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(DWScale(30), DWScale(30)));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(DWScale(4));
        make.trailing.equalTo(self.editBtn.mas_leading).offset(-DWScale(10));
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(DWScale(30));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(DWScale(6));
        make.trailing.equalTo(self.contentView).offset(-DWScale(6));
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(DWScale(1));
    }];
}

#pragma mark - Setter
- (void)setTagModel:(ZChatTagModel *)tagModel {
    _tagModel = tagModel;
    
    if (_tagModel.localType == 1) {
        [self.deleteBtn setImage:ImgNamed(@"remsg_icon_link_delete_unused") forState:UIControlStateNormal];
        self.deleteBtn.userInteractionEnabled = NO;
        self.editBtn.hidden = YES;
        [self.iconImgView setImage:ImgNamed(_tagModel.tagIcon)];
    } else {
        [self.deleteBtn setImage:ImgNamed(@"remsg_icon_link_delete_used") forState:UIControlStateNormal];
        self.deleteBtn.userInteractionEnabled = YES;
        self.editBtn.hidden = NO;
        [self.iconImgView sd_setImageWithURL:[_tagModel.tagIcon getImageFullUrl] placeholderImage:ImgNamed(@"remini_mini_app_icon") options:SDWebImageAllowInvalidSSLCertificates];
    }
    
    self.titleLbl.text = MultilingualTranslation(_tagModel.tagName);
}

#pragma mark - Action
- (void)deleteBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteChatLinkAction:)]) {
        [self.delegate deleteChatLinkAction:self.cellaPath.row];
    }
}

- (void)editBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editChatLinkAction:)]) {
        [self.delegate editChatLinkAction:self.cellaPath.row];
    }
}

#pragma mark - Lazy
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:ImgNamed(@"remsg_icon_link_delete_unused") forState:UIControlStateNormal];
        _deleteBtn.userInteractionEnabled = NO;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = ImgNamed(@"remini_mini_app_icon");
        [_iconImgView rounded:DWScale(22)/2];
    }
    return _iconImgView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"";
        _titleLbl.font = FONTN(14);
        _titleLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    }
    return _titleLbl;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setImage:ImgNamed(@"remsg_icon_link_edit") forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F6F6F6_DARK];
    }
    return _bottomLine;
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
