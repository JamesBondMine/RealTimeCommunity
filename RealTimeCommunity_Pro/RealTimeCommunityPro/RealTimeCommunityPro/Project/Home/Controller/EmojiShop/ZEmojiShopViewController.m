//
//  ZEmojiShopViewController.m
//  CIMKit
//
//  Created by cusPro on 2023/10/25.
//

#import "ZEmojiShopViewController.h"
#import "ZScrollView.h"
#import "JXCategoryView.h"
#import "ZEmojiShopPackageViewController.h"//表情包
#import "ZEmojiShopFeaturedViewController.h"//精选表情

@interface ZEmojiShopViewController () <NJSelectCategoryViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) LJCategoryTitleView *viewCategory;
@property (nonatomic, strong) ZScrollView *scrollView;
@property (nonatomic, strong) ZEmojiShopPackageViewController *emojiPackageVC;
@property (nonatomic, strong) ZEmojiShopFeaturedViewController *emojiFeaturedVC;

@end

@implementation ZEmojiShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleStr = MultilingualTranslation(@"表情商城");
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self setupUI];
}

#pragma mark - 界面布局
- (void)setupUI {
    _viewCategory = [[LJCategoryTitleView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH + DWScale(10), DScreenWidth, DWScale(40))];
    _viewCategory.delegate = self;
    _viewCategory.titles = @[MultilingualTranslation(@"表情包"),MultilingualTranslation(@"精选表情")];
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
                weakSelf.viewCategory.backgroundColor = COLOR_33;
                weakSelf.viewCategory.titleColor = COLOR_66_DARK;
                weakSelf.viewCategory.titleSelectedColor = COLOR_33_DARK;
            }
                break;
                
            default:
            {
                weakSelf.viewCategory.backgroundColor = COLORWHITE;
                weakSelf.viewCategory.titleColor = COLOR_66;
                weakSelf.viewCategory.titleSelectedColor = COLOR_33;
            }
                break;
        }
    };
    //指示器
    NJCategoryIndicatorLineView *lineView = [[NJCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = COLOR_81D8CF;
    lineView.componentPosition = JXCategoryComponentPosition_Bottom;
    lineView.verticalMargin = 5;
    _viewCategory.indicators = @[lineView];
    
    _scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH + DWScale(10) + DWScale(40), DScreenWidth, DScreenHeight - DNavStatusBarH - DWScale(10) - DWScale(40) - DHomeBarH)];
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
    
    _emojiPackageVC = [ZEmojiShopPackageViewController new];
    _emojiPackageVC.view.frame = CGRectMake(0, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_emojiPackageVC];
    [self.scrollView addSubview:_emojiPackageVC.view];
    
    _emojiFeaturedVC = [ZEmojiShopFeaturedViewController new];
    _emojiFeaturedVC.view.frame = CGRectMake(DScreenWidth, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_emojiFeaturedVC];
    [self.scrollView addSubview:_emojiFeaturedVC.view];
}


@end
