//
//  ZGestureLockView.h
//  CIMKit
//
//  Created by cusPro on 2023/4/23.
//

#import <UIKit/UIKit.h>
@class ZGestureLockView;

NS_ASSUME_NONNULL_BEGIN


#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@protocol ZGestureLockViewDelegate <NSObject>
- (void)gestureLockViewFinishWith:(NSMutableString *)gesturePassword;
@end

@interface ZGestureLockView : UIView
@property (nonatomic, weak) id <ZGestureLockViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
