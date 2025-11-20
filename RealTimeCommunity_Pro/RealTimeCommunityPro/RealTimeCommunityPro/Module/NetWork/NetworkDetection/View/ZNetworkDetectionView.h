//
//  ZNetworkDetectionView.h
//  RealTimeCommunityPro
//
//  Created by phl on 2025/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZNetworkDetectionHandle;
@interface ZNetworkDetectionView : UIView

/// init方法
/// - Parameters:
///   - frame: frame
///   - dataHandle: ZNetworkDetectionHandle类
- (instancetype)initWithFrame:(CGRect)frame
                   dataHandle:(ZNetworkDetectionHandle *)dataHandle;

@end

NS_ASSUME_NONNULL_END
