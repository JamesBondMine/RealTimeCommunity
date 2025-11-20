//
//  CNGroupListCell.m
//  CIMKit
//
//  Created by cusPro on 2022/9/14.
//

#import "CNGroupListCell.h"
#import "BBBaseImageView.h"

@interface CNGroupListCell ()
@property (nonatomic, strong) BBBaseImageView *ivHeader;
@property (nonatomic, strong) UILabel *lblGroupName;
@end

@implementation CNGroupListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    [self.contentView addSubview:self.baseContentButton];
    self.baseContentButton.frame = CGRectMake(0, 0, DScreenWidth, DWScale(68));
    
    _ivHeader = [[BBBaseImageView alloc] initWithImage:DefaultGroup];
    _ivHeader.frame = CGRectMake(DWScale(16), DWScale(12), DWScale(44), DWScale(44));
    _ivHeader.layer.cornerRadius = DWScale(22);
    _ivHeader.layer.masksToBounds = YES;
    [self.contentView addSubview:_ivHeader];
    
    [_ivHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(DWScale(16));
        make.top.mas_equalTo(self.contentView.mas_top).offset(DWScale(12));
        make.size.mas_equalTo(CGSizeMake(DWScale(44), DWScale(44)));

    }];
    
    _lblGroupName = [UILabel new];
    _lblGroupName.text = @"";
    _lblGroupName.font = FONTR(16);
    _lblGroupName.numberOfLines = 1;
    _lblGroupName.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    [self.contentView addSubview:_lblGroupName];
    [_lblGroupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
        make.centerY.equalTo(_ivHeader);
        make.trailing.equalTo(self.contentView).offset(-DWScale(16));
    }];
    
}
+ (CGFloat)defaultCellHeight {
    return DWScale(68);
}
#pragma mark - 数据赋值
- (void)setGroupModel:(LingIMGroupModel *)groupModel {
    if (groupModel) {
        _groupModel = groupModel;
        _lblGroupName.text = groupModel.groupName;
        
        [_ivHeader sd_setImageWithURL:[groupModel.groupAvatar getImageFullUrl] placeholderImage:DefaultGroup options:SDWebImageAllowInvalidSSLCertificates];
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
