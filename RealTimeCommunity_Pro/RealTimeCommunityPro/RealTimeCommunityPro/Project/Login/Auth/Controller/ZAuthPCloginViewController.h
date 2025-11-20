//
//  ZAuthPCloginViewController.h
//  CIMKit
//
//  Created by cusPro on 2023/4/3.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAuthPCloginViewController : BBBaseViewController

//二维码解析出来的 需要登录的设备id
@property (nonatomic, copy)NSString *deviceUuidStr;
//本次扫码的二维码唯一ID    
@property (nonatomic, copy)NSString *ewmKeyStr;

@end

NS_ASSUME_NONNULL_END
