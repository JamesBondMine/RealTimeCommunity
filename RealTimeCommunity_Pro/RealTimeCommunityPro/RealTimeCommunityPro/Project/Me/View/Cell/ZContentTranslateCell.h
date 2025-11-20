//
//  ZContentTranslateCell.h
//  CIMKit
//
//  Created by cusPro on 2023/9/14.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SettingSwithcClick) (BOOL isOn);

@interface ZContentTranslateCell : ZBaseCell

@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, assign) BOOL switchIsOn;
@property (nonatomic, copy) SettingSwithcClick switchBlock;

/// cell右边视图展示
/// - Parameter cellIndexPath: 当前下标
- (void)configCellRightViewWith:(NSIndexPath *)cellIndexPath;

@end

NS_ASSUME_NONNULL_END
