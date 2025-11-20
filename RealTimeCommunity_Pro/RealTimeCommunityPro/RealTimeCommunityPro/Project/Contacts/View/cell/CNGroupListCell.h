//
//  CNGroupListCell.h
//  CIMKit
//
//  Created by cusPro on 2022/9/14.
//

// 群聊列表 Cell

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNGroupListCell : ZBaseCell
@property (nonatomic, strong) LingIMGroupModel *groupModel;
@end

NS_ASSUME_NONNULL_END
