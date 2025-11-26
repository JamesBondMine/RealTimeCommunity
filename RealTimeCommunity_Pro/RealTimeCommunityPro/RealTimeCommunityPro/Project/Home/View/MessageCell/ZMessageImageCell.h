//
//  ZMessageImageCell.h
//  CIMKit
//
//  Created by cusPro on 2022/9/28.
//

#import "ZMessageContentBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMessageImageCell : ZMessageContentBaseCell

/// UI仅控制：进入屏内时启动动图播放
- (void)startGifPlayback;
/// UI仅控制：离屏/复用时停止动图播放
- (void)stopGifPlayback;

@end

NS_ASSUME_NONNULL_END
