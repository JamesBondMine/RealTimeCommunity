//
//  ZImagePickerBrowserVC.h
//  CIMKit
//
//  Created by cusPro on 2022/9/30.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZImagePickerBrowserVCDelegate <NSObject>
@optional
- (void)browserVCDelegateBack;//返回
- (void)browserVCDelegateSure;//确定
@end

@interface ZImagePickerBrowserVC : BBBaseViewController

@property (nonatomic, assign) NSInteger maxSelectNum;//最大选择数
@property (nonatomic, assign)  NSInteger selectIndex;//选择的索引值
@property (nonatomic, weak) id<ZImagePickerBrowserVCDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *listAssets;

@end

NS_ASSUME_NONNULL_END
