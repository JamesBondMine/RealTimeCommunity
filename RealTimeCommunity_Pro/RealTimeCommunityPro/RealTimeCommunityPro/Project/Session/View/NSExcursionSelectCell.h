//
//  NSExcursionSelectCell.h
//  CIMKit
//
//  Created by cusPro on 2024/1/12.
//

#import "ZBaseCell.h"
#import "ZBaseUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSExcursionSelectCell : ZBaseCell
@property (nonatomic, assign) BOOL selectedUser;
- (void)cellConfigBaseUserWith:(ZBaseUserModel *)model search:(NSString *)searchStr;
@end

NS_ASSUME_NONNULL_END
