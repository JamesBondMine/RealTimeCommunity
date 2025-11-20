//
//  AvatarButtonView.m
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import "AvatarButtonView.h"

@interface AvatarButtonView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation AvatarButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButton];
        [self setDefaultValues];
    }
    return self;
}

- (void)setupButton {
    // 创建按钮，填满整个视图
    self.button = [[UIButton alloc] initWithFrame:self.bounds];
    self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // 添加点击事件
    [self.button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.button];
}

- (void)setDefaultValues {
    // 设置默认值
    self.avatarBackgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.5 alpha:1.0];
    self.borderColor = [UIColor whiteColor];
    self.borderWidth = 2;
    self.avatarText = @"👤";
    
    [self updateAppearance];
}

- (void)updateAppearance {
    // 设置圆形样式
    self.button.backgroundColor = self.avatarBackgroundColor;
    self.button.layer.cornerRadius = self.bounds.size.width / 2;
    self.button.layer.masksToBounds = YES;
    self.button.layer.borderWidth = self.borderWidth;
    self.button.layer.borderColor = self.borderColor.CGColor;
    
    // 设置头像图标
    [self.button setTitle:self.avatarText forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:24];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 当视图大小改变时，更新圆角半径
    self.button.layer.cornerRadius = self.bounds.size.width / 2;
}

- (void)buttonTapped:(UIButton *)sender {
    // 通知代理按钮被点击
    if ([self.delegate respondsToSelector:@selector(avatarButtonViewDidTap:)]) {
        [self.delegate avatarButtonViewDidTap:self];
    }
}

#pragma mark - Setters

- (void)setAvatarBackgroundColor:(UIColor *)avatarBackgroundColor {
    _avatarBackgroundColor = avatarBackgroundColor;
    self.button.backgroundColor = avatarBackgroundColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.button.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.button.layer.borderWidth = borderWidth;
}

- (void)setAvatarText:(NSString *)avatarText {
    _avatarText = [avatarText copy];
    [self.button setTitle:avatarText forState:UIControlStateNormal];
}

@end

