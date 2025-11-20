//
//  ZGropuSetBasicInfoVC.h
//  CIMKit
//
//  Created by cusPro on 2022/11/7.
//

#import "BBBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZGroupSetBasicInfoVC : BBBaseViewController

@property (nonatomic,strong)LingIMGroup * groupInfoModel;

- (void)reloadCurData;

@end

NS_ASSUME_NONNULL_END
