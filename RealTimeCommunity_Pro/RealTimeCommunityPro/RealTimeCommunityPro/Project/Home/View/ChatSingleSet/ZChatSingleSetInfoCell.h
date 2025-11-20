//
//  ZChatSingleSetInfoCell.h
//  CIMKit
//
//  Created by cusPro on 2022/12/29.
//

#import "ZBaseCell.h"
#import "ZUserModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapSingleSetInfoViewBlock)(void);

@interface ZChatSingleSetInfoCell : ZBaseCell
- (void)cellConfigWithModel:(LingIMFriendModel *)model;

@property (nonatomic, copy)TapSingleSetInfoViewBlock tapSingleInfoAddBlock;

@property (nonatomic, copy)TapSingleSetInfoViewBlock tapHeaderBlock;
@end

NS_ASSUME_NONNULL_END
