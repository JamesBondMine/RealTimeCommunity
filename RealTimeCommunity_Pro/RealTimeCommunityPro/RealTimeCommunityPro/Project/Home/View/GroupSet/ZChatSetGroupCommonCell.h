//
//  ZChatSetGroupCommonCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/5.
//

// 群设置 - 通用Cell

#import "ZBaseCell.h"
#import "LingIMGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZChatSetGroupCommonCell : ZBaseCell
@property (nonatomic, strong) UIButton *viewBg;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIImageView *ivArrow;
@property (nonatomic, strong) UIButton *btnAction;
@property (nonatomic, strong) UIButton *btnCenter;
@property (nonatomic, strong) UIView *viewLine;

- (void)cellConfigWithTitle:(NSString *)cellTitle model:(LingIMGroup *)model;
@end

NS_ASSUME_NONNULL_END
