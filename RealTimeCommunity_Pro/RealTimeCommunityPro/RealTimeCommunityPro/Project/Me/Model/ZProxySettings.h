//
//  ZProxySettings.h
//  CIMKit
//
//  Created by 小梦雯 on 2025/4/16.
//

#import <Foundation/Foundation.h>
#import "ZBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZProxySettings : ZBaseModel
@property (nonatomic, assign) ProxyType type;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@end

NS_ASSUME_NONNULL_END
