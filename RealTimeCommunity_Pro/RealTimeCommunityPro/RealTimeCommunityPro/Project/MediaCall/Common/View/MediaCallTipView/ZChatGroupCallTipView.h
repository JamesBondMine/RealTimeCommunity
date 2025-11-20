//
//  ZChatGroupCallTipView.h
//  CIMKit
//
//  Created by cusPro on 2023/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZChatGroupCallTipView : UIView
@property (nonatomic, copy) NSString *groupID;//群组ID

- (void)updateUI;

@end

@interface ZChatGroupMemberItem : UICollectionViewCell
@property (nonatomic, copy) NSString *userUid;
@property (nonatomic, strong) UIImageView *ivHeader;



@end
NS_ASSUME_NONNULL_END
