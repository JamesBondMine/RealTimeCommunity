//
//  ZMessageFileCell.h
//  CIMKit
//
//  Created by cusPro on 2023/1/5.
//

#import "ZMessageContentBaseCell.h"
typedef void(^FailureBlock)(LingIMChatMessageModel * _Nullable chatMsgModel);
NS_ASSUME_NONNULL_BEGIN

@interface ZMessageFileCell : ZMessageContentBaseCell
//点击群组信息视图回调Block
@property (nonatomic, copy) FailureBlock failureBlock;
@end

NS_ASSUME_NONNULL_END
