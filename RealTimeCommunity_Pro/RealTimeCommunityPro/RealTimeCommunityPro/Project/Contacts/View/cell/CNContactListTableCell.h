//
//  CNContactListTableCell.h
//  CIMKit
//
//  Created by cusPro on 2022/9/9.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface CNContactListTableCell : ZBaseCell

@property (nonatomic, strong) LingIMFriendModel *friendModel;
@property (nonatomic, strong) UIView *viewOnline;

@end

NS_ASSUME_NONNULL_END
