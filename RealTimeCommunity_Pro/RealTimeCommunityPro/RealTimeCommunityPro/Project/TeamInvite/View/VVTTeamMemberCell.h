//
//  VVTTeamMemberCell.h
//  CIMKit
//
//  Created by cusPro on 2023/7/20.
//

#import "ZBaseCell.h"
#import "IVTTeamMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VVTTeamMemberCell : ZBaseCell
@property (nonatomic, strong) IVTTeamMemberModel *memberModel;
@property (nonatomic, copy) void(^tickoutCallback)(void);
@end

NS_ASSUME_NONNULL_END
