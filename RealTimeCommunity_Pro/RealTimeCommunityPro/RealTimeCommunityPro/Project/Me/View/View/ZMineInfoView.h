//
//  ZMineInfoView.h
//  CIMKit
//
//  Created by cusPro on 2023/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZMineInfoViewDelegate <NSObject>
//200头像 201我的二维码 202签到
- (void)mineInfoAction:(NSInteger)actionTag;
@end

@interface ZMineInfoView : UIView
@property (nonatomic, weak) id <ZMineInfoViewDelegate> delegate;
@property (nonatomic, strong) ZUserModel *mineModel;//我的信息
@end

NS_ASSUME_NONNULL_END
