//
//  ZHistoryChoiceUserCell.h
//  CIMKit
//
//  Created by cusPro on 2024/8/12.
//

#import "ZBaseCell.h"
#import "ZBaseUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHistoryChoiceUserCell : ZBaseCell

@property (nonatomic, assign) BOOL selectedUser;

- (void)cellConfigBaseUserWith:(ZBaseUserModel *)model search:(NSString *)searchStr;

@end

NS_ASSUME_NONNULL_END
