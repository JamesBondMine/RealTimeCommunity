//
//  NFFriendGroupDeleteView.h
//  CIMKit
//
//  Created by cusPro on 2023/7/4.
//

// 删除 好友分组 View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NFFriendGroupDeleteViewDelegate <NSObject>
- (void)friendGroupDelete:(LingIMFriendGroupModel *)friendGroupDelete;
@end

@interface NFFriendGroupDeleteView : UIView

@property (nonatomic, weak) id <NFFriendGroupDeleteViewDelegate> delegate;
@property (nonatomic, strong) LingIMFriendGroupModel *friendGroupModel;

- (void)deleteViewShow;
- (void)deleteViewDismiss;
@end

NS_ASSUME_NONNULL_END
