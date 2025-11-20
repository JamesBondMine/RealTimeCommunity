//
//  ZChatSetGroupNoteCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/5.
//

// 群设置 - 群公告Cell

#import "ZBaseCell.h"
#import "LingIMGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZChatSetGroupNoteCell : ZBaseCell
@property (nonatomic, strong) LingIMGroup *groupModel;

@property (nonatomic, assign) BOOL isShowLine;
@end

NS_ASSUME_NONNULL_END
