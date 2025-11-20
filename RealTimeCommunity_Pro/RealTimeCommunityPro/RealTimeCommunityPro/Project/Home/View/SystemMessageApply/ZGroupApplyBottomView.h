//
//  ZGroupApplyBottomView.h
//  CIMKit
//
//  Created by cusPro on 2023/5/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZGroupApplyBottomViewDelegate <NSObject>

@optional
- (void)allSelectButtonAction:(BOOL)selected;
- (void)refuseJoinApplyAction;
- (void)agreeJoinApplyAction;

@end

@interface ZGroupApplyBottomView : UIView

@property (nonatomic, assign) BOOL allSelected;
@property (nonatomic, weak) id <ZGroupApplyBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
