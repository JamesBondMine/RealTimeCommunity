//
//  ZCallFloatView.h
//  CIMKit
//
//  Created by cusPro on 2023/5/24.
//

// 即构 单人 音视频通话 最小化控件

#import <UIKit/UIKit.h>
#import "ZCallUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCallFloatView : UIView
@property (nonatomic, strong) ZCallUserModel *userModel;
@end

NS_ASSUME_NONNULL_END
