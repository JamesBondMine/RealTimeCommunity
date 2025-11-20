//
//  ZMediaCallMoreVideoItem.h
//  CIMKit
//
//  Created by cusPro on 2023/2/6.
//

#import <UIKit/UIKit.h>
#import "MCMediaCallGroupMemberModel.h"
#import "ZMediaCallMoreContentView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ZMediaCallMoreVideoItemDelegate <NSObject>
- (void)mediaCallMoreVideoItemDelete:(MCMediaCallGroupMemberModel *)model;
@end

@interface ZMediaCallMoreVideoItem : UICollectionViewCell
@property (nonatomic, strong) MCMediaCallGroupMemberModel *model;
@property (nonatomic, strong) ZMediaCallMoreContentView *viewContent;
@property (nonatomic, weak) id <ZMediaCallMoreVideoItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
