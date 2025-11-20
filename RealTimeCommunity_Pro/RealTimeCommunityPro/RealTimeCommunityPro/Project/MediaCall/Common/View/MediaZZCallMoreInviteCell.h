//
//  MediaZZCallMoreInviteCell.h
//  CIMKit
//
//  Created by cusPro on 2023/2/6.
//

#import "ZBaseCell.h"
#import <NoaChatSDKCore/LingIMGroupMemberModel.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MediaZZCallMoreInviteCellSelectedType) {
    MediaZZCallMoreInviteCellSelectedTypeDefault = 0,//默认选中
    MediaZZCallMoreInviteCellSelectedTypeNo = 1,     //未选中
    MediaZZCallMoreInviteCellSelectedTypeYes = 2,    //已选中
};

@interface MediaZZCallMoreInviteCell : ZBaseCell
@property (nonatomic, strong) LingIMGroupMemberModel *groupMemberModel;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, assign) MediaZZCallMoreInviteCellSelectedType selectedType;

//cell界面渲染赋值
- (void)configCellWith:(LingIMGroupMemberModel *)groupMemberModel searchString:(NSString *)searchStr selected:(MediaZZCallMoreInviteCellSelectedType)selectedType;
@end

NS_ASSUME_NONNULL_END
