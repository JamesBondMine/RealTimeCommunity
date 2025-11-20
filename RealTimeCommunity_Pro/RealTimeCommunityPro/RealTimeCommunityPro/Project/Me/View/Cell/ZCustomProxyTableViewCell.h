//
//  ZCustomProxyTableViewCell.h
//  CIMKit
//
//  Created by 小梦雯 on 2025/4/16.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ProxyCellState) {
    ProxyCellStateUnselected,
    ProxyCellStateSelected
};

@interface ZCustomProxyTableViewCell : ZBaseCell
@property (nonatomic, strong) UIImageView *checkmarkIcon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowIcon;
@property (nonatomic, strong) UIView *line;

- (void)configureWithTitle:(NSString *)title
                isSelected:(BOOL)isSelected
                 showArrow:(BOOL)showArrow
                  showLine:(BOOL)showLine;
@end

NS_ASSUME_NONNULL_END
