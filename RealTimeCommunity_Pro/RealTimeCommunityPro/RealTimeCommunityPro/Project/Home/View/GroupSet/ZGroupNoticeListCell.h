//
//  ZGroupNoticeListCell.h
//  CIMKit
//
//  Created by phl on 2025/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GNoteLocalUserNameModel;
@interface ZGroupNoticeListCell : UITableViewCell

/// 团队信息模型
@property (nonatomic, strong) GNoteLocalUserNameModel *groupModel;

@end

NS_ASSUME_NONNULL_END
