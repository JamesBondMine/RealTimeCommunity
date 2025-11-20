//
//  ZSystemMessagePendReviewCell.h
//  CIMKit
//
//  Created by cusPro on 2023/5/10.
//

#import "ZBaseCell.h"
#import "MSSSMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZSystemMessagePendReviewCellDelegate <NSObject>

@optional

- (void)systemMessageCellClickNickNameAction:(NSString *)userUid;

@end

@interface ZSystemMessagePendReviewCell : ZBaseCell

@property (nonatomic, assign) ZGroupHelperFormType fromType;
@property (nonatomic, strong) MSSSMessageModel *model;
@property (nonatomic, weak) id<ZSystemMessagePendReviewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
