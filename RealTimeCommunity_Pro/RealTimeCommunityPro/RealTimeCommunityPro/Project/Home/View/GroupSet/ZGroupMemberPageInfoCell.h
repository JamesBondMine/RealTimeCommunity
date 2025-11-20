//
//  ZGroupMemberPageInfoCell.h
//  CIMKit
//
//  Created by cusPro on 2022/12/9.
//

#import "ZBaseCell.h"
#import <NoaChatSDKCore/LingIMGroupMemberModel.h>
NS_ASSUME_NONNULL_BEGIN
//背景试图圆角的分布位置
//typedef NS_ENUM(NSUInteger, ZGroupMemberPageInfoCellType) {
//    CellRemarkType = 1,        //备注类型
//    CellDesType = 2,        //描述类型
//    CellNickNameType = 3,  //在本群的昵称
//};

static NSString * CellRemarkType = @"CellRemarkType";
static NSString * CellDesType = @"CellDesType";
static NSString * CellNickNameType = @"CellNickNameType";

@interface ZGroupMemberPageInfoCell : ZBaseCell
- (void)cellConfigWith:(NSString *)cellType model:(LingIMGroupMemberModel *)model;
@end

NS_ASSUME_NONNULL_END
