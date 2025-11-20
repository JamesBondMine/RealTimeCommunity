//
//  ZSystemSettingCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/13.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SettingSwithcClick) (BOOL isOn);

@interface ZSystemSettingCell : ZBaseCell

@property (nonatomic, copy)NSString *leftTitleStr;
@property (nonatomic, copy)NSString *centerTitleStr;
@property (nonatomic, copy)NSString *rightTitleStr;
@property (nonatomic, assign)BOOL switchIsOn;
@property (nonatomic, copy) SettingSwithcClick switchBlock;

- (void)configCellRoundWithCellIndex:(NSInteger)index totalIndex:(NSInteger)totalIndex;

@end

NS_ASSUME_NONNULL_END
