//
//  ZLanguageSettingCell.h
//  CIMKit
//
//  Created by cusPro on 2022/12/28.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLanguageSettingCell : ZBaseCell

@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lbBelowlTitle;
@property (nonatomic, strong) UIImageView *ivSelected;

- (void)configCellRoundWithCellIndex:(NSInteger)index totalIndex:(NSInteger)totalIndex;

@end

NS_ASSUME_NONNULL_END
