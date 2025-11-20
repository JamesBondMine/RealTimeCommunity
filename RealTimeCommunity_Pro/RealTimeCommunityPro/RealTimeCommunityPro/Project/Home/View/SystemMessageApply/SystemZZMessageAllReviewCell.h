//
//  SystemZZMessageAllReviewCell.h
//  CIMKit
//
//  Created by cusPro on 2023/5/10.
//

#import "ZBaseCell.h"
#import "MSSSMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SystemZZMessageAllReviewCellDelegate <NSObject>

@optional

- (void)systemMessageCellClickNickNameAction:(NSString *)userUid;
- (void)refuseSystemMessageAllReviewAction:(NSIndexPath *)indexPath;
- (void)agreeSystemMessageAllReviewAgreeAction:(NSIndexPath *)indexPath;

@end

@interface SystemZZMessageAllReviewCell : ZBaseCell

@property (nonatomic, assign) ZGroupHelperFormType fromType;
@property (nonatomic, strong) MSSSMessageModel *model;
@property (nonatomic, weak) id<SystemZZMessageAllReviewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
