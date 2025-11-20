//
//  ZPresentView.h
//  CIMKit
//
//  Created by cusPro on 2022/9/3.
//

#import <UIKit/UIKit.h>
#import "ZPresentItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZPresentView : UIView

typedef void(^DoneActionBlock)(NSInteger index);
typedef void(^CancleActionBlock)(void);

//灰色半透明背景
@property (nonatomic, strong) UIControl *control;
//弹窗白色背景
@property (nonatomic, strong) UIView *presentView;
//点击回调
@property (nonatomic, copy) DoneActionBlock doneActionBlock;
@property (nonatomic, copy) CancleActionBlock cancleActionBlock;
@property (nonatomic, strong) ZPresentItem *titleItem;
@property (nonatomic, strong) NSArray <ZPresentItem *>*selectItems;
@property (nonatomic, strong) ZPresentItem *cancleItem;

- (instancetype)initWithFrame:(CGRect)frame titleItem:(ZPresentItem * _Nullable)titleItem selectItems:(NSArray <ZPresentItem *>* _Nullable)selectItems cancleItem:(ZPresentItem * _Nonnull)cancleItem doneClick:(DoneActionBlock _Nullable)doneClick cancleClick:(CancleActionBlock _Nullable)cancleClick;

- (instancetype)initWithFrame:(CGRect)frame custom:(UIView*)customView  doneClick:(DoneActionBlock _Nullable)doneClick cancleClick:(CancleActionBlock _Nullable)cancleClick;

//显示面板
- (void)showPresentView;

//关闭面板
- (void)dismissPresentView;

@end

NS_ASSUME_NONNULL_END
