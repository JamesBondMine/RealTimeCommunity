//
//  MeTranslateChannelLanguageModel.h
//  CIMKit
//
//  Created by cusPro on 2024/8/7.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZTranslateLanguageModel : ZBaseModel

@property(nonatomic, copy)NSString *slug;//语种类型
@property(nonatomic, copy)NSString *name;//语种名称
@property(nonatomic, copy)NSString *inner;
@property(nonatomic, assign)BOOL target;
@property(nonatomic, assign)BOOL popular;

@end


@interface MeTranslateChannelLanguageModel : ZBaseModel

@property(nonatomic, copy)NSString *channelId;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)NSInteger qps;
@property(nonatomic, strong)NSArray *lang_table;

@end

NS_ASSUME_NONNULL_END
