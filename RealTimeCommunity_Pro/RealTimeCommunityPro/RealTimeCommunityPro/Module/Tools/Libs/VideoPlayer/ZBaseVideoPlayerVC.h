//
//  ZBaseVideoPlayerVC.h
//  CIMKit
//
//  Created by cusPro on 2022/9/24.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZBaseVideoPlayerVC : BBBaseViewController
//视频封面地址
@property (nonatomic, copy) NSString *videoCoverUrl;
//视频地址
@property (nonatomic, copy) NSString *videoUrl;
@end

NS_ASSUME_NONNULL_END
