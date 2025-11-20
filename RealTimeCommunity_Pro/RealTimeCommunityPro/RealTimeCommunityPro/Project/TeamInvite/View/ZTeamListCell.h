//
//  ZTeamListCell.h
//  CIMKit
//
//  Created by phl on 2025/7/21.
//

#import <UIKit/UIKit.h>
#import "NTMTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTeamListCell : UITableViewCell

@property (nonatomic, strong) NTMTeamModel *teamModel;

/// 点击了复制按钮
@property (nonatomic, strong) RACSubject *clickCopySubject;

@end

NS_ASSUME_NONNULL_END
