//
//  GpInviteAndRemoveFriendCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/9.
//

#import "ZBaseCell.h"
#import <NoaChatSDKCore/LingIMGroupMemberModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface GpInviteAndRemoveFriendCell : ZBaseCell
@property (nonatomic, assign) NSInteger selectedUser;
- (void)cellConfigWith:(LingIMGroupMemberModel *)model search:(NSString *)searchStr;
@end

NS_ASSUME_NONNULL_END
