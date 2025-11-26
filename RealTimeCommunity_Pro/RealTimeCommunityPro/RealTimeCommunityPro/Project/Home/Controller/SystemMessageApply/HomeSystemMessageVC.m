//
//  HomeSystemMessageVC.m
//  CIMKit
//
//  Created by cusPro on 2023/5/9.
//

#import "HomeSystemMessageVC.h"

#import "JXCategoryView.h"

#import "ZScrollView.h"
#import "HomeSystemMessageAllVC.h"//全部
#import "HomeSystemMessagePendReviewVC.h"//待审核

@interface HomeSystemMessageVC () <NJSelectCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) LJCategoryTitleView *viewCategory;
@property (nonatomic, strong) ZScrollView *scrollView;
@property (nonatomic, strong) HomeSystemMessageAllVC *vcAllReview;
@property (nonatomic, strong) HomeSystemMessagePendReviewVC *vcPendReview;

@end

@implementation HomeSystemMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.groupHelperType == ZGroupHelperFormTypeGroupManager) {
        self.navTitleStr = MultilingualTranslation(@"进群申请");
    }
    if (self.groupHelperType == ZGroupHelperFormTypeSessionList) {
        self.navTitleStr = MultilingualTranslation(@"群通知");
    }
    [self setupUI];

    [self sendSystemMessageRead];
}

#pragma mark - 界面布局
- (void)setupUI {
    _viewCategory = [[LJCategoryTitleView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH, DScreenWidth, DWScale(40))];
    _viewCategory.delegate = self;
    _viewCategory.titles = @[MultilingualTranslation(@"全部"),MultilingualTranslation(@"待审核")];
    _viewCategory.titleColorGradientEnabled = YES;
    _viewCategory.titleLabelZoomScale = YES;
    _viewCategory.titleFont = FONTB(16);
    _viewCategory.titleLabelZoomScale = 1.0;
    WeakSelf
    self.view.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        switch (themeIndex) {
            case 1:
            {
                //暗黑
                weakSelf.viewCategory.titleColor = COLOR_66_DARK;
                weakSelf.viewCategory.titleSelectedColor = COLOR_33_DARK;
            }
                break;
                
            default:
            {
                weakSelf.viewCategory.titleColor = COLOR_66;
                weakSelf.viewCategory.titleSelectedColor = COLOR_33;
            }
                break;
        }
    };
    //指示器
    NJSelectCategoryIndicatorBackgroundView *lineView = [[NJSelectCategoryIndicatorBackgroundView alloc] init];
    lineView.indicatorColor = COLOR_4791FF;
    lineView.componentPosition = JXCategoryComponentPosition_Bottom;
    lineView.verticalMargin = 5;
    _viewCategory.indicators = @[lineView];
    
    _scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH + DWScale(40), DScreenWidth, DScreenHeight - DNavStatusBarH - DWScale(40) - DHomeBarH)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delaysContentTouches = NO;
    _scrollView.contentSize = CGSizeMake(DScreenWidth * 2, 0);
    _scrollView.bounces = NO;
    
    [self.view addSubview:self.viewCategory];
    [self.view addSubview:self.scrollView];
    self.viewCategory.contentScrollView = self.scrollView;
    
    _vcAllReview = [HomeSystemMessageAllVC new];
    _vcAllReview.groupHelperType = self.groupHelperType;
    _vcAllReview.groupId = self.groupId;
    _vcAllReview.view.frame = CGRectMake(0, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_vcAllReview];
    [self.scrollView addSubview:_vcAllReview.view];
    
    _vcPendReview = [HomeSystemMessagePendReviewVC new];
    _vcPendReview.groupHelperType = self.groupHelperType;
    _vcPendReview.groupId = self.groupId;
    _vcPendReview.view.frame = CGRectMake(DScreenWidth, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_vcPendReview];
    [self.scrollView addSubview:_vcPendReview.view];
}

#pragma mark - 系统消息(群助手)消息已读
- (void)sendSystemMessageRead {
    if (_sessionModel) {
        //发送消息已读
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
        [dict setObjectSafe:@(5) forKey:@"chatType"];
        [dict setObjectSafe:_sessionModel.sessionLatestMessage.serviceMsgID forKey:@"smsgId"];
        [dict setObjectSafe:_sessionModel.sessionID forKey:@"sendMsgUserUid"];
        
        [[LingIMSDKManager sharedTool] readedMessage:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            
        }];
    }
}
@end
