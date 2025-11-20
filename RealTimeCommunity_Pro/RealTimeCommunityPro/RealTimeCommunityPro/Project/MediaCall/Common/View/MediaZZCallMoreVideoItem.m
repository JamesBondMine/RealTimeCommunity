//
//  MediaZZCallMoreVideoItem.m
//  CIMKit
//
//  Created by cusPro on 2023/2/6.
//

#import "MediaZZCallMoreVideoItem.h"
#import "ZToolManager.h"

@interface MediaZZCallMoreVideoItem ()

@end

@implementation MediaZZCallMoreVideoItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    WeakSelf
    
    self.contentView.tkThemebackgroundColors = @[COLOR_00, COLOR_00_DARK];
    _viewContent = [MediaZZCallMoreContentView new];
    [self.contentView addSubview:_viewContent];
    [_viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(DWScale(2));
        make.bottom.trailing.equalTo(self.contentView).offset(-DWScale(2));
    }];
    
    _viewContent.deleteMemberBlock = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(mediaCallMoreVideoItemDelete:)]) {
            [weakSelf.delegate mediaCallMoreVideoItemDelete:weakSelf.model];
        }
    };
    
}
#pragma mark - 数据赋值
- (void)setModel:(MCMediaCallGroupMemberModel *)model {
    if (model) {
        _model = model;
        _viewContent.hidden = NO;
        _viewContent.model = model;
    }else {
        _viewContent.hidden = YES;
    }
}
@end
