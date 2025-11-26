//
//  FloatingActionButton.m
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import "FloatingActionButton.h"

@interface FloatingActionButton ()

@property (nonatomic, strong) UIButton *mainButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> *subButtons;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) NSMutableArray *actionList; // 功能列表

@end

@implementation FloatingActionButton

+ (instancetype)addToView:(UIView *)parentView atPosition:(NSInteger)position {
    CGFloat buttonSize = 60;
    CGFloat margin = 20;
    CGFloat x, y;
    
    CGFloat width = parentView.bounds.size.width;
    CGFloat height = parentView.bounds.size.height;
    
    switch (position) {
        case 0: // 右下角（默认）
            x = width - buttonSize - margin;
            y = height - buttonSize - 180; // 往上调整，增加底部距离
            break;
        case 1: // 左下角
            x = margin;
            y = height - buttonSize - 180; // 往上调整，增加底部距离
            break;
        case 2: // 右上角
            x = width - buttonSize - margin;
            y = 100;
            break;
        case 3: // 左上角
            x = margin;
            y = 100;
            break;
        default: // 默认右下角
            x = width - buttonSize - margin;
            y = height - buttonSize - 180; // 往上调整，增加底部距离
            break;
    }
    
    FloatingActionButton *floatingButton = [[FloatingActionButton alloc] initWithFrame:CGRectMake(x, y, buttonSize, buttonSize)];
    [parentView addSubview:floatingButton];
    return floatingButton;
}

+ (instancetype)addToView:(UIView *)parentView {
    return [self addToView:parentView atPosition:0];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.isExpanded = NO;
    self.subButtons = [NSMutableArray array];
    
    // 不在初始化时构建功能列表，而是在每次展开时动态构建
    // 这样可以确保使用最新的用户权限数据
    
    [self setupMainButton];
}

- (void)buildActionList {
    // 定义四个功能项
    NSDictionary *addFriendDic = @{
        @"actionTitle" : MultilingualTranslation(@"添加好友"),
        @"actionImage" : @"tianjiahaoyou",
        @"actionType"  : @(ZSessionMoreActionTypeAddFriend),
        @"color"       : [UIColor colorWithRed:1.0 green:0.6 blue:0.4 alpha:1.0]
    };
    NSDictionary *creatGroupDic = @{
        @"actionTitle" : MultilingualTranslation(@"创建群聊"),
        @"actionImage" : @"c_chuangjianqunliao",
        @"actionType"  : @(ZSessionMoreActionTypeCreateGroup),
        @"color"       : [UIColor colorWithRed:0.4 green:0.7 blue:1.0 alpha:1.0]
    };
    NSDictionary *scanQrCodeDic = @{
        @"actionTitle" : MultilingualTranslation(@"扫一扫"),
        @"actionImage" : @"trsaoma",
        @"actionType"  : @(ZSessionMoreActionTypeSacnQRcode),
        @"color"       : [UIColor colorWithRed:0.9 green:0.5 blue:0.9 alpha:1.0]
    };
    NSDictionary *boardHelperDic = @{
        @"actionTitle" : MultilingualTranslation(@"群发助手"),
        @"actionImage" : @"qunfazhushou",
        @"actionType"  : @(ZSessionMoreActionTypeMassMessage),
        @"color"       : [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0]
    };
    
    self.actionList = [NSMutableArray array];
    
    // 根据用户权限动态添加功能项
    if ([UserManager.userRoleAuthInfo.allowAddFriend.configValue isEqualToString:@"true"]) {
        [self.actionList addObject:addFriendDic];
    }
    if ([UserManager.userRoleAuthInfo.createGroup.configValue isEqualToString:@"true"]) {
        [self.actionList addObject:creatGroupDic];
    }
    // 扫一扫默认添加
    [self.actionList addObject:scanQrCodeDic];
    if ([UserManager.userRoleAuthInfo.groupHairAssistant.configValue isEqualToString:@"true"]) {
        [self.actionList addObject:boardHelperDic];
    }
}

- (void)setupMainButton {
    CGFloat buttonSize = 60;
    self.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mainButton.frame = CGRectMake(0, 0, buttonSize, buttonSize);
    self.mainButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.5 alpha:1.0];
    self.mainButton.layer.cornerRadius = buttonSize / 2;
    self.mainButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainButton.layer.shadowOffset = CGSizeMake(0, 4);
    self.mainButton.layer.shadowOpacity = 0.3;
    self.mainButton.layer.shadowRadius = 8;
    
    // 主按钮图标（使用图片）
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((buttonSize - 32) / 2, (buttonSize - 32) / 2, 32, 32)];
    iconImageView.image = ImgNamed(@"addtianjia");
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.userInteractionEnabled = NO;
    iconImageView.tag = 999; // 用于后续旋转动画
    [self.mainButton addSubview:iconImageView];
    
    [self.mainButton addTarget:self action:@selector(mainButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.mainButton addGestureRecognizer:panGesture];
    
    [self addSubview:self.mainButton];
}

- (void)mainButtonTapped:(UIButton *)sender {
    if (self.isExpanded) {
        [self collapseButtons];
    } else {
        [self expandButtons];
    }
}

- (void)expandButtons {
    self.isExpanded = YES;
    
    // 🔧 重要：每次展开时重新构建功能列表，确保使用最新的用户权限数据
    [self buildActionList];
    
    // 旋转主按钮图标
    UIView *iconView = [self.mainButton viewWithTag:999];
    [UIView animateWithDuration:0.3 animations:^{
        iconView.transform = CGAffineTransformMakeRotation(M_PI_4); // 旋转45度
    }];
    
    // 如果没有功能项，直接返回
    if (self.actionList.count == 0) {
        return;
    }
    
    CGFloat mainCenterX = self.mainButton.center.x;
    CGFloat mainCenterY = self.mainButton.center.y;
    CGFloat radius = 120; // 弹出半径，增加一点让图标更分散
    
    // 判断按钮在屏幕的左侧还是右侧
    UIView *parentView = self.superview;
    BOOL isOnLeftSide = NO;
    if (parentView) {
        CGFloat screenCenterX = parentView.bounds.size.width / 2;
        isOnLeftSide = self.center.x < screenCenterX;
    }
    
    // 根据位置设置发散方向
    CGFloat startAngle, angleStep;
    NSInteger buttonCount = self.actionList.count;
    
    if (isOnLeftSide) {
        // 在左侧，从正上方向右发散：从正上方(-90度)到右下(30度)
        startAngle = -M_PI / 2; // -90度（正上方）
        angleStep = buttonCount > 1 ? (M_PI * 2 / 3) / (buttonCount - 1) : 0; // 均匀分布在120度范围内
    } else {
        // 在右侧，从正上方向左发散：从正上方(-90度)到左下(-210度)
        startAngle = -M_PI / 2; // -90度（正上方）
        angleStep = buttonCount > 1 ? -(M_PI * 2 / 3) / (buttonCount - 1) : 0; // 均匀分布在120度范围内，负值表示向左
    }
    
    for (NSInteger i = 0; i < buttonCount; i++) {
        NSDictionary *actionDict = self.actionList[i];
        
        CGFloat angle = startAngle + angleStep * i;
        CGFloat subButtonSize = 50;
        
        UIButton *subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        subButton.frame = CGRectMake(mainCenterX - subButtonSize / 2, mainCenterY - subButtonSize / 2, subButtonSize, subButtonSize);
        subButton.backgroundColor = actionDict[@"color"];
        subButton.layer.cornerRadius = subButtonSize / 2;
        subButton.layer.shadowColor = [UIColor blackColor].CGColor;
        subButton.layer.shadowOffset = CGSizeMake(0, 3);
        subButton.layer.shadowOpacity = 0.25;
        subButton.layer.shadowRadius = 6;
        subButton.tag = i;
        subButton.alpha = 0;
        subButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        // 子按钮图标（使用图片）
        UIImageView *subIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((subButtonSize - 28) / 2, (subButtonSize - 28) / 2, 28, 28)];
        subIconImageView.image = ImgNamed(actionDict[@"actionImage"]);
        subIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        subIconImageView.userInteractionEnabled = NO;
        [subButton addSubview:subIconImageView];
        
        [subButton addTarget:self action:@selector(subButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self insertSubview:subButton belowSubview:self.mainButton];
        [self.subButtons addObject:subButton];
        
        // 计算目标位置
        CGFloat targetX = mainCenterX + cos(angle) * radius;
        CGFloat targetY = mainCenterY + sin(angle) * radius;
        
        // 动画展开
        [UIView animateWithDuration:0.4
                              delay:i * 0.05
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            subButton.alpha = 1.0;
            subButton.transform = CGAffineTransformIdentity;
            subButton.center = CGPointMake(targetX, targetY);
        } completion:nil];
    }
}

- (void)collapseButtons {
    self.isExpanded = NO;
    
    // 旋转主按钮图标
    UIView *iconView = [self.mainButton viewWithTag:999];
    [UIView animateWithDuration:0.3 animations:^{
        iconView.transform = CGAffineTransformIdentity;
    }];
    
    CGFloat mainCenterX = self.mainButton.center.x;
    CGFloat mainCenterY = self.mainButton.center.y;
    
    for (NSInteger i = 0; i < self.subButtons.count; i++) {
        UIButton *subButton = self.subButtons[i];
        
        [UIView animateWithDuration:0.3
                              delay:i * 0.03
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            subButton.alpha = 0;
            subButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
            subButton.center = CGPointMake(mainCenterX, mainCenterY);
        } completion:^(BOOL finished) {
            [subButton removeFromSuperview];
        }];
    }
    
    [self.subButtons removeAllObjects];
}

- (void)subButtonTapped:(UIButton *)sender {
    NSInteger index = sender.tag;
    
    // 先收起所有按钮
    [self collapseButtons];
    
    // 获取对应的 actionType
    if (index < self.actionList.count) {
        NSDictionary *actionDict = self.actionList[index];
        ZSessionMoreActionType actionType = [[actionDict objectForKey:@"actionType"] integerValue];
        
        // 延迟通知代理，等待收起动画完成
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(floatingActionButton:didSelectActionType:)]) {
                [self.delegate floatingActionButton:self didSelectActionType:actionType];
            }
        });
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    UIView *parentView = self.superview;
    if (!parentView) return;
    
    CGPoint translation = [gesture translationInView:parentView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.startPoint = self.center;
        // 如果已展开，先收起
        if (self.isExpanded) {
            [self collapseButtons];
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint newCenter = CGPointMake(self.startPoint.x + translation.x, self.startPoint.y + translation.y);
        
        // 限制在父视图范围内
        CGFloat halfWidth = self.bounds.size.width / 2;
        CGFloat halfHeight = self.bounds.size.height / 2;
        
        newCenter.x = MAX(halfWidth, MIN(parentView.bounds.size.width - halfWidth, newCenter.x));
        newCenter.y = MAX(halfHeight, MIN(parentView.bounds.size.height - halfHeight, newCenter.y));
        
        self.center = newCenter;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        // 可选：自动吸附到边缘
        [self snapToEdge];
    }
}

- (void)snapToEdge {
    UIView *parentView = self.superview;
    if (!parentView) return;
    
    CGFloat screenWidth = parentView.bounds.size.width;
    CGFloat centerX = self.center.x;
    CGFloat targetX;
    
    // 判断靠近哪一边
    if (centerX < screenWidth / 2) {
        targetX = self.bounds.size.width / 2 + 20; // 左边
    } else {
        targetX = screenWidth - self.bounds.size.width / 2 - 20; // 右边
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.center = CGPointMake(targetX, self.center.y);
    } completion:nil];
}

#pragma mark - Touch Handling

// 重写触摸检测，让子按钮即使超出 bounds 也能响应点击
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 如果自己不能接收触摸事件，直接返回 nil
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha < 0.01) {
        return nil;
    }
    
    // 先检查子按钮（从前往后，因为后添加的在上层）
    for (NSInteger i = self.subButtons.count - 1; i >= 0; i--) {
        UIButton *subButton = self.subButtons[i];
        // 将触摸点转换到子按钮的坐标系
        CGPoint convertedPoint = [self convertPoint:point toView:subButton];
        // 检查触摸点是否在子按钮内
        if ([subButton pointInside:convertedPoint withEvent:event]) {
            return subButton;
        }
    }
    
    // 检查主按钮
    CGPoint convertedPoint = [self convertPoint:point toView:self.mainButton];
    if ([self.mainButton pointInside:convertedPoint withEvent:event]) {
        return self.mainButton;
    }
    
    // 如果都不是，返回 nil
    return nil;
}

@end

