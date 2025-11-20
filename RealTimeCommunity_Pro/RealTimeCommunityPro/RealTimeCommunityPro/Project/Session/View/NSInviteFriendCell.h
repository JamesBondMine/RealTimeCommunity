//
//  NSInviteFriendCell.h
//  CIMKit
//
//  Created by cusPro on 2022/9/23.
//

#import "ZBaseCell.h"
#import "ZBaseUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSInviteFriendCell : ZBaseCell

@property (nonatomic, assign) BOOL selectedUser;

- (void)cellConfigBaseUserWith:(ZBaseUserModel *)model search:(NSString *)searchStr;

@end

NS_ASSUME_NONNULL_END
