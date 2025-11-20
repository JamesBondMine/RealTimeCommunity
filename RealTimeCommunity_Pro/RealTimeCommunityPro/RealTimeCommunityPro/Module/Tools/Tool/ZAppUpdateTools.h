//
//  ZAppUpdateTools.h
//  CIMKit
//
//  Created by cusPro on 2023/4/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZAppUpdateTools : NSObject

+ (void)getAppUpdateInfoWithShowDefaultTips:(BOOL)isShow completion:(void (^)(BOOL))completion;


@end

NS_ASSUME_NONNULL_END
