//
//  ZTeamDetailVC.h
//  CIMKit
//
//  Created by cusPro on 2023/7/20.
//

#import "BBBaseViewController.h"
#import "NTMTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZTeamDetailVCDelegate <NSObject>

- (void)updateTeamName:(NSString *)name index:(NSInteger)index;

@end

@interface ZTeamDetailVC : BBBaseViewController

@property (nonatomic, strong) NTMTeamModel *teamModel;
@property (nonatomic, assign) NSInteger listIndex;
@property (nonatomic, weak) id <ZTeamDetailVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
