//
//  CNGlobalSearchCell.h
//  CIMKit
//
//  Created by cusPro on 2022/9/14.
//

// 通讯录 搜索 Cell

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNGlobalSearchCell : ZBaseCell
- (void)globalSearchConfigWith:(NSIndexPath *)cellIndex model:(id)model search:(NSString *)searchStr;
@end

NS_ASSUME_NONNULL_END
