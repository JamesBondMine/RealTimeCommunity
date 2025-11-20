//
//  ZChatHistoryMediaCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/14.
//

// 聊天历史 多媒体Cell

#import <UIKit/UIKit.h>
#import "BBBaseImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZChatHistoryMediaCell : UICollectionViewCell
@property (nonatomic, copy)NSString *sessionID;
@property (nonatomic, strong) LingIMChatMessageModel *chatMessageModel;

@property (nonatomic, strong) BBBaseImageView *ivMedia;
@property (nonatomic, strong) UIView *viewVideo;
@property (nonatomic, strong) UIImageView *ivVideo;
@property (nonatomic, strong) UILabel *lblVideoTime;
@end

NS_ASSUME_NONNULL_END
