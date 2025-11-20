//
//  ZTranslateDefaultModel.h
//  CIMKit
//
//  Created by cusPro on 2024/2/18.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTranslateDefaultModel : ZBaseModel
@property(nonatomic, copy)NSString *sendChannel;
@property(nonatomic, copy)NSString *sendChannelName;
@property(nonatomic, copy)NSString *sendTargetLang;
@property(nonatomic, copy)NSString *sendTargetLangName;
@property(nonatomic, copy)NSString *receiveChannel;
@property(nonatomic, copy)NSString *receiveChannelName;
@property(nonatomic, copy)NSString *receiveTargetLang;
@property(nonatomic, copy)NSString *receiveTargetLangName;
@end

NS_ASSUME_NONNULL_END
