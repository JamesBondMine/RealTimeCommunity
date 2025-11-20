//
//  ZRaceCheckErrorModel.h
//  CIMKit
//
//  Created by cusPro on 2024/5/11.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZRaceCheckErrorModel : ZBaseModel

@property (nonatomic, copy)NSString *host;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *serverMsg;
@property (nonatomic, copy)NSString *traceId;
@property (nonatomic, copy)NSString *httpCode;
@property (nonatomic, assign)NSInteger sort;

@end

NS_ASSUME_NONNULL_END
