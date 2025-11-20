//
//  SpecMyMiniAppItem.m
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

#import "SpecMyMiniAppItem.h"
#import "BBBaseImageView.h"

@interface SpecMyMiniAppItem ()

@property (nonatomic, strong) BBBaseImageView *ivMiniApp;
@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) UILabel *lblMiniApp;
@property (nonatomic, strong) LingIMMiniAppModel *miniAppModel;

@end

@implementation SpecMyMiniAppItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    CGFloat itemW = (DScreenWidth - DWScale(20)) / 6.0;
    [self.contentView addSubview:self.baseContentButton];
    self.baseContentButton.frame = CGRectMake(0, 0, itemW, DWScale(81));
    self.baseContentButton.layer.cornerRadius = DWScale(10);
    self.baseContentButton.layer.masksToBounds = YES;
    
    _ivMiniApp = [[BBBaseImageView alloc] initWithImage:ImgNamed(@"remini_mini_app_add")];
    _ivMiniApp.layer.cornerRadius = (itemW - DWScale(16)) / 2.0;
    _ivMiniApp.layer.masksToBounds = YES;
    [self.contentView addSubview:_ivMiniApp];
    [_ivMiniApp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(DWScale(8));
        make.size.mas_equalTo(CGSizeMake(itemW - DWScale(16), itemW - DWScale(16)));
    }];
    
    _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDelete.hidden = YES;
    [_btnDelete setImage:ImgNamed(@"remini_mini_app_delete") forState:UIControlStateNormal];
    [_btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btnDelete];
    [_btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ivMiniApp.mas_top).offset(DWScale(5));
        make.centerX.equalTo(_ivMiniApp.mas_leading).offset(DWScale(5));
        make.size.mas_equalTo(CGSizeMake(DWScale(14), DWScale(14)));
    }];
    
    _lblMiniApp = [UILabel new];
    _lblMiniApp.preferredMaxLayoutWidth = itemW - DWScale(10);
    _lblMiniApp.tkThemetextColors = @[COLORWHITE, COLORWHITE];
    _lblMiniApp.font = FONTR(12);
    _lblMiniApp.textAlignment = NSTextAlignmentCenter;
    _lblMiniApp.text = MultilingualTranslation(@"添加");
    [self.contentView addSubview:_lblMiniApp];
    [_lblMiniApp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-DWScale(8));
        make.leading.equalTo(self.contentView).offset(DWScale(3));
        make.trailing.equalTo(self.contentView).offset(-DWScale(3));
    }];
}

#pragma mark - 交互事件
- (void)btnDeleteClick {
    if (_miniAppModel && _delegate && [_delegate respondsToSelector:@selector(myMiniAppDelete:)]) {
        [_delegate myMiniAppDelete:self.baseCellIndexPath];
    }
}

#pragma mark - 界面赋值
- (void)configItemWith:(LingIMMiniAppModel *)miniAppModel manage:(BOOL)manageItem {
    _miniAppModel = miniAppModel;
    if (miniAppModel) {
        [self.ivMiniApp sd_setImageWithURL:[miniAppModel.qaAppPic getImageFullUrl] placeholderImage:ImgNamed(@"remini_mini_app_icon") options:SDWebImageAllowInvalidSSLCertificates];
        _lblMiniApp.text = miniAppModel.qaName;
        if(manageItem){
            if(miniAppModel.allowUserDelete){
                _btnDelete.hidden = !manageItem;
            }else{
                _btnDelete.hidden = YES;
            }
        }else{
            _btnDelete.hidden = !manageItem;
        }
    }else {
        _ivMiniApp.image = ImgNamed(@"remini_mini_app_add");
        _lblMiniApp.text = MultilingualTranslation(@"添加");
        _btnDelete.hidden = YES;
    }
}

@end
