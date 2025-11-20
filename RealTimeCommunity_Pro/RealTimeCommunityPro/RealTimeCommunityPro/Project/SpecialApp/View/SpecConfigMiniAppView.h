//
//  SpecConfigMiniAppView.h
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

//新增 / 编辑 小程序

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZConfigMiniAppType) {
    ZConfigMiniAppTypeAdd = 1,      //新增小程序
    ZConfigMiniAppTypeEdit = 2,     //编辑小程序
};

@protocol SpecConfigMiniAppViewDelegate <NSObject>
//小程序创建成功回调
- (void)configMiniAppCreateWith:(LingIMMiniAppModel *)miniApp;
//小程序编辑成功回调
- (void)configMiniAppEditWith:(LingIMMiniAppModel *)miniApp;
@end

@interface SpecConfigMiniAppView : UIView

@property (nonatomic, weak) id <SpecConfigMiniAppViewDelegate> delegate;

@property (nonatomic, strong) LingIMMiniAppModel *miniAppModel;

- (instancetype)initMiniAppWith:(ZConfigMiniAppType)configType;
- (void)configMiniAppShow;
- (void)configMiniAppDismiss;

@end

NS_ASSUME_NONNULL_END
