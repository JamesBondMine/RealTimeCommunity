//
//  ZMediaCallSampleVideoView.m
//  CIMKit
//
//  Created by cusPro on 2023/5/30.
//

#import "ZMediaCallSampleVideoView.h"
#import "ZToolManager.h"
#import "ZCallManager.h"


@implementation ZMediaCallSampleVideoView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        WeakSelf
        [ZTOOL doInMain:^{
            [weakSelf setupUI];
        }];
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    if ([ZCallManager sharedManager].callSDKType == LingIMCallSDKTypeZego) {
        //即构音视频通话
        _viewVideoZG = [UIView new];
        [self addSubview:_viewVideoZG];
        [_viewVideoZG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        //LiveKit音视频通话
        _viewVideo = [VideoView new];
        [self addSubview:_viewVideo];
        [_viewVideo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
