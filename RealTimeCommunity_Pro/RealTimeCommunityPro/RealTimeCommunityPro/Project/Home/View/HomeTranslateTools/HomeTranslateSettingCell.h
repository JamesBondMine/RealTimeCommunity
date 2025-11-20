//
//  HomeTranslateSettingCell.h
//  CIMKit
//
//  Created by cusPro on 2023/12/26.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SettingSwithcClick) (BOOL isOn);

@interface HomeTranslateSettingCell : ZBaseCell

@property (nonatomic, copy)NSString *leftTitleStr;
@property (nonatomic, copy)NSString *rightTitleStr;
@property (nonatomic, assign)BOOL switchIsOn;
@property (nonatomic, copy) SettingSwithcClick switchBlock;

- (void)configCellRoundWithCellIndex:(NSInteger)index totalIndex:(NSInteger)totalIndex;

@end

NS_ASSUME_NONNULL_END
