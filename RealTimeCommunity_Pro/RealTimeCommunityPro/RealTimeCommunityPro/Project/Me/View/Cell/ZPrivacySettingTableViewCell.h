//
//  ZPrivacySettingTableViewCell.h
//  CIMKit
//
//  Created by cusPro on 2024/2/16.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZPrivacySettingTableViewCell : ZBaseCell
@property (nonatomic, strong) UIButton *btnSwitch;
- (void)updateCellUIWith:(NSInteger)currentRow totalRow:(NSInteger)totalRow;
@end

NS_ASSUME_NONNULL_END
