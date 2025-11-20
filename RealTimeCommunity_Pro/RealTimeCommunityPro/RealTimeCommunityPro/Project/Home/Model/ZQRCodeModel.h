//
//  ZQRCodeModel.h
//  CIMKit
//
//  Created by cusPro on 2025/8/8.
//

#import <Foundation/Foundation.h>
#import "ZBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZQRCodeModel : ZBaseModel
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger expireTime;
@end

NS_ASSUME_NONNULL_END
