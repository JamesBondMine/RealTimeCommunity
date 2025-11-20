//
//  ZChatGitImgCollectionCell.h
//  CIMKit
//
//  Created by cusPro on 2023/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZChatGitImgCollectionCellDelegate <NSObject>

- (void)collectionStickersLongTapAction:(NSIndexPath *)indexPath;

@end

@interface ZChatGitImgCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, assign) NSInteger cellTotalIndex;
@property (nonatomic, strong) LingIMStickersModel *collectModel;
@property (nonatomic, weak) id <ZChatGitImgCollectionCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
