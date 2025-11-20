//
//  NVFriendListSectionHeaderView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/9.
//

#import "NVFriendListSectionHeaderView.h"

@interface NVFriendListSectionHeaderView()


@end


@implementation NVFriendListSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.userInteractionEnabled = YES;
    self.contentView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.tkThemetextColors = @[COLOR_99, COLOR_99];
    self.contentLabel.font = FONTN(12);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(16);
        make.trailing.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
    }];
    
}



@end
