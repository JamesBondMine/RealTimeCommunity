//
//  ZChatNavLinkAddView.h
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

#import <UIKit/UIKit.h>
#import "ZChatTagModel.h"

NS_ASSUME_NONNULL_BEGIN

//弹窗类型
typedef NS_ENUM(NSUInteger, ChatLinkAddViewType) {
    ChatLinkAddViewTypeAdd = 1,   //添加
    ChatLinkAddViewTypeEdit = 2,  //编辑
};

@interface ZChatNavLinkAddView : UIView

@property (nonatomic, copy) void(^newTagFinsihBlock)(NSInteger tagId, NSString *tagName, NSString *tagUrl, NSInteger updateIndex);
@property (nonatomic, assign) NSInteger updateIndex;
@property (nonatomic, assign) ChatLinkAddViewType viewType;
@property (nonatomic, strong) ZChatTagModel *editTagModel;
@property (nonatomic, copy) NSString *defaultUrlStr;

- (void)linkAddViewShow;
- (void)linkAddViewDismiss;

@end

NS_ASSUME_NONNULL_END
