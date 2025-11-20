//
//  ZComplainVC.m
//  CIMKit
//
//  Created by cusPro on 2023/6/19.
//

#import "ZComplainVC.h"
#import "JXCategoryView.h"

#import "ZScrollView.h"
#import "ZComplainFromVC.h"

@interface ZComplainVC ()<NJSelectCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) LJCategoryTitleView *viewCategory;
@property (nonatomic, strong) ZScrollView *scrollView;
@property (nonatomic, strong) ZComplainFromVC *systemComplainVC;    //系统投诉
@property (nonatomic, strong) ZComplainFromVC *domainComplainVC;    //企业号、域名投诉
@property (nonatomic, assign) NSInteger currentSelectedIndex;//当前选中下标

@end

@implementation ZComplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    self.navView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self setupUI];
}

#pragma mark - 界面布局
- (void)setupUI {
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(DWScale(25), DNavStatusBarH + DWScale(10), DScreenWidth - DWScale(25)*2, DWScale(20))];
    titleLbl.text = MultilingualTranslation(@"投诉与支持");
    titleLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    titleLbl.font = FONTB(18);
    [self.view addSubview:titleLbl];
    
    _viewCategory = [[LJCategoryTitleView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH + DWScale(10) + DWScale(20) + DWScale(10) , DScreenWidth, DWScale(45))];
    _viewCategory.delegate = self;
    _viewCategory.titles = @[MultilingualTranslation(@"系统投诉"),[NSString stringWithFormat:@"%@/%@",MultilingualTranslation(@"企业号"),MultilingualTranslation(@"IP/域名")]];
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
                weakSelf.viewCategory.titleSelectedColor = COLOR_81D8CF;
            }
                break;
                
            default:
            {
                weakSelf.viewCategory.titleColor = COLOR_66;
                weakSelf.viewCategory.titleSelectedColor = COLOR_81D8CF;
            }
                break;
        }
    };
    
    //指示器
    NJCategoryIndicatorLineView *lineView = [[NJCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = COLOR_81D8CF;
    lineView.componentPosition = JXCategoryComponentPosition_Bottom;
    lineView.verticalMargin = 0;
    _viewCategory.indicators = @[lineView];
    
    _scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH + DWScale(10) + DWScale(20) + DWScale(10) + DWScale(45), DScreenWidth, DScreenHeight - DNavStatusBarH - DWScale(10) - DWScale(20) - DWScale(10) - DWScale(45))];
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
    
    _systemComplainVC = [[ZComplainFromVC alloc] init];
    _systemComplainVC.view.frame = CGRectMake(0, 0, DScreenWidth, _scrollView.height);
    _systemComplainVC.complainVCType = ZComplainTypeSystem;
    _systemComplainVC.complainID = _complainID;
    _systemComplainVC.complainType = _complainType;
    [self addChildViewController:_systemComplainVC];
    [self.scrollView addSubview:_systemComplainVC.view];
    
    _domainComplainVC = [[ZComplainFromVC alloc] init];
    _domainComplainVC.view.frame = CGRectMake(DScreenWidth, 0, DScreenWidth, _scrollView.height);
    _domainComplainVC.complainVCType = ZComplainTypeDomain;
    _domainComplainVC.complainID = _complainID;
    _domainComplainVC.complainType = _complainType;
    [self addChildViewController:_domainComplainVC];
    [self.scrollView addSubview:_domainComplainVC.view];
    
    _currentSelectedIndex = 0;
}

#pragma mark - JXCategoryViewDelegate
//选中某个下标
- (void)categoryView:(NJCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (_currentSelectedIndex == index) {
        //点击的同一个下标
    }else {
        //切换选中下标
        if (_currentSelectedIndex == 0) {
            //清空系统投诉界面内容
            //[_systemComplainVC clearUIContent];
        }else {
            //清空企业号界面内容
            //[_domainComplainVC clearUIContent];
        }
    }
    _currentSelectedIndex = index;
}
@end
