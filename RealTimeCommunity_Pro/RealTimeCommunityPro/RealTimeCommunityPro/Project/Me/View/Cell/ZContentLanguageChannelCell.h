//
//  ZContentLanguageChannelCell.h
//  CIMKit
//
//  Created by cusPro on 2023/9/14.
//

#import "ZBaseCell.h"
#import "MeTranslateChannelLanguageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZContentLanguageChannelCell : ZBaseCell

@property (nonatomic, strong) MeTranslateChannelLanguageModel *channelModel;
@property (nonatomic, strong) ZTranslateLanguageModel *languageModel;
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
