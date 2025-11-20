//
//  EmojiStoreFeaturedHeaderView.m
//  CIMKit
//
//  Created by cusPro on 2023/10/25.
//

#import "EmojiStoreFeaturedHeaderView.h"

@interface EmojiStoreFeaturedHeaderView ()

@property (nonatomic, strong) UILabel *titleLbl;
  
@end

@implementation EmojiStoreFeaturedHeaderView

-(id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupUI];
  }
  return self;
}

- (void)setupUI {
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(DWScale(16));
        make.trailing.equalTo(self).offset(DWScale(16));
        make.top.equalTo(self).offset(DWScale(10));
        make.height.mas_equalTo(DWScale(20));
    }];
}

#pragma mark - Lazy
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = MultilingualTranslation(@"精选表情");
        _titleLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        _titleLbl.font = FONTR(14);
    }
    return _titleLbl;
}


@end
