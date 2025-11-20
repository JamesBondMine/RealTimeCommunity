//
//  ZRaceCheckErrorCell.h
//  CIMKit
//
//  Created by cusPro on 2024/5/11.
//

#import <UIKit/UIKit.h>
#import "ZRaceCheckErrorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZRaceCheckErrorCell : UITableViewCell

@property (nonatomic, assign)NSInteger cellIndex;
@property (nonatomic, strong)ZRaceCheckErrorModel *model;

@end

NS_ASSUME_NONNULL_END
