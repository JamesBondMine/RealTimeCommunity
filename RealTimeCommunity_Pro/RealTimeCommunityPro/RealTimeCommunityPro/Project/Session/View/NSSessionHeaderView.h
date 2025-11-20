//
//  NSSessionHeaderView.h
//  CIMKit
//
//  Created by cusPro on 2022/11/2.
//

#import <UIKit/UIKit.h>
#import "BBBaseImageView.h"
#import "BBBaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

// 会话点击回调
typedef void(^NSSessionHeaderViewDidSelectBlock)(LingIMSessionModel *sessionModel);

@interface NSSessionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) NSMutableArray *sessionTopList;
// 会话点击回调
@property (nonatomic, copy) NSSessionHeaderViewDidSelectBlock didSelectSessionBlock;
@end


//H73
@interface ZSessionHeaderItem : BBBaseCollectionCell
@property (nonatomic, strong) BBBaseImageView *ivHeader;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) LingIMSessionModel *sessionModel;
@end
NS_ASSUME_NONNULL_END
