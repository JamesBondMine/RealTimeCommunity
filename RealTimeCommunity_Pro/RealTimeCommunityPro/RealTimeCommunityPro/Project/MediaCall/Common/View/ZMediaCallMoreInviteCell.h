//
//  ZMediaCallMoreInviteCell.h
//  CIMKit
//
//  Created by cusPro on 2023/2/6.
//

#import "ZBaseCell.h"
#import <NoaChatSDKCore/LingIMGroupMemberModel.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ZMediaCallMoreInviteCellSelectedType) {
    ZMediaCallMoreInviteCellSelectedTypeDefault = 0,//默认选中
    ZMediaCallMoreInviteCellSelectedTypeNo = 1,     //未选中
    ZMediaCallMoreInviteCellSelectedTypeYes = 2,    //已选中
};

@interface ZMediaCallMoreInviteCell : ZBaseCell
@property (nonatomic, strong) LingIMGroupMemberModel *groupMemberModel;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, assign) ZMediaCallMoreInviteCellSelectedType selectedType;

//cell界面渲染赋值
- (void)configCellWith:(LingIMGroupMemberModel *)groupMemberModel searchString:(NSString *)searchStr selected:(ZMediaCallMoreInviteCellSelectedType)selectedType;
@end

NS_ASSUME_NONNULL_END
