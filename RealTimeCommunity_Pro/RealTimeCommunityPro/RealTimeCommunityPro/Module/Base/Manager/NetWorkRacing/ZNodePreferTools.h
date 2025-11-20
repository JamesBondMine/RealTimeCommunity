//
//  ZNodePreferTools.h
//  CIMKit
//
//  Created by cusPro on 2024/10/24.
//

#import <Foundation/Foundation.h>
#import "ZNetRacingModel.h"

NS_ASSUME_NONNULL_BEGIN

//节点竞速接口
#define App_Http_Node_Prefer_Url      @"/zlcpig"

@interface ZNodePreferTools : NSObject

@property (nonatomic, copy)NSString *liceseId;
@property (nonatomic, assign)NSInteger preferDuring;
@property (nonatomic, strong)NSArray<ZNetRacingItemModel *> *httpArr;

- (void)startNodePrefer;

@end

NS_ASSUME_NONNULL_END
