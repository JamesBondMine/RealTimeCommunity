//
//  ZTranslateManagerCell.h
//  CIMKit
//
//  Created by cusPro on 2023/11/2.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTranslateManagerCell : ZBaseCell

@property (nonatomic, copy)NSString *contentStr;

- (void)configCellRoundWithCellIndex:(NSInteger)index totalIndex:(NSInteger)totalIndex;

@end

NS_ASSUME_NONNULL_END
