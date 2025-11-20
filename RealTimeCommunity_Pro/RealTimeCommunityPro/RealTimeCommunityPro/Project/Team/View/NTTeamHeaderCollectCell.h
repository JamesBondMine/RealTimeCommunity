//
//  NTTeamHeaderCollectCell.h
//  CIMKit
//
//  Created by cusPro on 2023/9/7.
//

#import "BBBaseCollectionCell.h"
#import "NTMTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZTeamHeaderCollectCellDelegate <NSObject>

- (void)selectedTeamForDefaultAction:(NTMTeamModel *)teamMode;

@end

@interface NTTeamHeaderCollectCell : BBBaseCollectionCell

@property (nonatomic, strong) NTMTeamModel *teamModel;
@property (nonatomic, weak) id <ZTeamHeaderCollectCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
