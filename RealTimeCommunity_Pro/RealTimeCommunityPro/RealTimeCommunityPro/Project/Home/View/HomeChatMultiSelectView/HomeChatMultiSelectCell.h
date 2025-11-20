//
//  HomeChatMultiSelectCell.h
//  CIMKit
//
//  Created by cusPro on 2023/4/12.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeChatMultiSelectCell : ZBaseCell

- (void)configModelWith:(id)model indexPath:(NSIndexPath *)cellIndex searchStr:(NSString * _Nullable)searchStr;

@end

NS_ASSUME_NONNULL_END
