//
//  CActivityLevelHeaderView.h
//  CIMKit
//
//  Created by cusPro on 2025/2/19.
//

#import <UIKit/UIKit.h>
#import "GHomeActivityInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CActivityLevelHeaderView : UITableViewHeaderFooterView

@property(nonatomic, assign)NSInteger myLevelScroe;
@property(nonatomic, strong)GHomeActivityInfoModel *activityInfoModel;

@end

NS_ASSUME_NONNULL_END
