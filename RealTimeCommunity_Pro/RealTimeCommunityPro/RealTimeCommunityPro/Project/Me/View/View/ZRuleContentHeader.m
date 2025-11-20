//
//  ZRuleContentHeader.m
//  CIMKit
//
//  Created by cusPro on 2024/12/26.
//

#import "ZRuleContentHeader.h"

@interface ZRuleContentHeader()

@property (nonatomic, strong) UILabel *ruleTipLabel;

@end

@implementation ZRuleContentHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.ruleTipLabel = [[UILabel alloc] init];
    self.ruleTipLabel.numberOfLines = 0;
    self.ruleTipLabel.tkThemetextColors = @[COLOR_33, COLORWHITE];
    [self.contentView addSubview:self.ruleTipLabel];
    [self.ruleTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setRuleContentAtt:(NSMutableAttributedString *)ruleContentAtt {
    _ruleContentAtt = ruleContentAtt;

    self.ruleTipLabel.attributedText = _ruleContentAtt;
}

@end
