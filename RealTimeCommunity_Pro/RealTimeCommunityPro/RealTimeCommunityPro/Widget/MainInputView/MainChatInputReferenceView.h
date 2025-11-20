//
//  MainChatInputReferenceView.h
//  CIMKit
//
//  Created by cusPro on 2022/9/27.
//

// 聊天输入内容 引用 View 62固定高度

#import <UIKit/UIKit.h>
#import "ZMessageModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MainChatInputReferenceViewDelegate <NSObject>
- (void)referenceViewClose;
@end

@interface MainChatInputReferenceView : UIView

@property (nonatomic, strong)ZMessageModel *referenceMsgModel;
@property (nonatomic, weak) id <MainChatInputReferenceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
