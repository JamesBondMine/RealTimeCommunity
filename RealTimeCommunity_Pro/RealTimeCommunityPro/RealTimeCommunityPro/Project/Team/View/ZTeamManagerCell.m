//
//  ZTeamManagerCell.m
//  CIMKit
//
//  Created by cusPro on 2023/7/20.
//

#import "ZTeamManagerCell.h"

@interface ZTeamManagerCell ()

@property (nonatomic, strong) UIView *teamBackView;
@property (nonatomic, strong) UILabel *teamNameLbl;
@property (nonatomic, strong) UILabel *teamMemberLbl;
@property (nonatomic, strong) UIButton *operatorBtn;

@end

@implementation ZTeamManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLORWHITE_DARK];
        [self setupUI];
        
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    _teamBackView = [UIView new];
    _teamBackView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [self.contentView addSubview:_teamBackView];
    [_teamBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(DWScale(10));
        make.leading.bottom.trailing.equalTo(self.contentView);
    }];
    
    _operatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_operatorBtn setTitle:MultilingualTranslation(@"默认团队") forState:UIControlStateNormal];
    [_operatorBtn setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
    [_operatorBtn setTkThemebackgroundColors:@[COLOR_81D8CF, COLOR_81D8CF_DARK]];
    _operatorBtn.titleLabel.font = FONTR(10);
    if([ZLanguageTOOL.currentLanguage.languageName_zn isEqualToString:@"简体中文"]||
       [ZLanguageTOOL.currentLanguage.languageName_zn isEqualToString:@"繁体中文"]){
        [_operatorBtn rounded:DWScale(11)];
    }else{
        [_operatorBtn rounded:DWScale(15)];
    }
    _operatorBtn.userInteractionEnabled = NO;
    [_operatorBtn addTarget:self action:@selector(btnOperatorClick) forControlEvents:UIControlEventTouchUpInside];
    [_teamBackView addSubview:_operatorBtn];
    [_operatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_teamBackView).offset(DWScale(12));
        make.trailing.equalTo(_teamBackView).offset(-DWScale(19));
        if([ZLanguageTOOL.currentLanguage.languageName_zn isEqualToString:@"简体中文"]||
           [ZLanguageTOOL.currentLanguage.languageName_zn isEqualToString:@"繁体中文"]){
            make.size.mas_equalTo(CGSizeMake(DWScale(64), DWScale(22)));
        }else{
            make.size.mas_equalTo(CGSizeMake(DWScale(80), DWScale(30)));
        }
    }];
    _operatorBtn.titleLabel.numberOfLines = 2;
    
    _teamNameLbl = [UILabel new];
    _teamNameLbl.text = @"";
    _teamNameLbl.font = FONTB(14);
    _teamNameLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    [_teamBackView addSubview:_teamNameLbl];
    [_teamNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_teamBackView).offset(DWScale(12));
        make.leading.equalTo(_teamBackView).offset(DWScale(19));
        make.trailing.equalTo(_operatorBtn.mas_leading).offset(-DWScale(20));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    _teamMemberLbl = [UILabel new];
    _teamMemberLbl.text = @"";
    _teamMemberLbl.font = FONTN(10);
    _teamMemberLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    [_teamBackView addSubview:_teamMemberLbl];
    [_teamMemberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_teamNameLbl.mas_bottom).offset(DWScale(13));
        make.leading.trailing.equalTo(_teamNameLbl);
        make.height.mas_equalTo(DWScale(20));
    }];
}
#pragma mark - 界面赋值
- (void)configCell:(ZTeamManagerType)managerType model:(NTMTeamModel *)model {
    if (model) {
        //团队名称
        _teamNameLbl.text = model.teamName;
        //总团队人数
        NSString *numStr = [NSString stringWithFormat:@"%ld", (long)model.totalInviteNum];
        NSString *numTitleStr = MultilingualTranslation(@"总团队人数 ");
        NSString *memberNumStr = [NSString stringWithFormat:@"%@%@", numTitleStr, numStr];
        NSMutableAttributedString *memberNumAttStr = [[NSMutableAttributedString alloc] initWithString:memberNumStr];
        [memberNumAttStr configAttStrLightColor:COLOR_33 darkColor:COLOR_33_DARK range:NSMakeRange(0, memberNumStr.length)];
        [memberNumAttStr configAttStrLightColor:COLOR_81D8CF darkColor:COLOR_81D8CF_DARK range:NSMakeRange(numTitleStr.length, numStr.length)];
        [memberNumAttStr addAttribute:NSFontAttributeName value:FONTN(10) range:NSMakeRange(0, memberNumStr.length)];
        [memberNumAttStr addAttribute:NSFontAttributeName value:FONTN(14) range:NSMakeRange(numTitleStr.length, numStr.length)];
        _teamMemberLbl.attributedText = memberNumAttStr;
        //团队状态
        if (model.isDefaultTeam == 1) {
            _operatorBtn.userInteractionEnabled = NO;
            [_operatorBtn setTitle:MultilingualTranslation(@"默认团队") forState:UIControlStateNormal];
            [_operatorBtn setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
            [_operatorBtn setTkThemebackgroundColors:@[COLOR_81D8CF, COLOR_81D8CF_DARK]];
        } else {
            if (managerType == ZTeamManagerTypeNone) {
                _operatorBtn.userInteractionEnabled = YES;
                [_operatorBtn setTitle:MultilingualTranslation(@"选为默认") forState:UIControlStateNormal];
                [_operatorBtn setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
                [_operatorBtn setTkThemebackgroundColors:@[COLOR_F6F6F6, COLOR_F6F6F6_DARK]];
            } else {
                _operatorBtn.userInteractionEnabled = YES;
                [_operatorBtn setTitle:MultilingualTranslation(@"删除") forState:UIControlStateNormal];
                [_operatorBtn setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
                [_operatorBtn setTkThemebackgroundColors:@[COLOR_EA645D, COLOR_EA645D_DARK]];
            }
        }
    }
}

#pragma mark - Action
- (void)btnOperatorClick {
    if (_delegate && [_delegate respondsToSelector:@selector(teamManagerOperator:)]) {
        [_delegate teamManagerOperator:self.baseCellIndexPath];
    }
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
