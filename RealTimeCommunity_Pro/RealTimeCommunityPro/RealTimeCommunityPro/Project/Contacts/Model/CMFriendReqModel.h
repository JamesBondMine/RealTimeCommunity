//
//  CMFriendReqModel.h
//  CIMKit
//
//  Created by cusPro on 2024/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMFriendReqModel : ZBaseModel
@property (nonatomic, strong) NSString *hashKey;
@property (nonatomic, assign) NSInteger beStatus;
@property (nonatomic, strong) NSString *latestUpdateTime;
@end

NS_ASSUME_NONNULL_END
