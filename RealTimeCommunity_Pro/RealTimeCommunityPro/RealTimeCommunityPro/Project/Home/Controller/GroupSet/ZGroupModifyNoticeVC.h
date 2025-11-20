//
//  ZGroupModifyNoticeVC.h
//  CIMKit
//
//  Created by cusPro on 2022/11/11.
//

#import "BBBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^SendGroupNoticeSuccessBlock)(void);
@interface ZGroupModifyNoticeVC : BBBaseViewController

@property (nonatomic,strong)LingIMGroup * groupInfoModel;

@property (nonatomic, copy) SendGroupNoticeSuccessBlock groupNoticeSuccessBlock;

@end

NS_ASSUME_NONNULL_END
