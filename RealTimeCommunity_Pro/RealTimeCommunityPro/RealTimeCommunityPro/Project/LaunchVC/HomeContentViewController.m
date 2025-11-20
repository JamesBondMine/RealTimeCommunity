//
//  HomeContentViewController.m
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import "HomeContentViewController.h"
#import "AvatarButtonView.h"

@interface HomeContentViewController () <AvatarButtonViewDelegate>

@property (nonatomic, strong) AvatarButtonView *avatarButtonView;
@property (nonatomic, strong) NSMutableArray<UIButton *> *functionButtons;

@end

@implementation HomeContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.functionButtons = [NSMutableArray array];
    
    [self setupAvatarButton];
    [self setupFunctionButtons];
}

- (void)setupAvatarButton {
    CGFloat avatarSize = 40;
    CGFloat topMargin = 50;
    CGFloat rightMargin = 20;
    
    self.avatarButtonView = [[AvatarButtonView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - avatarSize - rightMargin, topMargin, avatarSize, avatarSize)];
    self.avatarButtonView.delegate = self;
    [self.view addSubview:self.avatarButtonView];
}

- (void)setupFunctionButtons {
    NSArray *buttonTitles = @[@"我的订单", @"我的收藏", @"浏览历史", @"设置"];
    NSArray *buttonEmojis = @[@"📦", @"⭐️", @"🕐", @"⚙️"];
    
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat buttonWidth = (screenWidth - 60) / 2; // 左右边距20，中间间距20
    CGFloat buttonHeight = 80;
    CGFloat startY = 120;
    CGFloat horizontalSpacing = 20;
    CGFloat verticalSpacing = 20;
    
    for (NSInteger i = 0; i < buttonTitles.count; i++) {
        NSInteger row = i / 2;
        NSInteger col = i % 2;
        
        CGFloat x = 20 + col * (buttonWidth + horizontalSpacing);
        CGFloat y = startY + row * (buttonHeight + verticalSpacing);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 15;
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0, 2);
        button.layer.shadowOpacity = 0.1;
        button.layer.shadowRadius = 8;
        button.tag = i;
        
        // 创建按钮内容容器
        UIView *contentView = [[UIView alloc] initWithFrame:button.bounds];
        contentView.userInteractionEnabled = NO;
        [button addSubview:contentView];
        
        // Emoji 图标
        UILabel *emojiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, buttonWidth, 30)];
        emojiLabel.text = buttonEmojis[i];
        emojiLabel.font = [UIFont systemFontOfSize:28];
        emojiLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:emojiLabel];
        
        // 标题文字
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, buttonWidth, 22)];
        titleLabel.text = buttonTitles[i];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.3 alpha:1.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLabel];
        
        [button addTarget:self action:@selector(functionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        [self.functionButtons addObject:button];
    }
}

- (void)functionButtonTapped:(UIButton *)sender {
    // 添加点击动画
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            sender.transform = CGAffineTransformIdentity;
        }];
    }];
    
    NSArray *buttonTitles = @[@"我的订单", @"我的收藏", @"浏览历史", @"设置"];
    NSString *title = buttonTitles[sender.tag];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"功能提示"
                                                                   message:[NSString stringWithFormat:@"您点击了：%@", title]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - AvatarButtonViewDelegate

- (void)avatarButtonViewDidTap:(AvatarButtonView *)avatarView {
    if ([self.delegate respondsToSelector:@selector(homeContentViewControllerDidTapAvatar:)]) {
        [self.delegate homeContentViewControllerDidTapAvatar:self];
    }
}

@end

