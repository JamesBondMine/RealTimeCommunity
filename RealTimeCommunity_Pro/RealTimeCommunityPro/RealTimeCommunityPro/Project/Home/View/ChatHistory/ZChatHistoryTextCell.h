//
//  ZChatHistoryTextCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/14.
//

// 聊天历史 文本Cell

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZChatHistoryTextCell : ZBaseCell
- (void)configCellWith:(LingIMChatMessageModel *)chatMessageModel searchContent:(NSString *)searchStr;
@end

NS_ASSUME_NONNULL_END
