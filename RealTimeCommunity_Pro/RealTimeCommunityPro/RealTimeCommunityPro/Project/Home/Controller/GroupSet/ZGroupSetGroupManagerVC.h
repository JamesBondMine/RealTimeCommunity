//
//  ZGroupSetGroupManagerVC.h
//  CIMKit
//
//  Created by cusPro on 2022/11/16.
//

#import "BBBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZGroupSetGroupManagerVC : BBBaseViewController

@property (nonatomic,strong)LingIMGroup * groupInfoModel;
@property (nonatomic,strong)NSArray * mangerIdArr;

@end

NS_ASSUME_NONNULL_END
