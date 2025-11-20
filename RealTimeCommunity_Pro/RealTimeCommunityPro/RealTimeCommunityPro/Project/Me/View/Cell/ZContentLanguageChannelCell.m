//
//  ZContentLanguageChannelCell.m
//  CIMKit
//
//  Created by cusPro on 2023/9/14.
//

#import "ZContentLanguageChannelCell.h"

@interface ZContentLanguageChannelCell()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *imgViewSelected;

@end


@implementation ZContentLanguageChannelCell

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
    _imgViewSelected = [[UIImageView alloc] initWithImage:ImgNamed(@"remi_icon_selected_blue")];
    _imgViewSelected.hidden = YES;
    [self.contentView addSubview:_imgViewSelected];
    [_imgViewSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView).offset(-DWScale(16));
        make.size.mas_equalTo(CGSizeMake(DWScale(23), DWScale(23)));
    }];
    
    _titleLbl = [UILabel new];
    _titleLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    _titleLbl.font = FONTN(16);
    [self.contentView addSubview:_titleLbl];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(DWScale(16));
        make.trailing.equalTo(_imgViewSelected.mas_leading).offset(-DWScale(16));
        make.centerY.equalTo(self.contentView);
    }];
}


#pragma mark - Setter
- (void)setChannelModel:(MeTranslateChannelLanguageModel *)channelModel {
    _channelModel = channelModel;
    
    _titleLbl.text = _channelModel.name;
}

- (void)setLanguageModel:(ZTranslateLanguageModel *)languageModel {
    _languageModel = languageModel;
    
    _titleLbl.text = _languageModel.name;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    _imgViewSelected.hidden = !_isSelect;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
