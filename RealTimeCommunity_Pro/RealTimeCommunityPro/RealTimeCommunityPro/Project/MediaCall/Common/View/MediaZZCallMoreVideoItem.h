//
//  MediaZZCallMoreVideoItem.h
//  CIMKit
//
//  Created by cusPro on 2023/2/6.
//

#import <UIKit/UIKit.h>
#import "MCMediaCallGroupMemberModel.h"
#import "MediaZZCallMoreContentView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MediaZZCallMoreVideoItemDelegate <NSObject>
- (void)mediaCallMoreVideoItemDelete:(MCMediaCallGroupMemberModel *)model;
@end

@interface MediaZZCallMoreVideoItem : UICollectionViewCell
@property (nonatomic, strong) MCMediaCallGroupMemberModel *model;
@property (nonatomic, strong) MediaZZCallMoreContentView *viewContent;
@property (nonatomic, weak) id <MediaZZCallMoreVideoItemDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
