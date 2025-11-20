//
//  ZTeamManagerCell.h
//  CIMKit
//
//  Created by cusPro on 2023/7/20.
//

#import "ZBaseCell.h"
#import "NTMTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZTeamManagerType) {
    ZTeamManagerTypeNone = 0,      //无状态
    ZTeamManagerTypeEdit,          //编辑状态
};

@protocol ZTeamManagerCellDelegate <NSObject>

- (void)teamManagerOperator:(NSIndexPath *)cellIndex;

@end

@interface ZTeamManagerCell : ZBaseCell
@property (nonatomic, weak) id <ZTeamManagerCellDelegate> delegate;

- (void)configCell:(ZTeamManagerType)managerType model:(NTMTeamModel * _Nullable)model;
@end

NS_ASSUME_NONNULL_END
