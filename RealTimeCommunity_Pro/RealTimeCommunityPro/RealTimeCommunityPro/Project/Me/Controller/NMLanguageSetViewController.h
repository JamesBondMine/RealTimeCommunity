//
//  NMLanguageSetViewController.h
//  CIMKit
//
//  Created by cusPro on 2022/12/28.
//

#import "BBBaseViewController.h"

//设置语言后，修改UI类型
typedef NS_ENUM(NSUInteger, LanguageChangeUIType) {
    LanguageChangeUITypeLogin = 1,         //更新登录页
    LanguageChangeUITypeTabbar = 2,        //更新Tabbar页
};

NS_ASSUME_NONNULL_BEGIN

@interface NMLanguageSetViewController : BBBaseViewController
@property (nonatomic, assign) LanguageChangeUIType changeType;
@end

NS_ASSUME_NONNULL_END
