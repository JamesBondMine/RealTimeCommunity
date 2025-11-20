//
//  ZMessageVoiceCell.h
//  CIMKit
//
//  Created by cusPro on 2023/1/5.
//

#import "ZMessageContentBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMessageVoiceCell : ZMessageContentBaseCell

@property(nonatomic, assign, readonly) BOOL isAnimation;

- (void)startAnimation;
- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
