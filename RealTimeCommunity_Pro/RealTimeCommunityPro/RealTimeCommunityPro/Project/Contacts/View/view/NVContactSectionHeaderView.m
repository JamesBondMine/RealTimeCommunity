//
//  NVContactSectionHeaderView.m
//  CIMKit
//
//  Created by cusPro on 2023/7/3.
//

#import "NVContactSectionHeaderView.h"

@implementation NVContactSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
