//
//  ZGroupQRCodeVC.h
//  CIMKit
//
//  Created by cusPro on 2022/11/7.
//

#import "BBBaseViewController.h"
#import "LingIMGroup.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZGroupQRCodeVC : BBBaseViewController

@property (nonatomic, strong)LingIMGroup * groupInfoModel;
@property (nonatomic, copy)NSString *qrcoceContent;
@property (nonatomic, assign) NSInteger expireTime; //过期时间
@end

NS_ASSUME_NONNULL_END
