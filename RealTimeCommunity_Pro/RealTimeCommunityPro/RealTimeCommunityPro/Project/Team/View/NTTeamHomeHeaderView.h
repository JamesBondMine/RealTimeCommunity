//
//  NTTeamHomeHeaderView.h
//  CIMKit
//
//  Created by cusPro on 2023/9/7.
//

#import <UIKit/UIKit.h>
#import "NTMTeamModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZTeamHomeHeaderViewDelegate <NSObject>

- (void)headerTeamListTitleAction;
- (void)headerTeamItemAction:(NTMTeamModel *)teamModel;
- (void)headerSetDefaultTeamAction:(NTMTeamModel *)teamModel;

@end

@interface NTTeamHomeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSArray *headerTeamList;
@property (nonatomic, weak) id <ZTeamHomeHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
