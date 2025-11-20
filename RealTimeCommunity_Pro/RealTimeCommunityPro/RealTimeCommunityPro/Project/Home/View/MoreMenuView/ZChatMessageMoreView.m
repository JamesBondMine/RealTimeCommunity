//
//  ZChatMessageMoreView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/28.
//

#import "ZChatMessageMoreView.h"
#import "ZToolManager.h"

@interface ZChatMessageMoreView () <CMessageMoreItemViewDelegate>

@property (nonatomic, assign) CGRect targetRect;
@property (nonatomic, assign) BOOL isFromMy;
@property (nonatomic, assign) BOOL isBottom;
@property (nonatomic, assign) CGSize msgContentSize;
@property (nonatomic, strong) NSArray *menuArr;
@property (nonatomic, strong) CMessageMoreItemView *viewMoreItem;
@property (nonatomic, strong) UIImageView *arrowImgView;

@end

@implementation ZChatMessageMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (instancetype)initWithMenu:(NSArray *)menuArr targetRect:(CGRect)targetRect isFromMy:(BOOL)isFromMy isBottom:(BOOL)isBottom msgContentSize:(CGSize)msgContentSize; {
    self = [super init];
    if (self) {
        _targetRect = targetRect;
        _isFromMy = isFromMy;
        _menuArr = menuArr;
        _isBottom = isBottom;
        _msgContentSize = msgContentSize;
        
        self.frame = CGRectMake(0, 0, DScreenWidth, DScreenHeight);
        self.backgroundColor = COLOR_CLEAR;
        [CurrentVC.view addSubview:self];
        
        //背景点击关闭事件
        UIControl *backAction = [[UIControl alloc] initWithFrame:self.bounds];
        [backAction addTarget:self action:@selector(hiddenMenuView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backAction];
        
        //显示菜单
        [self showMoreItemView];
    }
    return self;
}

#pragma mark - 界面布局
- (void)showMoreItemView {
    BOOL arrowIsTop = YES;
    //根据转换后cell在View的坐标，确定menu弹窗的frame
    CGFloat menuViewWidth = _menuArr.count > 5 ? DWScale(300) : DWScale(60) * _menuArr.count;
    CGFloat menuViewHeight = _menuArr.count > 5 ? DWScale(136) : DWScale(68);
    CGFloat menuViewX = _isFromMy ? (_targetRect.origin.x + _msgContentSize.width + 20 - menuViewWidth) : _targetRect.origin.x;
    CGFloat menuViewY;
    if (_isBottom) {
        arrowIsTop = NO;
        menuViewY = _targetRect.origin.y - (menuViewHeight - (_targetRect.size.height - _msgContentSize.height - 18 - 10)) - 3;
    } else {
        menuViewY = _targetRect.origin.y + _targetRect.size.height;
        arrowIsTop = YES;
        if ((menuViewY + menuViewHeight) > DScreenHeight) {
            arrowIsTop = NO;
            menuViewY = _targetRect.origin.y - (menuViewHeight - (_targetRect.size.height - _msgContentSize.height - 18 - 10)) - 3;
        }
    }
   
    //菜单View
    _viewMoreItem = [[CMessageMoreItemView alloc] initWithFrame:CGRectMake(menuViewX, menuViewY, menuViewWidth, menuViewHeight + 10)];
    _viewMoreItem.menuArr = _menuArr;
    _viewMoreItem.delegate = self;
    [self addSubview:_viewMoreItem];
    [_viewMoreItem resetFrameToFitRTL];

    CGFloat arrowImgX = _isFromMy ? (menuViewWidth - (_msgContentSize.width+18)/2 - 18/2) : (_msgContentSize.width+18)/2 - 18/2;
    //防止三角形箭头超出弹窗范围
    if (arrowImgX < 30 || arrowImgX > menuViewWidth - 30) {
        if (_isFromMy) {
            arrowImgX = menuViewWidth - 30;
        } else {
            arrowImgX = 30;
        }
    }
    
    CGFloat arrowImgY = arrowIsTop ? 0.5 : (menuViewHeight - 3);
    _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowImgX, arrowImgY, 18, 10)];
    _arrowImgView.image = arrowIsTop ? ImgNamed(@"remsg_c_more_arrow_up.png") : ImgNamed(@"remsg_c_more_arrow_down.png");
    [_viewMoreItem addSubview:_arrowImgView];
    [_arrowImgView resetFrameToFitRTL];

}

#pragma mark - CMessageMoreItemViewDelegate
- (void)menuItemViewSelectedAction:(MessageMenuItemActionType)actionType {
    if (self.menuClick) {
        self.menuClick(actionType);
    }
    [self hiddenMenuView];
}

//关闭菜单弹窗
- (void)hiddenMenuView {
    [self removeFromSuperview];
}

@end
