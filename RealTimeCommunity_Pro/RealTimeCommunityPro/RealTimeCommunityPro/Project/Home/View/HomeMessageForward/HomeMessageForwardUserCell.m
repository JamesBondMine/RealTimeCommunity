//
//  HomeMessageForwardUserCell.m
//  CIMKit
//
//  Created by cusPro on 2022/12/7.
//

#import "HomeMessageForwardUserCell.h"
#import "BBBaseImageView.h"

@interface HomeMessageForwardUserCell ()

@property (nonatomic, strong) BBBaseImageView *ivHeader;

@end


@implementation HomeMessageForwardUserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];//水平方向翻
        
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    _ivHeader = [BBBaseImageView new];
    _ivHeader.layer.cornerRadius = DWScale(12);
    _ivHeader.layer.masksToBounds = YES;
    [self.contentView addSubview:_ivHeader];
    [_ivHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(DWScale(24), DWScale(24)));
    }];
}

#pragma mark - 数据赋值
- (void)setToUserDic:(NSDictionary *)toUserDic {
    _toUserDic = toUserDic;
    
    NSInteger chatType = [[_toUserDic objectForKey:@"dialogType"] integerValue];
    
    NSString *avatarUri = (NSString *)[_toUserDic objectForKey:@"avatar"];
    NSString *avatarUrl = [avatarUri getImageFullString];
    
    if (chatType == CIMChatType_SingleChat) {
        [_ivHeader loadAvatarWithUserImgContent:avatarUrl defaultImg:DefaultAvatar];
    }
    
    if (chatType == CIMChatType_GroupChat) {
        [_ivHeader loadAvatarWithUserImgContent:avatarUrl defaultImg:DefaultGroup];
    }
}

@end
