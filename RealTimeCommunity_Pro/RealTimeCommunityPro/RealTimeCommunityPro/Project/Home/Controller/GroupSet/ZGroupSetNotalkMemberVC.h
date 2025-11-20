//
//  ZGroupSetNotalkMemberVC.h
//  CIMKit
//
//  Created by cusPro on 2022/11/15.
//

#import "BBBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZGroupSetNotalkMemberVC : BBBaseViewController
@property (nonatomic,strong)LingIMGroup * groupInfoModel;
@property (nonatomic,strong)NSArray * notalkFriendIDArr;//已经禁言好友ID
@end

NS_ASSUME_NONNULL_END
