//
//  ZGroupManageContentCell.h
//  CIMKit
//
//  Created by cusPro on 2023/4/25.
//

// 群管理 标题+描述+开关 Cell

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZGroupManageContentCell : ZBaseCell
@property (nonatomic, strong) UIButton *viewContent;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblContent;
@property (nonatomic, strong) UIButton *btnSwitch;
@property (nonatomic, strong) UIView *viewLine;

- (void)updateCellUIWith:(NSInteger)currentRow totalRow:(NSInteger)totalRow;
@end

NS_ASSUME_NONNULL_END
