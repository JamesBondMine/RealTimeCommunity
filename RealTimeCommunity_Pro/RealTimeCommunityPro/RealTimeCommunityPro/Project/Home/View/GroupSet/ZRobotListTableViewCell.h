//
//  ZRobotListTableViewCell.h
//  CIMKit
//
//  Created by Apple on 2023/9/25.
//

#import "ZBaseCell.h"
#import "BBBaseImageView.h"
#import "ZRobotModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZRobotListTableViewCell : ZBaseCell
@property (nonatomic, strong) BBBaseImageView *ivHeader;
- (void)cellConfigWithModel:(ZRobotModel *)model;
@end

NS_ASSUME_NONNULL_END
