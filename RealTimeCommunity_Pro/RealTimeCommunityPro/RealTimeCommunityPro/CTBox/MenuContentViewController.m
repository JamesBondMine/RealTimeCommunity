//
//  MenuContentViewController.m
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import "MenuContentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

// 自定义装饰视图 - 用于显示 section 背景
@interface SectionBackgroundDecorationView : UICollectionReusableView
@end

@implementation SectionBackgroundDecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = NO; // 不裁剪，让阴影可以显示
        
        // 添加阴影效果
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowOpacity = 0.12;
        self.layer.shadowRadius = 10;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8].CGPath;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 更新阴影路径
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8].CGPath;
}

@end

// 自定义布局类 - 支持装饰视图
@interface CustomFlowLayout : UICollectionViewFlowLayout
@end

@implementation CustomFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        // 注册装饰视图
        [self registerClass:[SectionBackgroundDecorationView class] forDecorationViewOfKind:@"SectionBackground"];
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    // 为每个 section 添加背景装饰视图
    NSMutableSet *sections = [NSMutableSet set];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if (attr.representedElementCategory == UICollectionElementCategoryCell) {
            [sections addObject:@(attr.indexPath.section)];
        }
    }
    for (NSNumber *section in sections) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section.integerValue];
        UICollectionViewLayoutAttributes *decorationAttributes = [self layoutAttributesForDecorationViewOfKind:@"SectionBackground" atIndexPath:indexPath];
        if (decorationAttributes) {
            [attributes addObject:decorationAttributes];
        }
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    
    if (itemCount == 0) {
        return nil;
    }
    
    // 获取该 section 第一个和最后一个 item 的布局属性
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
    
    UICollectionViewLayoutAttributes *firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstIndexPath];
    UICollectionViewLayoutAttributes *lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastIndexPath];
    
    if (!firstItemAttributes || !lastItemAttributes) {
        return nil;
    }
    
    // 计算装饰视图的frame，包含所有items
    CGFloat left = 16; // 距离屏幕左边缘16像素
    CGFloat right = self.collectionView.bounds.size.width - 16; // 距离屏幕右边缘16像素
    CGFloat top = CGRectGetMinY(firstItemAttributes.frame) - 12; // 上边距12像素
    CGFloat bottom = CGRectGetMaxY(lastItemAttributes.frame) + 12; // 下边距12像素
    
    decorationAttributes.frame = CGRectMake(left, top, right - left, bottom - top);
    decorationAttributes.zIndex = -1; // 确保在 cell 下方
    
    return decorationAttributes;
}

@end

@interface MenuContentViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *qrCodeButton;
@property (nonatomic, strong) UIButton *checkInButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArr; // 分组数据

// 用户信息相关
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *copysButton;
@property (nonatomic, copy) NSString *userAccount; // 存储用户账号用于复制

@end

@implementation MenuContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupData];
    [self setupCollectionView];
    [self setupHeaderView];
    [self setupNavigationBar];
    
    // 监听用户信息更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:@"MineUserInfoUpdate" object:nil];
    // 监听用户权限变化，重新加载菜单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupData) name:@"UserRoleAuthorityShowTeamChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupData) name:@"UserRoleAuthorityTranslateFlagDidChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 每次显示时更新用户信息
    [self updateUserInfo];
}

#pragma mark - 设置数据
- (void)setupData {
    if (!self.dataArr) {
        self.dataArr = [NSMutableArray array];
    }
    [self.dataArr removeAllObjects];
    
    NSDictionary *teamManagerDic = @{@"imageName":@"mine_teamManager", @"titleName" : MultilingualTranslation(@"团队管理")};
    NSDictionary *shareInviteDic = @{@"imageName":@"mine_shareInvite", @"titleName" : MultilingualTranslation(@"分享邀请")};
    NSDictionary *myCollectionDic = @{@"imageName":@"mine_collection", @"titleName" : MultilingualTranslation(@"我的收藏")};
    NSDictionary *friendBlackDic = @{@"imageName":@"mine_black", @"titleName" : MultilingualTranslation(@"黑名单")};
    NSDictionary *characterDic = @{@"imageName":@"mine_character", @"titleName" : MultilingualTranslation(@"翻译管理")};
    NSDictionary *appLanguageDic = @{@"imageName":@"mine_language", @"titleName" : MultilingualTranslation(@"语言")};
    NSDictionary *privacySettingDic = @{@"imageName":@"mine_privacy_setting", @"titleName" : MultilingualTranslation(@"隐私设置")};
    NSDictionary *safeSettingDic = @{@"imageName":@"mine_safe", @"titleName" : MultilingualTranslation(@"安全设置")};
    NSDictionary *complainDic = @{@"imageName":@"mine_complain", @"titleName" : MultilingualTranslation(@"投诉与支持")};
    NSDictionary *networkDetectionDic = @{@"imageName":@"mine_networkDetect", @"titleName" : MultilingualTranslation(@"网络检测")};
    NSDictionary *aboutUsDic = @{@"imageName":@"mine_about", @"titleName" : MultilingualTranslation(@"关于我们")};
    NSDictionary *systemSettingDic = @{@"imageName":@"mine_set", @"titleName" : MultilingualTranslation(@"系统设置")};
    
    //是否显示"团队管理"和"分享邀请"
    if ([UserManager.userRoleAuthInfo.showTeam.configValue isEqualToString:@"true"]) {
        NSArray *sectionOneArray = @[teamManagerDic];
        NSArray *sectionTwoArray = @[myCollectionDic, friendBlackDic];
        
        [self.dataArr addObject:sectionOneArray];
        [self.dataArr addObject:sectionTwoArray];
    } else {
        NSArray *sectionOneArray = @[myCollectionDic, friendBlackDic];
        [self.dataArr addObject:sectionOneArray];
    }
    
    BOOL translateEnabled = [UserManager isTranslateEnabled];
    NSArray *sectionThreeArray = translateEnabled ? @[characterDic] : @[];
    
    NSArray *sectionFourArray = @[
        appLanguageDic,
        privacySettingDic,
        safeSettingDic,
        complainDic,
        networkDetectionDic
    ];
    NSArray *sectionFiveArray = @[
        aboutUsDic,
        systemSettingDic
    ];
    if (sectionThreeArray.count > 0) {
        [self.dataArr addObject:sectionThreeArray];
    }
    [self.dataArr addObject:sectionFourArray];
    [self.dataArr addObject:sectionFiveArray];
    
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}

- (void)setupNavigationBar {
    CGFloat navHeight = 44;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat totalHeight = statusBarHeight + navHeight;
    
    self.navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, totalHeight)];
    self.navigationBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    [self.view addSubview:self.navigationBar];
    // 将导航栏移到最前面
    [self.view bringSubviewToFront:self.navigationBar];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, statusBarHeight, self.view.bounds.size.width, navHeight)];
    self.titleLabel.text = @"菜单";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [[UIColor colorWithRed:0.2 green:0.5 blue:0.3 alpha:1.0] colorWithAlphaComponent:0.0];
    // [self.navigationBar addSubview:self.titleLabel];
    
    // 二维码按钮
    CGFloat buttonSize = 30;
    CGFloat leftMargin = 15;
    CGFloat buttonY = statusBarHeight + (navHeight - buttonSize) / 2;
    
    self.qrCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, buttonY, buttonSize, buttonSize)];
    [self.qrCodeButton setImage:ImgNamed(@"saoma") forState:UIControlStateNormal];
    self.qrCodeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.qrCodeButton addTarget:self action:@selector(qrCodeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:self.qrCodeButton];
    
    // 签到按钮
    self.checkInButton = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin + buttonSize + 20, buttonY, buttonSize, buttonSize)];
    [self.checkInButton setImage:ImgNamed(@"qiandao") forState:UIControlStateNormal];
    self.checkInButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.checkInButton addTarget:self action:@selector(checkInButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:self.checkInButton];
}

- (void)setupCollectionView {
    // 使用自定义布局，支持装饰视图
    CustomFlowLayout *layout = [[CustomFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10; // 行间距
    layout.minimumInteritemSpacing = 10; // 列间距
    layout.sectionInset = UIEdgeInsetsMake(12, 26, 12, 26); // 卡片上下边距各12像素（加上section header的20像素，实际间距为20像素）
    
    // collectionView 占满整个视图
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    // 设置顶部内边距，为导航栏留出空间
    CGFloat navHeight = 44;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat topInset = statusBarHeight + navHeight;
    self.collectionView.contentInset = UIEdgeInsetsMake(topInset+ 80, 0, 80, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    
    // 注册 cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MenuCell"];
    // 注册 section header（用于section间距）
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeaderView"];
    // 注册用户卡片 header（用于第一个section的header）
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UserCardHeaderView"];
    
    [self.view addSubview:self.collectionView];
}

- (void)setupHeaderView {
    // 背景图和用户卡片现在都在 collectionView 的 header 中
    // 这个方法保留以便将来可能需要添加其他内容
}

- (UICollectionReusableView *)createUserCardHeaderForCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UserCardHeaderView" forIndexPath:indexPath];
    
    // 清除之前的子视图
    for (UIView *subview in headerView.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat screenWidth = self.view.bounds.size.width;
    
    // 用户卡片（去掉背景图）
    CGFloat cardWidth = screenWidth - 40;
    CGFloat cardHeight = 100;
    CGFloat cardY = 20; // 距离顶部20像素
    
    // 为了让圆角和阴影同时生效，需要外层容器
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(20, cardY, cardWidth, cardHeight)];
    shadowView.backgroundColor = [UIColor clearColor];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 2);
    shadowView.layer.shadowOpacity = 0.1;
    shadowView.layer.shadowRadius = 8;
    shadowView.layer.masksToBounds = NO;
    [headerView addSubview:shadowView];
    
    // 创建圆角卡片
    UIView *cardView = [[UIView alloc] initWithFrame:shadowView.bounds];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 8;
    cardView.layer.masksToBounds = YES;
    [shadowView addSubview:cardView];
    
    // 添加头像（左侧）- 使用 UIImageView
    CGFloat largeAvatarSize = 70;
    CGFloat avatarMargin = 15;
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(avatarMargin, (cardHeight - largeAvatarSize) / 2, largeAvatarSize, largeAvatarSize)];
    self.avatarImageView.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.5 alpha:1.0];
    self.avatarImageView.layer.cornerRadius = largeAvatarSize / 2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderWidth = 3;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.userInteractionEnabled = YES; // 开启交互
    [cardView addSubview:self.avatarImageView];
    
    // 为头像添加点击手势
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped)];
    [self.avatarImageView addGestureRecognizer:avatarTap];
    
    // 添加用户名和其他信息（右侧）
    CGFloat textStartX = avatarMargin + largeAvatarSize + 15;
    CGFloat textWidth = cardWidth - textStartX - 15;
    
    // 用户名
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(textStartX, 25, textWidth, 28)];
    self.usernameLabel.text = @"用户名称";
    self.usernameLabel.textColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.3 alpha:1.0];
    self.usernameLabel.font = [UIFont boldSystemFontOfSize:22];
    self.usernameLabel.textAlignment = NSTextAlignmentLeft;
    [cardView addSubview:self.usernameLabel];
    
    // 个性签名或副标题
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(textStartX, 55, textWidth - 30, 20)];
    self.subtitleLabel.text = @"这个人很懒，什么都没写";
    self.subtitleLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    self.subtitleLabel.font = [UIFont systemFontOfSize:14];
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [cardView addSubview:self.subtitleLabel];
    
    // 复制按钮 - 紧跟在账号文字后面，只显示图标
    self.copysButton = [[UIButton alloc] initWithFrame:CGRectMake(textStartX, 55, 18, 18)];
    [self.copysButton setImage:ImgNamed(@"line_copy") forState:UIControlStateNormal];
    self.copysButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.copysButton.hidden = YES; // 初始隐藏，只有显示账号时才显示
    [self.copysButton addTarget:self action:@selector(copysButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:self.copysButton];
    
    // 立即更新用户信息
    [self updateUserInfo];
    
    return headerView;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *sectionArray = [self.dataArr objectAtIndex:section];
    return sectionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuCell" forIndexPath:indexPath];
    
    // 清除之前的子视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    // 获取数据
    NSArray *sectionArray = [self.dataArr objectAtIndex:indexPath.section];
    NSDictionary *itemDict = [sectionArray objectAtIndex:indexPath.item];
    NSString *imageName = itemDict[@"imageName"];
    NSString *titleName = itemDict[@"titleName"];
    
    // 设置背景 - 更柔和的颜色，让白色卡片背景更突出
    // cell.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.97 blue:0.92 alpha:1.0];
    // cell.contentView.layer.cornerRadius = 12;
    // cell.contentView.layer.masksToBounds = YES;
    // cell.contentView.layer.borderWidth = 1.0;
    // cell.contentView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.92 blue:0.85 alpha:1.0].CGColor;
    
    // 添加图标
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, cell.bounds.size.width, 30)];
    iconImageView.image = ImgNamed(imageName);
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.tag = 200;
    [cell.contentView addSubview:iconImageView];
    
    // 添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, cell.bounds.size.width - 10, 30)];
    
    titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.3 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.tag = 201;
    [cell.contentView addSubview:titleLabel];
    
//    titleLabel.text = titleName;
    titleLabel.attributedText = [self createStyledLevelText:titleName];
    
    
    return cell;
}

#pragma mark - Helper Methods
/**
 * 创建样式化的等级文本
 * 使用自定义字体、描边效果和渐变色
 */
- (NSAttributedString *)createStyledLevelText:(NSString *)levelText {
    if (!levelText || levelText.length == 0) {
        return nil;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:levelText];
    NSRange fullRange = NSMakeRange(0, levelText.length);
    
    // 1. 设置自定义字体（RoDINPlus-Bold），如果字体不存在则使用系统粗体
    UIFont *customFont = [UIFont fontWithName:@"AppleMyungjo" size:DWScale(14)];
    if (!customFont) {
        customFont = [UIFont boldSystemFontOfSize:DWScale(14)];
    }
    [attributedString addAttribute:NSFontAttributeName value:customFont range:fullRange];
    
    // 2. 设置填充颜色（主色调）
//    [attributedString addAttribute:NSForegroundColorAttributeName
//                             value:COLOR_81D8CF
//                             range:fullRange];
    
    // 3. 设置描边效果（负值表示同时显示描边和填充）
    [attributedString addAttribute:NSStrokeColorAttributeName
                             value:COLORWHITE
                             range:fullRange];
    [attributedString addAttribute:NSStrokeWidthAttributeName
                             value:@(-2.5)
                             range:fullRange];
    
    // 4. 添加阴影效果，增强立体感
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.15];
    shadow.shadowOffset = CGSizeMake(0, 1);
    shadow.shadowBlurRadius = 2;
    [attributedString addAttribute:NSShadowAttributeName
                             value:shadow
                             range:fullRange];
    
    return attributedString;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            // 第一个 section 的 header 显示用户卡片
            return [self createUserCardHeaderForCollectionView:collectionView atIndexPath:indexPath];
        } else {
            // 其他 section 的 header 用于间距
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionHeaderView" forIndexPath:indexPath];
            headerView.backgroundColor = [UIColor clearColor];
            return headerView;
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 一行4个，计算每个item的宽度
    CGFloat screenWidth = self.view.bounds.size.width;
    CustomFlowLayout *flowLayout = (CustomFlowLayout *)collectionViewLayout;
    CGFloat leftPadding = flowLayout.sectionInset.left;
    CGFloat rightPadding = flowLayout.sectionInset.right;
    CGFloat spacing = flowLayout.minimumInteritemSpacing; // item间距
    CGFloat itemWidth = (screenWidth - leftPadding - rightPadding - 3 * spacing) / 4.0;
    CGFloat itemHeight = 85; // item高度
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        // 第一个 section 的 header 包含用户卡片
        // cardY(20) + 卡片高度(100) + 底部间距(20) = 140
        return CGSizeMake(collectionView.bounds.size.width, 140);
    }
    // 其他 section 间距：装饰视图底部(12) + header(8) + 装饰视图顶部(12) - sectionInset.top(12) = 20像素
    return CGSizeMake(collectionView.bounds.size.width, 8);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取数据
    NSArray *sectionArray = [self.dataArr objectAtIndex:indexPath.section];
    NSDictionary *itemDict = [sectionArray objectAtIndex:indexPath.item];
    NSString *titleName = itemDict[@"titleName"];
    
    NSLog(@"菜单项被点击: %@", titleName);
    
    // 将标题转换为枚举类型
    MenuActionType actionType = [self actionTypeForTitle:titleName];
    
    // 通过 delegate 传递点击事件
    if ([self.delegate respondsToSelector:@selector(menuContentViewController:didSelectAction:)]) {
        [self.delegate menuContentViewController:self didSelectAction:actionType];
    }
}

#pragma mark - 辅助方法

// 将标题转换为枚举类型
- (MenuActionType)actionTypeForTitle:(NSString *)titleName {
    if ([titleName isEqualToString:MultilingualTranslation(@"团队管理")]) {
        return MenuActionTypeTeamManagement;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"分享邀请")]) {
        return MenuActionTypeShareInvite;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"我的收藏")]) {
        return MenuActionTypeMyCollection;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"黑名单")]) {
        return MenuActionTypeBlacklist;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"翻译管理")]) {
        return MenuActionTypeTranslate;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"语言")]) {
        return MenuActionTypeLanguage;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"隐私设置")]) {
        return MenuActionTypePrivacySetting;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"安全设置")]) {
        return MenuActionTypeSafeSetting;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"投诉与支持")]) {
        return MenuActionTypeComplain;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"关于我们")]) {
        return MenuActionTypeAboutUs;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"系统设置")]) {
        return MenuActionTypeSystemSetting;
    }
    else if ([titleName isEqualToString:MultilingualTranslation(@"网络检测")]) {
        return MenuActionTypeNetworkDetection;
    }
    
    // 默认返回一个值（不应该到达这里）
    return MenuActionTypeAboutUs;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y + self.collectionView.contentInset.top;
    CGFloat maxOffset = 100.0;
    
    CGFloat alpha = MIN(1.0, MAX(0.0, offsetY / maxOffset));
    
    self.navigationBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    self.titleLabel.textColor = [[UIColor colorWithRed:0.2 green:0.5 blue:0.3 alpha:1.0] colorWithAlphaComponent:alpha];
    
    // 根据透明度切换图标图片：导航栏出现后使用灰色图片
    if (alpha > 0.5) {
        // 导航栏已显示，使用灰色图标
        [self.qrCodeButton setImage:ImgNamed(@"saomagrey") forState:UIControlStateNormal];
        [self.checkInButton setImage:ImgNamed(@"qiandaogrey") forState:UIControlStateNormal];
    } else {
        // 导航栏未显示或半透明，使用彩色图标
        [self.qrCodeButton setImage:ImgNamed(@"saoma") forState:UIControlStateNormal];
        [self.checkInButton setImage:ImgNamed(@"qiandao") forState:UIControlStateNormal];
    }
}

#pragma mark - 更新用户信息

- (void)updateUserInfo {
    // 获取当前用户信息
    ZUserModel *userInfo = UserManager.userInfo;
    
    if (userInfo) {
        // 更新头像
        if (self.avatarImageView) {
            [self.avatarImageView sd_setImageWithURL:[userInfo.avatar getImageFullUrl] 
                                    placeholderImage:DefaultAvatar 
                                             options:SDWebImageAllowInvalidSSLCertificates];
        }
        
        // 更新用户名
        if (self.usernameLabel) {
            self.usernameLabel.text = userInfo.nickname ?: @"未设置昵称";
        }
        
        // 更新副标题（可以显示账号或个性签名）
        if (self.subtitleLabel) {
            if (![NSString isNil:userInfo.descRemark]) {
                self.subtitleLabel.text = userInfo.descRemark;
                self.copysButton.hidden = YES; // 显示个性签名时隐藏复制按钮
                self.userAccount = nil;
            } else if (![NSString isNil:userInfo.userName]) {
                NSString *accountText = [NSString stringWithFormat:@"账号: %@", userInfo.userName];
                self.subtitleLabel.text = accountText;
                self.copysButton.hidden = NO; // 显示账号时显示复制按钮
                self.userAccount = userInfo.userName; // 保存账号用于复制
                
                // 计算文字宽度，让复制按钮紧跟在文字后面
                CGSize textSize = [accountText sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
                CGRect buttonFrame = self.copysButton.frame;
                buttonFrame.origin.x = CGRectGetMinX(self.subtitleLabel.frame) + textSize.width + 5; // 文字后面留5像素间距
                buttonFrame.origin.y = CGRectGetMinY(self.subtitleLabel.frame) + 1; // 垂直居中对齐
                self.copysButton.frame = buttonFrame;
            } else {
                self.subtitleLabel.text = @"这个人很懒，什么都没写";
                self.copysButton.hidden = YES;
                self.userAccount = nil;
            }
        }
    }
}

#pragma mark - Button Actions

// 头像点击事件
- (void)avatarTapped {
    NSLog(@"头像被点击");
    // 通过 delegate 传递点击事件
    if ([self.delegate respondsToSelector:@selector(menuContentViewController:didSelectAction:)]) {
        [self.delegate menuContentViewController:self didSelectAction:MenuActionTypeUserEdit];
    }
}

- (void)copysButtonTapped:(UIButton *)sender {
    NSLog(@"复制按钮被点击");
    
    if (self.userAccount && self.userAccount.length > 0) {
        // 复制账号到剪切板
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.userAccount;
        
        // 显示提示
        [HUD showMessage:MultilingualTranslation(@"已复制到剪切板")];
        
        // 按钮点击反馈动画
        [UIView animateWithDuration:0.1 animations:^{
            sender.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                sender.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)qrCodeButtonTapped:(UIButton *)sender {
    NSLog(@"二维码按钮被点击");
    
    // 通过 delegate 传递点击事件
    if ([self.delegate respondsToSelector:@selector(menuContentViewController:didSelectAction:)]) {
        [self.delegate menuContentViewController:self didSelectAction:MenuActionTypeQRCode];
    }
}

- (void)checkInButtonTapped:(UIButton *)sender {
    NSLog(@"签到按钮被点击");
    
    // 通过 delegate 传递点击事件
    if ([self.delegate respondsToSelector:@selector(menuContentViewController:didSelectAction:)]) {
        [self.delegate menuContentViewController:self didSelectAction:MenuActionTypeCheckIn];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

