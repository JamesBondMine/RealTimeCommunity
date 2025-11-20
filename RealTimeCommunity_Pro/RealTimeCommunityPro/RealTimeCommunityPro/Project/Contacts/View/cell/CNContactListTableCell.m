//
//  CNContactListTableCell.m
//  CIMKit
//
//  Created by cusPro on 2022/9/9.
//

#import "CNContactListTableCell.h"
#import "ZToolManager.h"

@interface CNContactListTableCell()

@property (nonatomic, strong)UIImageView *headImgView;
@property (nonatomic, strong) UILabel *userRoleName;//用户角色名称
@property (nonatomic, strong)UILabel *nickNameLabel;
@property (nonatomic, strong) UIButton *tempBtn;
@end

@implementation CNContactListTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        self.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.baseContentButton];
    self.baseContentButton.frame = CGRectMake(0, 0, DScreenWidth, DWScale(68));
    
    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, DWScale(44), DWScale(44))];
    [self.headImgView rounded:DWScale(22)];
    [self.contentView addSubview:self.headImgView];
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(DWScale(44), DWScale(44)));
    }];
    
    self.userRoleName = [UILabel new];
    self.userRoleName.text = @"";
    self.userRoleName.tkThemetextColors = @[COLORWHITE, COLORWHITE];
    self.userRoleName.font = FONTN(7);
    self.userRoleName.tkThemebackgroundColors = @[COLOR_EAB243, COLOR_EAB243_DARK];
    self.userRoleName.textAlignment = NSTextAlignmentCenter;
    [self.userRoleName rounded:DWScale(15.4)/2];
    self.userRoleName.hidden = YES;
    [self.contentView addSubview:self.userRoleName];
    [self.userRoleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headImgView).offset(-DWScale(1));
        make.trailing.equalTo(self.headImgView).offset(DWScale(1));
        make.bottom.equalTo(self.headImgView);
        make.height.mas_equalTo(DWScale(15.4));
    }];
    
    self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+DWScale(44)+10, DWScale(68)/2 - DWScale(25)/2, DScreenWidth - (15+DWScale(44)+10) - 30, DWScale(25))];
    self.nickNameLabel.text = @"";
    self.nickNameLabel.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    self.nickNameLabel.font = FONTN(16);
    self.nickNameLabel.textAlignment = NSTextAlignmentLeft;
    self.nickNameLabel.numberOfLines = 1;
    [self.contentView addSubview:self.nickNameLabel];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self.headImgView);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-40);
    }];
    
    _viewOnline = [UIView new];
    _viewOnline.tkThemebackgroundColors = @[HEXCOLOR(@"01BC46"), HEXCOLOR(@"01BC46")];
    _viewOnline.layer.cornerRadius = DWScale(3);
    _viewOnline.layer.masksToBounds = YES;
    _viewOnline.hidden = YES;
    [self.contentView addSubview:_viewOnline];
    [_viewOnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.headImgView);
        make.size.mas_equalTo(CGSizeMake(DWScale(6), DWScale(6)));
    }];
}
#pragma mark - 数据赋值
- (void)setFriendModel:(LingIMFriendModel *)friendModel {
    if (friendModel) {
        _friendModel = friendModel;
        
        NSString *imgUrl = [NSString loadAvatarWithUserStatus:_friendModel.disableStatus avatarUri:friendModel.avatar];
        [self.headImgView loadAvatarWithUserImgContent:imgUrl defaultImg:DefaultAvatar];
        self.nickNameLabel.text = [NSString loadNickNameWithUserStatus:friendModel.disableStatus realNickName:friendModel.showName];
        //角色名称
        NSString *roleName = [UserManager matchUserRoleConfigInfo:_friendModel.roleId disableStatus:_friendModel.disableStatus];
        if ([NSString isNil:roleName]) {
            self.userRoleName.hidden = YES;
        } else {
            self.userRoleName.hidden = NO;
            self.userRoleName.text = roleName;
        }
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
